Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773CF185B63;
	Sun,  1 Sep 2024 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209166; cv=none; b=IPuDP6OEdbMo8tBULJxjx1lKxrHbWOmyrlwAGVBH27EHj7Euw7vXgF2p8UtqsxbGliJAiBySAcZWnCY1KBak5C5Jrp9H5Zlyxh+WLm03Zy9aTcV5XQA6qfb94pNGvVu63UBUmcgmkCDmBS7xDtPu1x4uRAuobgTiBylLNHot6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209166; c=relaxed/simple;
	bh=d8HWN5C4iN2fD5ghv+TOkGrm9/3Y7KOXxKSNNNofjlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZt28IjvrY93oMT4TsX6Lym8XTF12LrJ4pA2Q8N1jtFNqBQOPwXAehOhDbRyJqj/JWhmnEvuVB8N0XwB45GyvST0ABURcfu23mGr8aSHZ/rAqW272RmWllhSI5taLFuXlk6HbZHk5/BFVbH9xWf0dXxgHKRaBStPxgHMHytuYvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD+WBz1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD+WBz1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD8BC4CEC3;
	Sun,  1 Sep 2024 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209166;
	bh=d8HWN5C4iN2fD5ghv+TOkGrm9/3Y7KOXxKSNNNofjlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FD+WBz1WS2HD2n0mnBTfdFNPtUrj5sh/C/Q3Vhus6IZnoyw2C8lTY6yPN1LzphnF9
	 kKRe3sTaEXOt/tFvOkdV7fX1GQRIvrDXf0+MTmcgr72C7MfXZdAP8jdHY6hxDQMMN6
	 9x1qtggjAZBZnifCF0o7bOBNjsAog78XN0Sj48Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 07/71] of: Add cleanup.h based auto release via __free(device_node) markings
Date: Sun,  1 Sep 2024 18:17:12 +0200
Message-ID: <20240901160802.163921956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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
@@ -128,6 +129,7 @@ static inline struct device_node *of_nod
 }
 static inline void of_node_put(struct device_node *node) { }
 #endif /* !CONFIG_OF_DYNAMIC */
+DEFINE_FREE(device_node, struct device_node *, if (_T) of_node_put(_T))
 
 /* Pointer for first entry in chain of all nodes. */
 extern struct device_node *of_root;


