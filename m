Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426123A963E;
	Thu, 17 Sep 2026 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660577; cv=none; b=FZUpEpyKoGJZ0Oor0n8ghBmbX+FgbNhWTJq7Fmr+hX/zzYpLmtFORsT7KPvR5RaRGs/3BmO+s7ikmAvyfqo3HB0/JGNcbiw2GWY39oQ1za8WDETh50Avk033dE/jAuthhduGhw1a/FKK1ADmeLvjC9NyWwj0IF1Yf2XemmEDumc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660577; c=relaxed/simple;
	bh=OF7+EQrQshQEBY3bDf3MfW7fOtL0bkzZv4vAq4hwgs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4Oor5DTXRe9O/IqzMOy2IAvGSMItjZ3kI/UWWnOWfdsPBVtwNfNzqngqGxU3gSCbYSOPeiy0XzZzcjuYrI6DXKYWCrQAb5CMkcKMBV/aKDYQyI2Hf4hGZz9991vR43b+toEK8FwGx9f6bIvchUSbbReuiw2C8sfSsk5Ifire7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYd6FdwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYd6FdwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986BC1F000FF;
	Thu, 17 Sep 2026 15:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660576;
	bh=cDLcrGhfp8iVjSO9FUnLEW87yOJuOaJqwNM5h+yTBq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYd6FdwK3481QA+zgxbO6epc6KQhV+9m7+aGm5LYU+vqoPL2N56CRhKxAMlE4J/HL
	 42slcs1VNymo1uVCorDv/aYJcDKNgJC6oBIDN6MoaNt+MxnL9he+RX/3/56FCET4Xh
	 ywlPjaQ9ePsoR6kteryC23HJ5h7hcNiW8wZY6NHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 638/733] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
Date: Thu, 17 Sep 2026 16:15:46 +0100
Message-ID: <20260917151408.482516798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3331,8 +3331,11 @@ void cifs_oplock_break(struct work_struc
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
 


