Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9E112FB31;
	Wed, 19 Jun 2024 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802659; cv=none; b=iqV4K/1VaiN21Sq2A/I/S9bdZMzxbtfNfx2WdVjhVG4iOs+yKmf5U+SBt+QMrASjqElR4/AxOella+MoDr9vVx1n18LMIK011xQw/eCvO8wCI7rq5ZfrCtO4g7G4uC9V2EGH9E3dX4YwRbZ0zihTM9+vdWYcqRapFylduj2dTxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802659; c=relaxed/simple;
	bh=fsccWHinTaIBpfcVs5NDQIkx+/wkY1NpswXi7Lr6wNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPpbJixPuMsQb2OiKNnyFNhwudYQZV8o7/mZcr1gFZyViM7HMe8iNyX6TpYemhDQHN9PweEp1Yegy7/N9tGEU992J4yAFbMySFcXEK/r94eJRFV9HgxhPbkm/OOwtBpOIhOR5YFRPa8bWdYwgE3Ev+OvAyjauE5apKyIDKFmntA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMQCSEnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMQCSEnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B5EC2BBFC;
	Wed, 19 Jun 2024 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802659;
	bh=fsccWHinTaIBpfcVs5NDQIkx+/wkY1NpswXi7Lr6wNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMQCSEnmcavkjYPbPv6pV1T3Y0gDQE4gc5mRCSp/iv2uv+uSQj4Y0XIHUOKAs2QwM
	 ZFgxrDnJ3jqBpgP+JfmiDQxcFJiPRmJTDGe1ZqDyJEv818z+v0phkYytOoJ6fkEqhw
	 R9GCmenVe8BvKhQCptej+IaHH7rVc3rQo1f2gB/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/267] device property: Implement device_is_big_endian()
Date: Wed, 19 Jun 2024 14:56:48 +0200
Message-ID: <20240619125616.180252628@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 826a5d8c9df9605fb4fdefa45432f95580241a1f ]

Some users want to use the struct device pointer to see if the
device is big endian in terms of Open Firmware specifications,
i.e. if it has a "big-endian" property, or if the kernel was
compiled for BE *and* the device has a "native-endian" property.

Provide inline helper for the users.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20231025184259.250588-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/property.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index 8c3c6685a2ae3..1684fca930f72 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -79,12 +79,38 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 
 bool fwnode_device_is_available(const struct fwnode_handle *fwnode);
 
+static inline bool fwnode_device_is_big_endian(const struct fwnode_handle *fwnode)
+{
+	if (fwnode_property_present(fwnode, "big-endian"))
+		return true;
+	if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) &&
+	    fwnode_property_present(fwnode, "native-endian"))
+		return true;
+	return false;
+}
+
 static inline
 bool fwnode_device_is_compatible(const struct fwnode_handle *fwnode, const char *compat)
 {
 	return fwnode_property_match_string(fwnode, "compatible", compat) >= 0;
 }
 
+/**
+ * device_is_big_endian - check if a device has BE registers
+ * @dev: Pointer to the struct device
+ *
+ * Returns: true if the device has a "big-endian" property, or if the kernel
+ * was compiled for BE *and* the device has a "native-endian" property.
+ * Returns false otherwise.
+ *
+ * Callers would nominally use ioread32be/iowrite32be if
+ * device_is_big_endian() == true, or readl/writel otherwise.
+ */
+static inline bool device_is_big_endian(const struct device *dev)
+{
+	return fwnode_device_is_big_endian(dev_fwnode(dev));
+}
+
 /**
  * device_is_compatible - match 'compatible' property of the device with a given string
  * @dev: Pointer to the struct device
-- 
2.43.0



