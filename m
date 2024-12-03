Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB5A1EF0AE;
	Tue,  3 Dec 2024 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239343; cv=none; b=IZbVYmAub9ZWrj9H9eSV0cuBbOsfDS8glLvLFXz/zKTdhdJhj0Ah/BtMwK74TkXqsY0+cbFF2NqYIwh0lgTmelrZwub2vP3nM6WJ5loiwwUNKP5qPByc/y5sC+iaTNDLQM3gcvZOvhhENvcG7J48cSjH9LLuzO9HzuI0O4369rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239343; c=relaxed/simple;
	bh=Od3nrKjAaffNDou8ObsEJx4Ytq/nFFF9xESNocKVTPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5bqW2G0kxmIPsl6vlsRfPYYmYIgFqtq3T95B4SNtejB/IRZRq5OWXx1HKamauMXBib/7faZnpx/h70ckE7RkMoCg4pa40qyA64aOAm/DlSZTTRurG/pBVZXfPHSLaRMBe39n6F+BMSYbLyMCBNtqUrdzKBtz9RSurhEYiIOnZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtoMcDaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtoMcDaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57407C4CECF;
	Tue,  3 Dec 2024 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239343;
	bh=Od3nrKjAaffNDou8ObsEJx4Ytq/nFFF9xESNocKVTPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtoMcDaInTfpQdYCnXJ2b95z0+qyYQDYbCp+IkKmTK71sBxJYfd01CIPmIhd8oaRE
	 ixni7qyQQ86e/uPsM6sVyvLZJvtql42+0E9nf3FM/lTQ02uFkbrKFSTk8pnihmLK3h
	 3rUQyYLp9ZMVb99nLbjB9mzIZCTLHWcDycUW80ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 540/817] NFSD: Prevent NULL dereference in nfsd4_process_cb_update()
Date: Tue,  3 Dec 2024 15:41:52 +0100
Message-ID: <20241203144016.983100814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1e02c641c3a43c88cecc08402000418e15578d38 ]

@ses is initialized to NULL. If __nfsd4_find_backchannel() finds no
available backchannel session, setup_callback_client() will try to
dereference @ses and segfault.

Fixes: dcbeaa68dbbd ("nfsd4: allow backchannel recovery")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index d756f443fc444..e6183097517ff 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1455,6 +1455,8 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
+	if (!c)
+		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.43.0



