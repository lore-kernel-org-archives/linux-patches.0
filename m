Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52774F207;
	Tue, 23 Jan 2024 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970449; cv=none; b=Yy0ZiujJELVY6uGdiip+Px8Zv4P5LPlUD9mJYSbl6XlaoZ/F6Z1ykzu+6A7elb2kS8noW1DJVM3ljGEco+nR8pL2aIDAod/6Fy6lJI+UE5coWfTOAE3/K+M/My6ZGgnCeSaVRuDl4uvPhmNzeqoS3F7RLZk+HrryldnIetLFjhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970449; c=relaxed/simple;
	bh=+e2kY6NGnm6FtR9+/Zq5Ypu0aZgSjGbEqND1WYNLeWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3ppW8A89ilOMvLxZg3mO55wuQ+puz+SLz9duHoTyYJ7xIdisJXPkYkZ3D619HVytDSAEHGfKtic5I6g28HyE2SuZo414splU7AotjUz591X786XpTlsf8qN0KRYO6nam/bUVZRSoleYpooszKYPNeZpVcp2IJRVqP90QEO5Sqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQ5NTSJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQ5NTSJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FEEC433C7;
	Tue, 23 Jan 2024 00:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970449;
	bh=+e2kY6NGnm6FtR9+/Zq5Ypu0aZgSjGbEqND1WYNLeWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ5NTSJW9SfA36r73aZPGMFMjwYF3yKqKxcggTC2vVmeZVk2gundHMhImC1CAfOoP
	 gP6FDPZyXym4KKh31YvB9J96k1KXcXzVy5rMdOE1Wj3LKfNn9slW7G1HoiohR1t+bi
	 mY4aXpjRK4FVVezzsMijNOkEHGX+N6U/xwOqzF+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Rowand <frowand.list@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/417] of: Add of_property_present() helper
Date: Mon, 22 Jan 2024 15:53:10 -0800
Message-ID: <20240122235752.315685505@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 6b79ef9a6541..1c5301e10442 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1155,7 +1155,8 @@ static inline int of_property_read_string_index(const struct device_node *np,
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
  *
- * Search for a property in a device node.
+ * Search for a boolean property in a device node. Usage on non-boolean
+ * property types is deprecated.
  *
  * Return: true if the property exists false otherwise.
  */
@@ -1167,6 +1168,20 @@ static inline bool of_property_read_bool(const struct device_node *np,
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



