Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B769156F36;
	Mon, 16 Sep 2024 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488512; cv=none; b=sE6kyHzhP6qdwU3eJO+FkBHgUt4PstcgbQxNRiaLnJyCnYbLkyuchwPerbO2LToBJsccEtBRvq+OHbP7WcdARAvuLoiK4+cur1QCC0o/yN/s0YPtau4XA0sb52r1XedLNiZzsBQt9TTEcEApHfM5BuGVm59pcjydHURrykP6nFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488512; c=relaxed/simple;
	bh=+GoVzwJE4rNb+jyzXs6nfYquBNkQ+ma80jQwSbVMYXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TX+N0CzcrbrpU6FJp6i3MAKqcefTG9GPlivVnMzZqcL/OS3KRGsItEXE13W29GvFFQrKACqRt/kguaw/kUDs5wbZg3eDbW7UXn7Em0mVPmviQHQ2G5WVuAxjy2agtxeT0ZHBNWvJts0AFi6hNUyTMGTJ5JLhSZPwEq6AbyWKDo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeIKW+Ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeIKW+Ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14787C4CECE;
	Mon, 16 Sep 2024 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488512;
	bh=+GoVzwJE4rNb+jyzXs6nfYquBNkQ+ma80jQwSbVMYXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeIKW+RiqPSl+qp1/ozclqrWGHZ9QGNeOsCZduy7XoUvsiuRrlXrwBhxvnmYfB2nB
	 gPn4SBILhs+hmj1MPiq5PqzcI9+HI7Kuk0/xcjcB389zPX+ZCbbxfwcHZ9Ckpp8R8v
	 NmDJBdFG1+/Oauy0wAH3Nl0RCUDe/oqBi70wMx5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/91] nvmem: core: add nvmem_dev_size() helper
Date: Mon, 16 Sep 2024 13:43:41 +0200
Message-ID: <20240916114224.692502557@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 33cf42e68efc8ff529a7eee08a4f0ba8c8d0a207 ]

This is required by layouts that need to read whole NVMEM content. It's
especially useful for NVMEM devices without hardcoded layout (like
U-Boot environment data block).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231221173421.13737-2-zajec5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8679e8b4a1eb ("nvmem: u-boot-env: error if NVMEM device is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c           | 13 +++++++++++++
 include/linux/nvmem-consumer.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index e7fd1315d7ed..f28c005c2bb2 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -2131,6 +2131,19 @@ const char *nvmem_dev_name(struct nvmem_device *nvmem)
 }
 EXPORT_SYMBOL_GPL(nvmem_dev_name);
 
+/**
+ * nvmem_dev_size() - Get the size of a given nvmem device.
+ *
+ * @nvmem: nvmem device.
+ *
+ * Return: size of the nvmem device.
+ */
+size_t nvmem_dev_size(struct nvmem_device *nvmem)
+{
+	return nvmem->size;
+}
+EXPORT_SYMBOL_GPL(nvmem_dev_size);
+
 static int __init nvmem_init(void)
 {
 	return bus_register(&nvmem_bus_type);
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 4523e4e83319..526025561df1 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -81,6 +81,7 @@ int nvmem_device_cell_write(struct nvmem_device *nvmem,
 			    struct nvmem_cell_info *info, void *buf);
 
 const char *nvmem_dev_name(struct nvmem_device *nvmem);
+size_t nvmem_dev_size(struct nvmem_device *nvmem);
 
 void nvmem_add_cell_lookups(struct nvmem_cell_lookup *entries,
 			    size_t nentries);
-- 
2.43.0



