Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B43156F37;
	Tue, 23 Jul 2024 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759211; cv=none; b=RDFEnhiNiD0e5+wQ22CYNyxbpg1Xcs0BO2T3U5hkUEFpCQhWOKpJCSS7LHyEv7V+GARrUmPVM3z1QZXErQuMEpDDIe1vnjIY9UfQ1lgZPfMffhLwIOmrB+ynR5rnNW3JL2oeKhXjwwkIRwUa5hqNGnHRbBbS/EI+rgN8Xo+M3yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759211; c=relaxed/simple;
	bh=MVEelyOB38yHuvOmLfVQtR4a+2gbP5kuopLBLNETgP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3i1m0PRiqGHagfiIR/NcQzoLdFOR2Xtkzm8MWr52soMQ2hhGNV2zgbNg0P8h83UjIuyW5KoYwPkZlHcyT3IFaRrXyHeBvZRfoH5VtRA3XTU+jROLZFctCzQJU6kXNhVTTIq2LrfusS7vZWGT9G/oU7pCUfBz0u90JEIBuy+Ixo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTJ23VRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTJ23VRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C1C4AF0A;
	Tue, 23 Jul 2024 18:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759211;
	bh=MVEelyOB38yHuvOmLfVQtR4a+2gbP5kuopLBLNETgP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTJ23VRSTrC2XNE4DB9gqxY04eR2p1ljQsYl3oKN5m307bSDa5VbFV381JOWWcKji
	 BLGq6X7L6KjnboF599lCYaxgcW4mM15ud4xvOcTAwOICKq3Yoh94AxRmUQKn45UbAS
	 C9k3ZZNhUH65EgqPRyl1VRm86niNGHaOhUwP+Rco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/105] cachefiles: add consistency check for copen/cread
Date: Tue, 23 Jul 2024 20:23:17 +0200
Message-ID: <20240723180404.787182908@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit a26dc49df37e996876f50a0210039b2d211fdd6f ]

This prevents malicious processes from completing random copen/cread
requests and crashing the system. Added checks are listed below:

  * Generic, copen can only complete open requests, and cread can only
    complete read requests.
  * For copen, ondemand_id must not be 0, because this indicates that the
    request has not been read by the daemon.
  * For cread, the object corresponding to fd and req should be the same.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-7-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 51173ab6dbd84..c3241cede5289 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -97,12 +97,12 @@ static loff_t cachefiles_ondemand_fd_llseek(struct file *filp, loff_t pos,
 }
 
 static long cachefiles_ondemand_fd_ioctl(struct file *filp, unsigned int ioctl,
-					 unsigned long arg)
+					 unsigned long id)
 {
 	struct cachefiles_object *object = filp->private_data;
 	struct cachefiles_cache *cache = object->volume->cache;
 	struct cachefiles_req *req;
-	unsigned long id;
+	XA_STATE(xas, &cache->reqs, id);
 
 	if (ioctl != CACHEFILES_IOC_READ_COMPLETE)
 		return -EINVAL;
@@ -110,10 +110,15 @@ static long cachefiles_ondemand_fd_ioctl(struct file *filp, unsigned int ioctl,
 	if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
 		return -EOPNOTSUPP;
 
-	id = arg;
-	req = xa_erase(&cache->reqs, id);
-	if (!req)
+	xa_lock(&cache->reqs);
+	req = xas_load(&xas);
+	if (!req || req->msg.opcode != CACHEFILES_OP_READ ||
+	    req->object != object) {
+		xa_unlock(&cache->reqs);
 		return -EINVAL;
+	}
+	xas_store(&xas, NULL);
+	xa_unlock(&cache->reqs);
 
 	trace_cachefiles_ondemand_cread(object, id);
 	complete(&req->done);
@@ -142,6 +147,7 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	unsigned long id;
 	long size;
 	int ret;
+	XA_STATE(xas, &cache->reqs, 0);
 
 	if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
 		return -EOPNOTSUPP;
@@ -165,9 +171,16 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	if (ret)
 		return ret;
 
-	req = xa_erase(&cache->reqs, id);
-	if (!req)
+	xa_lock(&cache->reqs);
+	xas.xa_index = id;
+	req = xas_load(&xas);
+	if (!req || req->msg.opcode != CACHEFILES_OP_OPEN ||
+	    !req->object->ondemand->ondemand_id) {
+		xa_unlock(&cache->reqs);
 		return -EINVAL;
+	}
+	xas_store(&xas, NULL);
+	xa_unlock(&cache->reqs);
 
 	/* fail OPEN request if copen format is invalid */
 	ret = kstrtol(psize, 0, &size);
-- 
2.43.0



