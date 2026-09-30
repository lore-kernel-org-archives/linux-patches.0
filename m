Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEFF3DA7DB;
	Wed, 30 Sep 2026 19:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795874; cv=none; b=eskH4u/D7wCuzx7VdqXXkVPoGKgZ0wSH6xTHadpMQCKY5ycaaryFEVoMilra7o60FUOtrsVQU1LEpjGgKtqQ9ddrn5aDY96ApskDgpbgo9cxzo5ksE63rhz+7b2PFBgRbpVEpnGTvXPWUVwVfVLNKsvEk37Rc4VaxvUbrnStu5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795874; c=relaxed/simple;
	bh=n192dAIzIsVgKl5YTaMcaSv9iToGFiNy6cLWv3LXRVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9OB1WXh2MldW0rNRXeH85NRbDb/+vpB5Px5ciP8fY/6PCBr9cOGHpYNLMn+tv7LMBtmvlIssT+Nt49pJBGhf2RSYev1yC5wuo3R2OWD8AgIOlufGviadBlo23owOUjoln2uzX4CeihfRy1xaCgnDPZoNxtxxxPZtq6B/r4DosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijtOkRfj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijtOkRfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3FA1F000FF;
	Wed, 30 Sep 2026 19:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795873;
	bh=ZoYZDhiaoK1rZ6GO9doeqXE1BLRiAHJEaRK3UeCQeZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijtOkRfjDfQ69oKKG7Iqe5xkfkeuVXu2nk28eaEVXB5LHhRskK3186TrG1FPEz7IH
	 uI5ZO1QwjYC8gXGl8KyycIL6x6pWqKYuHuRPsECfaoI+KmRe9EVjpVaFHTsDyhZV9D
	 2THM+dZ1QKD2RhmnZFMZXEnU6jXIJudyJwLs2hPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0669/1193] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
Date: Wed, 30 Sep 2026 17:22:33 +0200
Message-ID: <20260930152449.106899351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

commit 23b26f4408ac3f35a482d2e5cf6fc865d4201b71 upstream.

cifs_oplock_break() takes over the reference that
cifs_queue_oplock_break() acquired when it queued the work, and drops it
with _cifsFileInfo_put() once the break has been processed.

Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
point cifs_oplock_break() returns without putting the file reference,
mirroring the reference leak we already fixed in the companion patch to
cifs_queue_oplock_break().

This would trigger a crash due to busy inodes on the next unmount:

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)

Drop the reference on that path as well. Doing so before the out label
mirrors the normal path, which also puts the reference before
cifs_done_oplock_break().

Found by Sashiko code review. The failure path was not exercised at
runtime.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -5154,8 +5154,11 @@ void cifs_oplock_break(struct work_struc
 			TASK_UNINTERRUPTIBLE);
 
 	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
+	if (IS_ERR(tlink)) {
+		/* drop the reference taken when the break was queued */
+		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;
+	}
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 


