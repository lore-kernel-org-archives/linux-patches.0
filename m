Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7E8757E4;
	Mon, 15 Apr 2024 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191028; cv=none; b=lLxfRP5nW/z6v9HUdZfN7XBytRLulaknBRKw/dFJrHyob7VUpSobt/fiavrmloniH3pcXJNy7cRwuaVWnHR/sTISxWaQm/qlp5RJc7tXJsL7Kaz8qvqBe06mG39y+KyxaDoIHu0S+BrBY7Z1nTTy4FH4xM7FigG2CNH2LZmsqxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191028; c=relaxed/simple;
	bh=1gK6BcgOAHefukptKnoRo6mv2VfTnwZCzUW1nVb3+BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihQvuIXI/3Qu/ozoqY0e0qy+FXONHS6S+/0m8CletxX9z4zm7Y1uqb4pXYRepXhCjEjbM0GBR7X8IFPyC1tqwfdLHf3ivzlgjakDlFnMKtZx+kMbwzbF7g2r71cvuO8HbmcfGLiescpjmk7XduH/3xh1Fw87vXgFPtsb+cj9d7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRpFN1qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRpFN1qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE2C113CC;
	Mon, 15 Apr 2024 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191027;
	bh=1gK6BcgOAHefukptKnoRo6mv2VfTnwZCzUW1nVb3+BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRpFN1qo8DWptPE8oyprC9iDKBdunW3ZAtWhphfrZGUIPfKm+6ELU46+73Db85IyN
	 pfZd6XiLmljy75UFYwOjynffjIsfQXrPch4od2X0BrwDujSoggrx6SI8C5Y7Pi3adN
	 5QtUvxV48ki8H8CQQmTvVsf4JsNiP1xP7Cb+yNk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 001/172] smb3: fix Open files on server counter going negative
Date: Mon, 15 Apr 2024 16:18:20 +0200
Message-ID: <20240415142000.021608399@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 28e0947651ce6a2200b9a7eceb93282e97d7e51a upstream.

We were decrementing the count of open files on server twice
for the case where we were closing cached directories.

Fixes: 8e843bf38f7b ("cifs: return a single-use cfid if we did not get a lease")
Cc: stable@vger.kernel.org
Acked-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -433,8 +433,8 @@ smb2_close_cached_fid(struct kref *ref)
 	if (cfid->is_open) {
 		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
-		if (rc != -EBUSY && rc != -EAGAIN)
-			atomic_dec(&cfid->tcon->num_remote_opens);
+		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
+			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
 
 	free_cached_dir(cfid);


