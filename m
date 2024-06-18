Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BC713792B;
	Tue, 18 Jun 2024 13:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716558; cv=none; b=t209+zu1ZiyRJwumDoiaq5bxoU3x9S5nlY+6QJJFn9z052yR5zFpi47Lqn6p7Q4RPagNxCUCblratjZh3PO0nN7FW1FOL7qOTY76iKxG9v6ZW94FuzR8ZFlOgdtbO34/lFVOBQN8JrGBDBE1sRFgpS/1DX/DLvpaNEpO4wz6hFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716558; c=relaxed/simple;
	bh=Fe2+UAUUrD0wFCtYOo4jCe33egDnR3o062j/gXB3GHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYo7qHwEzEjAl6EKmoSMWS42Wwi9XVxhoAsNU3mn3+peldX2Zy3iVy8PZLQqq1SBHIyyhxhkLzsmoxYpkpvIf0odGzff1SSv9OsKLgRLvO5goVPyJYsGzDhiM3yumZZACWFre+/5bw9ZnvEugJBTq8MYrPXWc8RVV4/hVj4X6oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmVH2y2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmVH2y2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93529C3277B;
	Tue, 18 Jun 2024 13:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716558;
	bh=Fe2+UAUUrD0wFCtYOo4jCe33egDnR3o062j/gXB3GHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmVH2y2KBBPipX0rHFVQ6ovKhPQw3A4wy9KdO4wanRHGQVNWCVanP3AKdrwFi0mna
	 pp7f6qhP654OnuhU/cZeQjfHpZMqYubtdkf2UtddhH9/NWx2EgxiPCEhSJeBOzuBI1
	 FjYRfJNfPbaBmsJYGow5MYlJWYAjFmbL9osP1T5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 653/770] NFSD: Clean up WRITE arg decoders
Date: Tue, 18 Jun 2024 14:38:26 +0200
Message-ID: <20240618123432.493940297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d4da5baa533215b14625458e645056baf646bb2e ]

xdr_stream_subsegment() already returns a boolean value.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 4 +---
 fs/nfsd/nfsxdr.c  | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 71e32cf288854..3308dd671ef0b 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -571,10 +571,8 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		args->count = max_blocksize;
 		args->len = max_blocksize;
 	}
-	if (!xdr_stream_subsegment(xdr, &args->payload, args->count))
-		return false;
 
-	return true;
+	return xdr_stream_subsegment(xdr, &args->payload, args->count);
 }
 
 bool
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index aba8520b4b8b6..caf6355b18fa9 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -338,10 +338,8 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		return false;
 	if (args->len > NFSSVC_MAXBLKSIZE_V2)
 		return false;
-	if (!xdr_stream_subsegment(xdr, &args->payload, args->len))
-		return false;
 
-	return true;
+	return xdr_stream_subsegment(xdr, &args->payload, args->len);
 }
 
 bool
-- 
2.43.0



