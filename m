Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BBE1F667E;
	Tue,  3 Dec 2024 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236669; cv=none; b=a0ZHnRNqem6oEcIM0w2x+NI7HXvn1Jed7laKBSl9D7rzjTpiXItYRL8AiEg60G5mADNqI0cFJiDlbCYm0B2U4C9CE2pVGvacPiHfi+eECcEKRZcFjBkp44Y5CbmtIOAPjP0TShASIAI0NAP1Gf78ZOXW5EP+5zXTO/cUpijFHUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236669; c=relaxed/simple;
	bh=T8TgBymaduZyAGsnZUs0BoyjPgAs4BAZ0jI8NRZK6So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEu1Mfp72+6S+w2AQ1EY9RD8FXmin6Bm7lvrJKyYb5/2qlA5kD/d0mufHSodEhL6c3IcpWSerl3kvu6lyPkgfCUVtASiZ6NK7kuq5Bxa60hztOD5Yl7FmpZJCg/IrNPVyEHQsvfts2TP9EE7Dx4IOLLcChobpDpOwGLXZZQe0U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEEZjh14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEEZjh14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4646FC4CECF;
	Tue,  3 Dec 2024 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236669;
	bh=T8TgBymaduZyAGsnZUs0BoyjPgAs4BAZ0jI8NRZK6So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEEZjh14NlRI78JQaQk2Umis3DoKiv9hjylWvTcxLXXu4oM0pRb0+JE+b0TGENgBh
	 2My1B/QjN3qfsKqCbdSTKVeKMwGai+Bur5jU6vqnMv4j1ltCpKFbmzQKt7vYIjzj75
	 zqtGvKnmdnwAmGPF2lKTjo8TwyDg/e2uYySl4dRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/138] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Tue,  3 Dec 2024 15:31:55 +0100
Message-ID: <20241203141926.857948950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f64ea4af43161bb86ffc77e6aeb5bcf5c3229df0 ]

It's only current caller already length-checks the string, but let's
be safe.

Fixes: 0964a3d3f1aa ("[PATCH] knfsd: nfsd4 reboot dirname fix")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 5188f9f70c78c..e986e9e0c93f7 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -596,7 +596,8 @@ nfs4_reset_recoverydir(char *recdir)
 		return status;
 	status = -ENOTDIR;
 	if (d_is_dir(path.dentry)) {
-		strcpy(user_recovery_dirname, recdir);
+		strscpy(user_recovery_dirname, recdir,
+			sizeof(user_recovery_dirname));
 		status = 0;
 	}
 	path_put(&path);
-- 
2.43.0



