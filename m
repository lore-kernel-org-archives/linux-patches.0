Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9334B30DEB2;
	Mon, 13 Oct 2025 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367403; cv=none; b=RZ8zVNf+w+k+nueFXCWN07g+fcXGR2XWTOjJidP9UOb1RUi7Hc2nno6uxhbespAFxvcy2grxZFUs5NdExg/IO/m8K8gmfeFPoQA7SgLd5S2Gk2neMfUxI9dd9inVfvlueh8VnsjZl0bcLMO2R9rR+LFZZTlDP+hJEQNzvWmdemE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367403; c=relaxed/simple;
	bh=LEnHzOzRRaeg5kgKX5AdWlc+0aSt2WPbKws0maYZs64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cm5035U5xoMZ4d8uaaiedhEps13SLixiqQuVt1i4T8KXvZP2l+/xpSvALPeqtC/MwA6NGQQG/VK78pKHljCQCF1O0kLQtz/jUbsPNNTSj9n3y0b7avTrg0inHbb3uGXQ2NQRkPKiSVUHz52g5BSyFx73AYek62mdfA+i7sRYI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXtJHwgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXtJHwgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99B9C4CEE7;
	Mon, 13 Oct 2025 14:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367403;
	bh=LEnHzOzRRaeg5kgKX5AdWlc+0aSt2WPbKws0maYZs64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXtJHwgJAHh5KaKz8SBilOSxTfYnknlA9S8nxM8cZLikpITYnUqGSB65UEIp+MfMr
	 TBbaBiLch3OMNoSaOO6ckh45kx4VylIrwSU0e9fTBJzCTA4rKPDM2wyirNyuERFCO+
	 Ok21CLDupksVWDuz908NC6lYEt25yshB6hgNdAlI=
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
Subject: [PATCH 6.1 163/196] drivers/base/node: fix double free in register_one_node()
Date: Mon, 13 Oct 2025 16:45:36 +0200
Message-ID: <20251013144320.595506887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cbaa4e2eddcef..6153dbd5be903 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -871,7 +871,6 @@ int __register_one_node(int nid)
 	error = register_node(node_devices[nid], nid);
 	if (error) {
 		node_devices[nid] = NULL;
-		kfree(node);
 		return error;
 	}
 
-- 
2.51.0



