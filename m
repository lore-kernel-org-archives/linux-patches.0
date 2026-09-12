Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76CB35E1D5;
	Sat, 12 Sep 2026 19:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242448; cv=none; b=G4jQuXAO3JSdc+tXVdE9iIswH7Wr2sYBORgRDsab13IVUlOrZEZQoMbRVU86XVUPuanpQm/tD4jOUG76stTp3HBGU2lM4oNN//eeYKiE1PxxKKnSCZ2KEJxonQckVKyrxoytKZxh1ZG+OyNBQbVeN4z1G7pijEc8T1Tp+XynU/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242448; c=relaxed/simple;
	bh=T036zFcvie93EyHkIRHmOixI1WRu//rf+b5TGyteHWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btn6GnhMWE2ZGE0mvmq0wziORPBCO+2+pekR4E55HVwoHJhkCLBczpctkEQbR1fvPVUZFAIX5z2VfFJEiPrrIL7Hz9UtA7hAcOuoYT9orZd71kOuB0H1j51EZd1bGVAtjE/ahmWVMbwMqidVIhzqElZy64RAoHGYuxt2qg+Nofk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIvoo34E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIvoo34E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065D1F000FF;
	Sat, 12 Sep 2026 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242447;
	bh=xJTDK2kzVq4G8mRkMLH7SVtWJIE+lsEqHPG91Cob73g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIvoo34EoMHVJPLtwaCzw5De30698yuFSZE7P2BDmrZ6ian8mjzJbj0WBzPhyMnAl
	 zEgM73tlC4g1p+dX7c1meeWPCfvZhHlYRl1/ymZmnEvUJsBbzreOFDkvw5AX7bfamj
	 6K2AWsUReWVrtyinOBU/6jDGBAyNUmVaXgXta+1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/798] of: Add cleanup.h based auto release via __free(device_node) markings
Date: Sat, 12 Sep 2026 09:00:08 +0200
Message-ID: <20260912065525.864941848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 9448e55d032d99af8e23487f51a542d51b2f1a48 ]

The recent addition of scope based cleanup support to the kernel
provides a convenient tool to reduce the chances of leaking reference
counts where of_node_put() should have been called in an error path.

This enables
	struct device_node *child __free(device_node) = NULL;

	for_each_child_of_node(np, child) {
		if (test)
			return test;
	}

with no need for a manual call of of_node_put().
A following patch will reduce the scope of the child variable to the
for loop, to avoid an issues with ordering of autocleanup, and make it
obvious when this assigned a non NULL value.

In this simple example the gains are small but there are some very
complex error handling cases buried in these loops that will be
greatly simplified by enabling early returns with out the need
for this manual of_node_put() call.

Note that there are coccinelle checks in
scripts/coccinelle/iterators/for_each_child.cocci to detect a failure
to call of_node_put(). This new approach does not cause false positives.
Longer term we may want to add scripting to check this new approach is
done correctly with no double of_node_put() calls being introduced due
to the auto cleanup. It may also be useful to script finding places
this new approach is useful.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20240225142714.286440-2-jic23@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 64774dea5896 ("bus: qcom-ebi2: Fix clock leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 4ed8dce624e7b..d8cd02433f910 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -13,6 +13,7 @@
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
 #include <linux/mod_devicetable.h>
@@ -128,6 +129,7 @@ static inline struct device_node *of_node_get(struct device_node *node)
 }
 static inline void of_node_put(struct device_node *node) { }
 #endif /* !CONFIG_OF_DYNAMIC */
+DEFINE_FREE(device_node, struct device_node *, if (_T) of_node_put(_T))
 
 /* Pointer for first entry in chain of all nodes. */
 extern struct device_node *of_root;
-- 
2.53.0



