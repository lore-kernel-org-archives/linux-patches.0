Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A529C762E0;
	Mon, 15 Apr 2024 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191923; cv=none; b=FHFRWjoSeQCy63+ax6eEksh6YeW5EsjmNNHeKJtERBXSWOosrI9mN003LSiVguzr+XycOJ6yJYeO/p2MBlpE/4OLbrJm3doUaOzTq5d9b1Cu4qljgEYCuKDZZjbJ+2782p1629mnFpMhaSowa6WySd6zQUy9Fb45q9J64CQqS2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191923; c=relaxed/simple;
	bh=nFRrqAdVTnU/cbMtGGVJOOVqCbbJwiwr+gapwQJnLq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zcah6QOmriggN0Plg54YdlcmWX/s1+V+h9wNfu4g/cA3xjk35lmRhDC6px5er9mIvGF3GAMWRw4Cv0a36FBumUTpUQcG4VDKmSYnTwV/kEHdFUcMmndZwv1MeKkZNoOPOLVBTyWVc1aBQZol4SJVv+b00acFlKO1HY7Aa68qlmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fd4fWKip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fd4fWKip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B156C113CC;
	Mon, 15 Apr 2024 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191923;
	bh=nFRrqAdVTnU/cbMtGGVJOOVqCbbJwiwr+gapwQJnLq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fd4fWKipt46agNboYOJ+8cpxrvmgT1mbl6l0ZPtpod6mp8MoIP9EQLe23pOSgI74R
	 9LY7VBuOWfnn4h0bOuios3EdypFsBjaRqN5RAbzgVzeFctvq61dvme6bPoSSZUVKLl
	 inoh2uwNn382tyQBx65Ld9B3wgTX+lx4Ojk8Mfcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 01/69] smb3: fix Open files on server counter going negative
Date: Mon, 15 Apr 2024 16:20:32 +0200
Message-ID: <20240415141946.212492625@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -386,8 +386,8 @@ smb2_close_cached_fid(struct kref *ref)
 	if (cfid->is_open) {
 		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
-		if (rc != -EBUSY && rc != -EAGAIN)
-			atomic_dec(&cfid->tcon->num_remote_opens);
+		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
+			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
 
 	free_cached_dir(cfid);


