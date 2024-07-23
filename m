Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638413D600;
	Tue, 23 Jul 2024 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760042; cv=none; b=U2txkRPbetvoAXFgXS8OVF1rIE5QYwPaQoIl9nFTzrXQCAWMj4YntBY3uKSE42eV7WpnivgynsaD/GTdZiGORvJXkvHYAsrNyAKObCTFmEtfLSQlWOcKx9SlbK59vlfE7jMph2gVNN14/HpL55s2fp3uEUnR8SBA2CAejqU+Ch4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760042; c=relaxed/simple;
	bh=p0rbzBoXSR5H/yW/GnckVWg+Mi/T9+/dvxD0HI8b/6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H74MmK1rPLDloovCYE2PZHmtqHavy0FcMoNCUzubjWAwAqOdTqSzh4ys6nCJYMRk3RFfnqEpSXMRkeYrPRYrN2l4C9N7u33h+4AnFruYB8SubG85B7enmtD0xYGPBoOua07Npi0ktbiqkkHYjAFWIlKpyaq5rtstvf5RbGUal6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEQktTKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEQktTKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0ADC4AF09;
	Tue, 23 Jul 2024 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760042;
	bh=p0rbzBoXSR5H/yW/GnckVWg+Mi/T9+/dvxD0HI8b/6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEQktTKvaOE/IN7MZVjDN9p7cz+9O+8t/cSi33wvcJ6VYGprfX9TT+iiN/4I3u04y
	 rKtjC1E4ULELRzA8K0Iu6QjpAsBAcyPEUxBHdQV85PNjFkASmTw7LLhkw+XPa1T4XJ
	 V9ZonqdDijhFkLzhMXc48MTgSJ1l+h1xrpJDB464=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 084/163] mips: fix compat_sys_lseek syscall
Date: Tue, 23 Jul 2024 20:23:33 +0200
Message-ID: <20240723180146.721214504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0d5679a0aae2d8cda72169452c32e5cb88a7ab33 ]

This is almost compatible, but passing a negative offset should result
in a EINVAL error, but on mips o32 compat mode would seek to a large
32-bit byte offset.

Use compat_sys_lseek() to correctly sign-extend the argument.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/syscalls/syscall_o32.tbl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 0352c07c608e9..fe76282a353f5 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -27,7 +27,7 @@
 17	o32	break				sys_ni_syscall
 # 18 was sys_stat
 18	o32	unused18			sys_ni_syscall
-19	o32	lseek				sys_lseek
+19	o32	lseek				sys_lseek			compat_sys_lseek
 20	o32	getpid				sys_getpid
 21	o32	mount				sys_mount
 22	o32	umount				sys_oldumount
-- 
2.43.0



