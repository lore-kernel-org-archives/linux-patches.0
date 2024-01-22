Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F54E56468;
	Tue, 23 Jan 2024 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974012; cv=none; b=kyt8PAcGQ2OBpJ0U2EjLX1d2//7vHIL21rBrfHEbUgurXQlGFCZ8N7faGLUNfc9HcqGNbfh0FRO7nD5hZGCfWa6OA/OzI5SVK0oNkBz3Lvf8gtLcs6uy1Is4LwRkEd83aVDjeZv/NITQbQhdbtBEorz3e1rIgDW00WoAepv54hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974012; c=relaxed/simple;
	bh=H0olwTkixWLWX9nNBI8F73Kl52+nPwFG4K/dLIQph5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvNv5Qy8378oIAuGYp87CfLIF41iAB1YvmzcmVhkGK2OdigD0L/SWDd0N5iivob0cA7l9ODGMtwPcDswJMn/uHTXpgdKOyC6hPjMbX8wQQclLr9/SaV92sfTf1dWIkwCzjYzz+jv3txmfNk+JTt8dB2y1wi7qXr8mfPsUjWuadc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH0Iq8fF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH0Iq8fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6BEC433C7;
	Tue, 23 Jan 2024 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974011;
	bh=H0olwTkixWLWX9nNBI8F73Kl52+nPwFG4K/dLIQph5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vH0Iq8fFQqxh1PWB7jcMDpBYbEr3zN4ngVyoQugriymslEwSauyeJooU0vZ0D7CYO
	 GIoTAMCuRHoB3QrX7VIWwI8G64afgqFyollilbrYiQzL1akYYzS5A7tPazbIK7dNPZ
	 p+q7zkxEzGaFDoHfbvIvMGUfP69Z5PLRKfNndsJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Rowand <frowand.list@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/374] of: Add of_property_present() helper
Date: Mon, 22 Jan 2024 15:55:39 -0800
Message-ID: <20240122235747.510105597@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4403e8fc764a..29f657101f4f 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1073,7 +1073,8 @@ static inline int of_property_read_string_index(const struct device_node *np,
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
  *
- * Search for a property in a device node.
+ * Search for a boolean property in a device node. Usage on non-boolean
+ * property types is deprecated.
  *
  * Return: true if the property exists false otherwise.
  */
@@ -1085,6 +1086,20 @@ static inline bool of_property_read_bool(const struct device_node *np,
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



