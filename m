Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE078279DC9;
	Mon, 13 Oct 2025 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368703; cv=none; b=ZE9fGrUqzx08Dyib8dKP8FF3qOAAasPNb953O2QokKuPEBBzHfgfQnaKccly3Forjkak4rPnYSIq93GvoYDDxbe6KXP8j5TMrdjdp0OKD7wq4UBetKhmkMKp1b9to1W58RGggTgQulbbT9JXMqyf5nZvpcuxMgbAtBN5XbAJTMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368703; c=relaxed/simple;
	bh=YpGXcaS8FzxPHNKTysxUDRMWoueuD8432H8tatgQlMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2zwYxh2XjlJL2OY7ln0QSAZb7AzJwz5vtnbTX3D3Gs6HXpCwMfwmhr+Qbb+EJ6w3bsW68Wyw0lddE9QxQqwqtb0w/HU/SpNstBS759zgra5lNnVwwKIIglBrjKCFqByaVSshQ+UbzC0aCO9ceekVa2M8i9Lsy6g+KNm1+guh5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRn2cjxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRn2cjxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3258CC4CEE7;
	Mon, 13 Oct 2025 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368703;
	bh=YpGXcaS8FzxPHNKTysxUDRMWoueuD8432H8tatgQlMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRn2cjxIsogRQytbYQ7w4YgpFqx2I+APPoBB5JjjBwZAHCbRpr1LFjQZ8ovzw31pD
	 4L288I50b22kYCSpMSYOBqwbEBuJS66MB/pZ84GVYPgotaAyig25WJ2enUS7Ux3qZB
	 1fZqLHojySXEvmPh3LbLE77JXuIrXD7K6Hb8BqMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Alison Schofield <alison.schofield@intel.com>,
	Chris Mason <clm@meta.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/262] drivers/base/node: fix double free in register_one_node()
Date: Mon, 13 Oct 2025 16:45:52 +0200
Message-ID: <20251013144333.806344904@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 0efdedfa537eb534c251a5b4794caaf72cc55869 ]

When device_register() fails in register_node(), it calls
put_device(&node->dev).  This triggers node_device_release(), which calls
kfree(to_node(dev)), thereby freeing the entire node structure.

As a result, when register_node() returns an error, the node memory has
already been freed.  Calling kfree(node) again in register_one_node()
leads to a double free.

This patch removes the redundant kfree(node) from register_one_node() to
prevent the double free.

Link: https://lkml.kernel.org/r/20250918054144.58980-1-donettom@linux.ibm.com
Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Chris Mason <clm@meta.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 6f09aa8e32237..deccfe68214ec 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -881,7 +881,6 @@ int __register_one_node(int nid)
 	error = register_node(node_devices[nid], nid);
 	if (error) {
 		node_devices[nid] = NULL;
-		kfree(node);
 		return error;
 	}
 
-- 
2.51.0



