Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B884223C42;
	Thu, 12 Dec 2024 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020869; cv=none; b=eEROUqT3ulUnJREDDOMyF/Bq970pBNeuPJ5C6menyJ7Lz4Yg26TmCvCHkltlRCtQr8vvvTCimvgrYbnpJTsfF0ssLJ60fiZ3WkBbUeRb4AMofaw75uSgCtgJyq5X8JQUYAdZy5HYDuzsPvOQLJoAnlCHvnvvbR563Z+zKILI1nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020869; c=relaxed/simple;
	bh=zaLu8RNGuTxOh4Y5sbSa24q4ni5Q8M/k62LSSon03UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCrcgnhO2QpiSqiClTiQbUmUCWLVidVaRBpUlkUuzdxIDfraWTH3kYD7849Pzc2FetV2GN1150FOZ3Uj0NfJVABmLv5Dtt3jjCRLIGOpv9v4TWCqt/BSYQ4jmoQzQ/XrosnbvCjN8QK6q4ekCvLhgAh2sCgYLU3A0MFgUyhxMGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7uJlhBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7uJlhBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD06C4CED0;
	Thu, 12 Dec 2024 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020869;
	bh=zaLu8RNGuTxOh4Y5sbSa24q4ni5Q8M/k62LSSon03UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7uJlhBvKKn5EqrMhTBiHjNsCll7IAvZ9b8CNN3h7OKH/7kI4tCAwqYntqGBvka8K
	 nrgDHY4vqdWzAEb9sbtc+mDvTiBoAIU2F/938MvX34ZpX6Ybg2VLXRN8c4xvlkbWo5
	 ni24Jrd6rngdlFOl9S0cxO/X5Zvb0WnbLS1gTWbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 581/772] device property: Introduce device_for_each_child_node_scoped()
Date: Thu, 12 Dec 2024 15:58:46 +0100
Message-ID: <20241212144413.949596065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

[ Upstream commit 365130fd47af6d4317aa16a407874b699ab8d8cb ]

Similar to recently propose for_each_child_of_node_scoped() this
new version of the loop macro instantiates a new local
struct fwnode_handle * that uses the __free(fwnode_handle) auto
cleanup handling so that if a reference to a node is held on early
exit from the loop the reference will be released. If the loop
runs to completion, the child pointer will be NULL and no action will
be taken.

The reason this is useful is that it removes the need for
fwnode_handle_put() on early loop exits.  If there is a need
to retain the reference, then return_ptr(child) or no_free_ptr(child)
may be used to safely disable the auto cleanup.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20240217164249.921878-5-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 73b03b27736e ("leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/property.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index f2e8590cefd89..fb685f0f702aa 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -122,6 +122,11 @@ struct fwnode_handle *device_get_next_child_node(const struct device *dev,
 	for (child = device_get_next_child_node(dev, NULL); child;	\
 	     child = device_get_next_child_node(dev, child))
 
+#define device_for_each_child_node_scoped(dev, child)			\
+	for (struct fwnode_handle *child __free(fwnode_handle) =	\
+		device_get_next_child_node(dev, NULL);			\
+	     child; child = device_get_next_child_node(dev, child))
+
 struct fwnode_handle *fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
 						  const char *childname);
 struct fwnode_handle *device_get_named_child_node(const struct device *dev,
-- 
2.43.0



