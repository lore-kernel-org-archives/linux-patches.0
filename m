Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F0D1F8936;
	Tue,  3 Dec 2024 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239992; cv=none; b=iTSASMLF84uBG8BKcH8lvP3yw1XtCtMR+ChG2FyQkJ4/iLq37PEMP4rXBizRsZPdeYbuqsFg7u46YuQ6iHBGsJ3RrktUyDykBF+Lmske923DfIz7uy9lv4NOwgQPL+XYriJ/0572/slJfQbeQ2Z9OmiudZ8I+lURpDAk3dZ/RsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239992; c=relaxed/simple;
	bh=9wVB4P2ucOCIynlUaidLUIv+CJzFrItuwhJUpJw4jlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFZ2hdGRnSUlSw36Ytdd5qeBRvzxD1CZXTtZd2n0YBUnevelTLYmXRmVUyIZGCqPQ9gNL+r/MiSd70q0VL7ZAS8LHRwxC05V/A5N37MKxN4l8rMUpQ38fqRLNPu/9AqVDNJRQM4jNORAljREJ7pPhB15OSS5BCuCzVWtOznL4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKz3S6J4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKz3S6J4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84A9C4CED6;
	Tue,  3 Dec 2024 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239992;
	bh=9wVB4P2ucOCIynlUaidLUIv+CJzFrItuwhJUpJw4jlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKz3S6J4rt8sPZEJAuioGrhSwySpBJWx3b3Yrejg+Z66glyBxO42Pzu6W4MLrfeoZ
	 hn749fJHlIF/P0kClriyCA/mNk/FO0KGAJtkAH38Z6D6PzcSA5CaPC6i35xt/G3XJd
	 1AA7GK/QlMDX7v8kVh242KBB1LJgwEP5Cvx37RmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 804/817] cifs: unlock on error in smb3_reconfigure()
Date: Tue,  3 Dec 2024 15:46:16 +0100
Message-ID: <20241203144027.834976177@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cda88d2fef7aa7de80b5697e8009fcbbb436f42d ]

Unlock before returning if smb3_sync_session_ctx_passwords() fails.

Fixes: 7e654ab7da03 ("cifs: during remount, make sure passwords are in sync")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e84660b48d533..e9fe48a3625ba 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -978,8 +978,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 	 * later stage
 	 */
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
 		return rc;
+	}
 
 	/*
 	 * now that allocations for passwords are done, commit them
-- 
2.43.0



