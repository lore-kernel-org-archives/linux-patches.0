Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D820153573;
	Mon, 16 Sep 2024 12:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488504; cv=none; b=XtN2rseiQhPqtKHoRNkz/NUEi4KuJcMxHw+P/hMc7J++AnlYzcT7dAowiq4xJOMkvOV0knu9fIXlvyJx5QVsekYZzIR2wXjM7Lrt/hwR458TwYRMvHC8Trdcng5DBTG4B+EOXa+qRQaEvkGkSqs2fnY/UEfoqXk0L/84xpV/tLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488504; c=relaxed/simple;
	bh=jeLhovaJY3/sF8eP3ibl6vOVFjZXaqgOBs5LU1tI1+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRiwKIT1KBECtWD3yPLx1JNevVR5nicShlNcMDWKIDKFuTpdUUsnB4CT7ouHsrf0u51U4Tr+yBHu+j7moDOblMTs8TsYJFyO6JzsEvzPKIEkNUJLDk6ijgizzsrZGZavpgZrhvUlud87gCIkpCOIEm4cA5pQ018HsdnCeVbTgys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMMyuIK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMMyuIK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8845CC4CEC4;
	Mon, 16 Sep 2024 12:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488503;
	bh=jeLhovaJY3/sF8eP3ibl6vOVFjZXaqgOBs5LU1tI1+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMMyuIK1W6hD8ipxmVKhQbp3lEA8C09qTMHf9Q0cifHrXrZ3JUX6UXsKq5U9IBruy
	 4c9OJZ33rv0hcE6dzubPILu/gheu5FgmyhJ74wcidSg/GpEFEtKUctYe+/+8z7xKgM
	 9/vYhCvPNHfZgibD3lo//V4IJZL+UAcv0uiEudJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/91] device property: Introduce device_for_each_child_node_scoped()
Date: Mon, 16 Sep 2024 13:43:38 +0200
Message-ID: <20240916114224.588476921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
Stable-dep-of: 61cbfb5368dd ("iio: adc: ad7124: fix DT configuration parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/property.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index 909416c701b8..d32b8052e086 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -168,6 +168,11 @@ struct fwnode_handle *device_get_next_child_node(const struct device *dev,
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



