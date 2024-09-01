Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C423183090;
	Sun,  1 Sep 2024 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207970; cv=none; b=jCo1WuyFfN2w5nnkfNgrSCz1QgU1f0KRTBNEKxIUk+zPoiZb82LaTtOmmsqdHEulHvExHFhAJKYKhKnj4/Y9O8t6Ocxdro0wunhVNtTGVfxLAJCD9sLX07zKDpOwoUNXGgG+5l27PDJBNT/pxmKXxGeezVyUnNydDeprnd3stQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207970; c=relaxed/simple;
	bh=O7dTY7xQPXIm2ibmPhkuEmG9cvrZSyF8U2cqe2LT/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHGcVU34nmisDXkOq8CDkZ75ffHdj17GZkW2xD5KCMNSb3pvW3artZfgKVCpByUZXnm1g+6Z4U38X+RyTHC0EzmEAvmycErfI8YItCKX7spXFD3TuhCUQ4uSfaDsEekToNzUNq4okgMWxTCWjxervfw5GBnFlafTfe181sCp1vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4c6uGhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4c6uGhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F37AC4CEC3;
	Sun,  1 Sep 2024 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207969;
	bh=O7dTY7xQPXIm2ibmPhkuEmG9cvrZSyF8U2cqe2LT/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4c6uGhQzRzkhxlIi6mkY1/e6S1x4oO8Prx0dHkKzsRrO9z9M6z7WZeQwB0bYIHa9
	 kym0dFCDth6FG3shDPF2Yd9ZKLaE/zqYA3DzDZYAmbRKF4BnPt4L9YqzAxL4teZ75h
	 B6f7wiAWwou8en72n6H1/5NoHZylxO1+3JNF0pjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.6 08/93] of: Add cleanup.h based auto release via __free(device_node) markings
Date: Sun,  1 Sep 2024 18:15:55 +0200
Message-ID: <20240901160807.670309006@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 9448e55d032d99af8e23487f51a542d51b2f1a48 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/of.h |    2 ++
 1 file changed, 2 insertions(+)

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
@@ -134,6 +135,7 @@ static inline struct device_node *of_nod
 }
 static inline void of_node_put(struct device_node *node) { }
 #endif /* !CONFIG_OF_DYNAMIC */
+DEFINE_FREE(device_node, struct device_node *, if (_T) of_node_put(_T))
 
 /* Pointer for first entry in chain of all nodes. */
 extern struct device_node *of_root;


