Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209088;
	b=Ht7adM3Sk5I/aVpHvOtTTxVmnpzu5nrwy+ti3ZYPKunr3UclRgZeQCAOfQlOv3L/6Z37
	 8ihcmWJxVc7zewfTgd8e9JeCz2t+j1wXd//aj7SSBREZGYKoCJVSO/O8/OvZKQRSK4Jr+
	 bRlegBeWGNkrRrN/BxWgU5iEadFJLYb+XrF9Rl7m3tHm8Z9UMqShAOJPHMBKiVHXJn2Gw
	 aO6XX0GCMxOCQMMfEzj7uUwDrzk0z6tRf2kIJnLfI4O0mpPel10Ir8l+BJkP468ZK43D2
	 9mZjhqbLwwvmpn1yrimINlhCdrpk74IYPGlB5e33cVrZEsJnrge46iFlUtajfb2xW/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lcr4aHDzAvUHq3QSLkIvN1igBIZEzOb9ssiJMcRMdW0=;
	b=fTYGN6o87Jsb9zit6d5RmatZj/6cWqTBnLvqZCCm1hEVg0SkHXzFsyDhNRheFOiANelA
	 9uojQyOYPix8ur6z4Z8zqzQFLZGkNzqvzH1gykPhidxQV42Jy6H8GPG1qsy/Zq54mkqjM
	 5YYNzA49++i2eY20qxITQbpBqioqp+X6q43xHIokvSopLT+53Ip7N/oafkdm4F/YuylCQ
	 7R4AnID9db0WaXZzFqDe9gaiMZO7Hpq7YTPhVkBvg8FVl3OdRscfAKsy+13u8l9h9x/yi
	 eBVjVVXGWwDRwnSj8ogaXF9oTMIDDPHqYTeZxLVymBoi8Si99XKpPmmoB8pltgdWynw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iR1RorB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3F6606A32D;
	Wed, 28 Oct 2026 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iR1RorB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5778A1F01825;
	Wed, 28 Oct 2026 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209087;
	bh=Lcr4aHDzAvUHq3QSLkIvN1igBIZEzOb9ssiJMcRMdW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iR1RorB8/jbbg7pIjiVY8iTklAFnjunfz7nbJi6YcF4XmF0my0LmX4A2slkbr+KHg
	 e2OHyfGB4FOy2pe9yYAF09ksxVyjJrDUJRgghIcptAYJX3PQu7cBin0yi6ABiXYaHD
	 x/U9xR0/l/ajv/IV742c5IH275sKJkffCJnr2ETE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 348/516] fs: refuse fspick() on internal superblocks
Date: Wed, 28 Oct 2026 17:58:20 +0100
Message-ID: <20261028170011.736679473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 02587a4af82adccaef8e3b3624b4e7f1c401632d upstream.

There's a few instances where a internal superblock is reachable by
fspick(). Block that. graft_tree() and fsmount() already refuse them.
fanotify refuses mount and superblock marks on them for the same reason.

Fixes: cf3cba4a429b ("vfs: syscall: Add fspick() to select a superblock for reconfiguration")
Cc: stable@vger.kernel.org # v5.2+
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-6-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fsopen.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -191,6 +191,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const
 	ret = -EINVAL;
 	if (target.mnt->mnt_root != target.dentry)
 		goto err_path;
+	/* kernel-internal superblocks are nobody's to reconfigure */
+	if (target.dentry->d_sb->s_flags & SB_NOUSER)
+		goto err_path;
 
 	fc = fs_context_for_reconfigure(target.dentry, 0, 0);
 	if (IS_ERR(fc)) {


