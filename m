Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A39E82886;
	Mon, 15 Apr 2024 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191676; cv=none; b=GD17eI3tTD/JE0IPagUvPoSdXpMRqt8g3BKQVMSwopY+UwwToz4nSYe3Xu9hw2LYnnx96TDw5uU6eOFbTrZoaaNjhQz5HyXADJNlilaFKW6tppJMYoZRWitPv6LGjMS3bMh6ENQZUQunzuTADpZE9w1xPtcLKt1H1C7lPyhyWdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191676; c=relaxed/simple;
	bh=7xD6QDx7PYLHgOGoYplRpfHEKY0a0zMmFPOk+1zk1CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbv9LquUyU2q6/vbRziVylY2jrw79Ln31qkqFwoNx58wmiaadKUEOoZAWeRAl02CZasnZPjW2j5c5+1JAG9UHRCFPkKW3LcPUJkSYedmL65n+1FF1FBBlJJk8f/Q43ZSwAjPGndFEKtxJstfbOpIT4TfNoCksQtKHNOkUaTqDYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEmJMRrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEmJMRrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D34C113CC;
	Mon, 15 Apr 2024 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191676;
	bh=7xD6QDx7PYLHgOGoYplRpfHEKY0a0zMmFPOk+1zk1CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEmJMRrIqwlSLdAKPqV2Z3DhGS1qQ1Zx71nE++IpXsqWM2EzJkR8QKXv67QZB56um
	 GQlHsl+2aQx00CscrAaW1twsGQ1kp6ftcUNVZ572+1aKSA3SR/6LCY3l8NHQT9gJj8
	 CEUIeFblQYvbPR2/jAt9RB0/1hyRGM1oRchc/imU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 001/122] smb3: fix Open files on server counter going negative
Date: Mon, 15 Apr 2024 16:19:26 +0200
Message-ID: <20240415141953.412246102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -417,8 +417,8 @@ smb2_close_cached_fid(struct kref *ref)
 	if (cfid->is_open) {
 		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
-		if (rc != -EBUSY && rc != -EAGAIN)
-			atomic_dec(&cfid->tcon->num_remote_opens);
+		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
+			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
 
 	free_cached_dir(cfid);


