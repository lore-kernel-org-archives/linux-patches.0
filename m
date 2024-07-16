Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A088E19DF88;
	Tue, 16 Jul 2024 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145339; cv=none; b=eCwENlgoaGgy1IhStyHoTFmjpdIasp5kQCrOuZU29JcjbyzDkoti5VMUK1EKWVnrpJu8dlg2y7WB+o3QMpBfSS9DTh9YTh0EygsaraYZ4BpPclzL9wes10ofZG6+H31hn1LX6k6HXr2sy/sxn2j6OPW3O8wj+h7r0HUazgvbh/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145339; c=relaxed/simple;
	bh=YRFWDfLN3keGcnYz2I0/tbsbINYlfWVFGOTfzseSmgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1UhzVh8n/sWUgTReQC89GxNrstdrAJVAl7sV6ZTxVcRGdWMzaNIV3EE6LY7ukS+X3DHah60UySUAzLic3pBdUVBmPcTw8221bjvNFgN7+0gl76wdk8356/1YwXh72eNSgF5IKje80/puf15ndC6k3FSIV8D824PF/asyHWr43M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgbc1Yjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgbc1Yjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2668BC116B1;
	Tue, 16 Jul 2024 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145339;
	bh=YRFWDfLN3keGcnYz2I0/tbsbINYlfWVFGOTfzseSmgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgbc1YjdhNaVpgMh0sWZAa+syrueppg7CPt57tVNnUI+6Mjf0qc8sCPW0iLIe/aRv
	 CvfvOt2xpO65/DtScMrrD7LjjVOe1x0xY98K7QD1qrH2uUmhvHO0qc7KPgkJYOaqmH
	 RZCAFR9EH93YQsT2ORqUr+TiLB42B5KdzqW36Jb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/96] cachefiles: cancel all requests for the object that is being dropped
Date: Tue, 16 Jul 2024 17:31:16 +0200
Message-ID: <20240716152746.725783865@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

[ Upstream commit 751f524635a4f076117d714705eeddadaf6748ee ]

Because after an object is dropped, requests for that object are useless,
cancel them to avoid causing other problems.

This prepares for the later addition of cancel_work_sync(). After the
reopen requests is generated, cancel it to avoid cancel_work_sync()
blocking by waiting for daemon to complete the reopen requests.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-7-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 12e009d60852 ("cachefiles: wait for ondemand_object_worker to finish when dropping object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index cc2de0e3ee60f..acaecfce8aaa9 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -636,12 +636,31 @@ int cachefiles_ondemand_init_object(struct cachefiles_object *object)
 
 void cachefiles_ondemand_clean_object(struct cachefiles_object *object)
 {
+	unsigned long index;
+	struct cachefiles_req *req;
+	struct cachefiles_cache *cache;
+
 	if (!object->ondemand)
 		return;
 
 	cachefiles_ondemand_send_req(object, CACHEFILES_OP_CLOSE, 0,
 			cachefiles_ondemand_init_close_req, NULL);
+
+	if (!object->ondemand->ondemand_id)
+		return;
+
+	/* Cancel all requests for the object that is being dropped. */
+	cache = object->volume->cache;
+	xa_lock(&cache->reqs);
 	cachefiles_ondemand_set_object_dropping(object);
+	xa_for_each(&cache->reqs, index, req) {
+		if (req->object == object) {
+			req->error = -EIO;
+			complete(&req->done);
+			__xa_erase(&cache->reqs, index);
+		}
+	}
+	xa_unlock(&cache->reqs);
 }
 
 int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
-- 
2.43.0



