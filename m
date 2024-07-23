Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A4F15821E;
	Tue, 23 Jul 2024 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759940; cv=none; b=JJI1J9QmsA2/P80Ly8K/sc6D66rxdBhnBb+OnYKdAK7BkHRsp8UHPx8lHoYQeYFuIsfdWbmnbgKIOIFadz5gCx+vjjVMogKd1+zRdRBC6zuQJrqY2yJndgIihycZ6OLo2PsbSHC9rXL9R9cSsudfSokn3srUymphMC5opMNY3pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759940; c=relaxed/simple;
	bh=8SP/cr8boIeGnqyURH3kHsmECO0hx6ECb47M/34eCgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DASLZcB9gwitUl4fTytAtrgVirhHpp1V9eWE/z+sm/bebhQHMUbbH20/9MgcZYnde1aIlsMnGFCZ+G+QPod7QFYx5CvSgrXC3ut9c7uaPozl9XPooiIwB9QgNXoRuN50aXKVCiyvu5UifHPPIBtpsKmWgic5m0x9KMFsRp0TXZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYg+6f8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYg+6f8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19682C4AF0A;
	Tue, 23 Jul 2024 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759940;
	bh=8SP/cr8boIeGnqyURH3kHsmECO0hx6ECb47M/34eCgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYg+6f8/Jt/+yj3KkKBywdjgLeKXMNVv8/DeN3cuo1KTdoC0Z4IFfnwgkl6pzugVS
	 G9Xz0UgMy7U4XgzBiqR0IksVtSWWTWrF5WBHzzRkkrNqZxnEeMfVJOviJRkzcDiYdJ
	 bBq3mYuk/ykOoGnZXFJZ17DzNFeGhaSrAO9tRD5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 050/163] cachefiles: Set object to close if ondemand_id < 0 in copen
Date: Tue, 23 Jul 2024 20:22:59 +0200
Message-ID: <20240723180145.408640096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 4f8703fb3482f92edcfd31661857b16fec89c2c0 ]

If copen is maliciously called in the user mode, it may delete the request
corresponding to the random id. And the request may have not been read yet.

Note that when the object is set to reopen, the open request will be done
with the still reopen state in above case. As a result, the request
corresponding to this object is always skipped in select_req function, so
the read request is never completed and blocks other process.

Fix this issue by simply set object to close if its id < 0 in copen.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-11-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index ad6dc4f54ae7b..a0e34581a1cd6 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -182,6 +182,7 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	xas_store(&xas, NULL);
 	xa_unlock(&cache->reqs);
 
+	info = req->object->ondemand;
 	/* fail OPEN request if copen format is invalid */
 	ret = kstrtol(psize, 0, &size);
 	if (ret) {
@@ -201,7 +202,6 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 		goto out;
 	}
 
-	info = req->object->ondemand;
 	spin_lock(&info->lock);
 	/*
 	 * The anonymous fd was closed before copen ? Fail the request.
@@ -241,6 +241,11 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	wake_up_all(&cache->daemon_pollwq);
 
 out:
+	spin_lock(&info->lock);
+	/* Need to set object close to avoid reopen status continuing */
+	if (info->ondemand_id == CACHEFILES_ONDEMAND_ID_CLOSED)
+		cachefiles_ondemand_set_object_close(req->object);
+	spin_unlock(&info->lock);
 	complete(&req->done);
 	return ret;
 }
-- 
2.43.0



