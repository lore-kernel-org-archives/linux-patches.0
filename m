Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F7C1B6D08;
	Mon, 29 Dec 2025 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025560; cv=none; b=CYueWAFqGSCxIAqHP2p7B2Vh40H9BapnUf3ev4YmSx38tpCMKPZ+rWxsQs8DTAuCuqcQhjxXiyYmPj/qaSNzPBAjBy4Q5XMyujWzfL0pfuMHw/JgRlvRYY5+6SNOv2W/R3tKUDSEix97e1Zx0Ri2i0GMO7Pbb8SWin0vgEzZXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025560; c=relaxed/simple;
	bh=k4vtdMUdUyNx4XNDlvHCd+cOY4VfsuXCdbEUALCacvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLbnNYsxjTeV7vQ4P10YCFBu7VNn8/GYlvKALCV7qcAP9+KDirbO3amAAbpvcPbXqONj7/3RFAGf36EssOvSNRncUaI7Yu/zlHNo6B8NPDX0/Bo9OgVpByPDlQF89F2DDSre5ph0KJ/naYFSKpTMuBzfEQEhyd2azGG6Mofte04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElvEkhH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElvEkhH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99362C116C6;
	Mon, 29 Dec 2025 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025560;
	bh=k4vtdMUdUyNx4XNDlvHCd+cOY4VfsuXCdbEUALCacvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElvEkhH6xV5AJ2Rt01FYJ8CYTkQdR0kvRmJD5JoP//vAZqSVvRThZVKSp0bjhGfkk
	 ZLTEXuMRjYcXm7SkM31sqpHsQu23bNS2twt7OQWDKimJjEpvuQBGPmwK2tBi74nx1M
	 2XHie7MqeKX7LRKB+KiApvM9+gpDnRiKtODZs7Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.18 256/430] fs: PM: Fix reverse check in filesystems_freeze_callback()
Date: Mon, 29 Dec 2025 17:10:58 +0100
Message-ID: <20251229160733.776372640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 222047f68e8565c558728f792f6fef152a1d4d51 upstream.

The freeze_all_ptr check in filesystems_freeze_callback() introduced by
commit a3f8f8662771 ("power: always freeze efivarfs") is reverse which
quite confusingly causes all file systems to be frozen when
filesystem_freeze_enabled is false.

On my systems it causes the WARN_ON_ONCE() in __set_task_frozen() to
trigger, most likely due to an attempt to freeze a file system that is
not ready for that.

Add a logical negation to the check in question to reverse it as
appropriate.

Fixes: a3f8f8662771 ("power: always freeze efivarfs")
Cc: 6.18+ <stable@vger.kernel.org> # 6.18+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12788397.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -1188,7 +1188,7 @@ static void filesystems_freeze_callback(
 	if (!sb->s_op->freeze_fs && !sb->s_op->freeze_super)
 		return;
 
-	if (freeze_all_ptr && !(sb->s_type->fs_flags & FS_POWER_FREEZE))
+	if (!freeze_all_ptr && !(sb->s_type->fs_flags & FS_POWER_FREEZE))
 		return;
 
 	if (!get_active_super(sb))


