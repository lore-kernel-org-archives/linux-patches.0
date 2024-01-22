Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0701292FC;
	Tue, 23 Jan 2024 00:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970997; cv=none; b=ZMvSI1PdGL1jl4F8M7Gd0DKky/triD+FgDWvI5IQZXRdaaRqaQ7vzUj796yqI8rpHx/QE+9Ka6Mt2C1b9Htcg3CS4L6+xGbcuaQd1nvU2TDoSq5Ss7zdVq/tPe9xJDWkVuP/M4KUUJZrbNX0DcVGG31iTj5AnZVdSeL51ioE1mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970997; c=relaxed/simple;
	bh=LfF2JiKkUWkAMjfZqkmdXoTGhNfJ7UCwUWE/1o7uLoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwzFK/W4hjE7CUyQHmTC0HTVY4fOaSkJf3T7ufomxZKxMmdyof04wH1xn9RMKX0RwGufGCqYwF9ttIRc0PIZ+GrqBHsk+f+Ci9/kNFp7IAZLVxH2cYAW3PvxDobV/eawTsOk4U9WVdTC+SIqMl2u+InTwEzh41Wqh4UdCCtOrxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uciYRdsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uciYRdsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D0AC43390;
	Tue, 23 Jan 2024 00:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970997;
	bh=LfF2JiKkUWkAMjfZqkmdXoTGhNfJ7UCwUWE/1o7uLoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uciYRdsSdO8dYqapulfU2H8E77Gh8aQ3q2AGCc5ARKd9MG5HMQ6CgR5tx2bTNf41R
	 dkO3uxxv9RU9clsxmXqQjt85Wd0jRKDqigRpc63HsyWp37L12bpiP4WWNxqf6O/pmg
	 +Q9BBK7L8971U4gtc9wyaM9QRE3MeRyGe46VJhzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Rowand <frowand.list@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/286] of: Add of_property_present() helper
Date: Mon, 22 Jan 2024 15:56:12 -0800
Message-ID: <20240122235734.557467148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 9cbad37ce8122de32a1529e394b468bc101c9e7f ]

Add an of_property_present() function similar to
fwnode_property_present(). of_property_read_bool() could be used
directly, but it is cleaner to not use it on non-boolean properties.

Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Tested-by: Frank Rowand <frowand.list@gmail.com>
Link: https://lore.kernel.org/all/20230215215547.691573-1-robh@kernel.org/
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: c4a5118a3ae1 ("cpufreq: scmi: process the result of devm_of_clk_add_hw_provider()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 13d6243d202d..4ed8dce624e7 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1061,7 +1061,8 @@ static inline int of_property_read_string_index(const struct device_node *np,
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
  *
- * Search for a property in a device node.
+ * Search for a boolean property in a device node. Usage on non-boolean
+ * property types is deprecated.
  *
  * Return: true if the property exists false otherwise.
  */
@@ -1073,6 +1074,20 @@ static inline bool of_property_read_bool(const struct device_node *np,
 	return prop ? true : false;
 }
 
+/**
+ * of_property_present - Test if a property is present in a node
+ * @np:		device node to search for the property.
+ * @propname:	name of the property to be searched.
+ *
+ * Test for a property present in a device node.
+ *
+ * Return: true if the property exists false otherwise.
+ */
+static inline bool of_property_present(const struct device_node *np, const char *propname)
+{
+	return of_property_read_bool(np, propname);
+}
+
 /**
  * of_property_read_u8_array - Find and read an array of u8 from a property.
  *
-- 
2.43.0



