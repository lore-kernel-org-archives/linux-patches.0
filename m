Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F90E26A08F;
	Mon, 23 Mar 2026 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277561; cv=none; b=eZkS1UDHjspXkF1JcXhPKH6uO994HzXbb4CgnFQelBFp/8YQw0fSRKZquQZPFUqr3H1BIhrf4r4oZU+5GOdDNtZbdbVRpj3yKLBl3GlrFNt0W+fdyu7rbzHgEuuC06Jvp4xrxag9XmKvGWNsqoYpvOzpw3BwGz+HXlUKdA9nItY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277561; c=relaxed/simple;
	bh=osOFj+9u271XgP6x2W0i94p/mcEWaCu8pIgHaIaMpZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srZJcglAfTWJV6+cBVobrj71px2KRLHO8jFGWQbEFOlv26/D7zJnwqYjVOhfoP5c+DJZ7fPWC8bysZmXuOfABeQ9YymvIfeCLbZREc4QcEHX5xDQckWCtBcMFMnXASuWg7Wwc1dBCB8fLL/SZsWaIx4Zp2Q3xDSReyvctykzr3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsCf9ruS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsCf9ruS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976ABC4CEF7;
	Mon, 23 Mar 2026 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277561;
	bh=osOFj+9u271XgP6x2W0i94p/mcEWaCu8pIgHaIaMpZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsCf9ruSDx6uUh0BHDT5hauzIHIMxGm6yhOqT1H5xl+61GlLcAVzgyjETT1Y7Ww+8
	 fwaX5DaNnFFa0xW+l0lGmOexTI9zjdFOywEvw4VMnBXBBrNhF/1Xnl2nYAU14+qJKX
	 uceZLi4pqo2qR8vJ68p0BazWyLRZs9dyzMOl5yLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/567] resource: Add resource set range and size helpers
Date: Mon, 23 Mar 2026 14:39:12 +0100
Message-ID: <20260323134534.577225444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 9fb6fef0fb49124291837af1da5028f79d53f98e ]

Setting the end address for a resource with a given size lacks a helper and
is therefore coded manually unlike the getter side which has a helper for
resource size calculation. Also, almost all callsites that calculate the
end address for a resource also set the start address right before it like
this:

  res->start = start_addr;
  res->end = res->start + size - 1;

Add resource_set_range(res, start_addr, size) that sets the start address
and calculates the end address to simplify this often repeated fragment.

Also add resource_set_size() for the cases where setting the start address
of the resource is not necessary but mention in its kerneldoc that
resource_set_range() is preferred when setting both addresses.

Link: https://lore.kernel.org/r/20240614100606.15830-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 11721c45a826 ("PCI: Use resource_set_range() that correctly sets ->end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ioport.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 25d768d489701..d10749797f18d 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -216,6 +216,38 @@ struct resource *lookup_resource(struct resource *root, resource_size_t start);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 resource_size_t resource_alignment(struct resource *res);
+
+/**
+ * resource_set_size - Calculate resource end address from size and start
+ * @res: Resource descriptor
+ * @size: Size of the resource
+ *
+ * Calculate the end address for @res based on @size.
+ *
+ * Note: The start address of @res must be set when calling this function.
+ * Prefer resource_set_range() if setting both the start address and @size.
+ */
+static inline void resource_set_size(struct resource *res, resource_size_t size)
+{
+	res->end = res->start + size - 1;
+}
+
+/**
+ * resource_set_range - Set resource start and end addresses
+ * @res: Resource descriptor
+ * @start: Start address for the resource
+ * @size: Size of the resource
+ *
+ * Set @res start address and calculate the end address based on @size.
+ */
+static inline void resource_set_range(struct resource *res,
+				      resource_size_t start,
+				      resource_size_t size)
+{
+	res->start = start;
+	resource_set_size(res, size);
+}
+
 static inline resource_size_t resource_size(const struct resource *res)
 {
 	return res->end - res->start + 1;
-- 
2.51.0



