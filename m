Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D02F4F207;
	Tue, 23 Jan 2024 00:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970441; cv=none; b=JOOk/tmQCWjc6vwiMEufhxu8bYd6eth9tapnPRD11KYzN5Xpl/mXS4g/qAZg7VusVblkB029VUDj/Dr2/mGr19+8I7pCbPVxYvdq4t9MEcFG5N1kUy0/I7mYoTbqE61homD3/f/FHIeKVFcFnzTBShWgW1x7Y/Qw0IzOnkY7+oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970441; c=relaxed/simple;
	bh=uQVNKohIJ/F1lH6ykVaDlXjFatd66WerlpPSJ9MjYOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3yaF80wuxPcwUB3eGs14z+VD12pKP5bQlvmgg6j8Kjcqw50BsBuV96HgJId+IqFdLbUylHwhpNKdYsicr4dRTybYD4qT1jmAMxfcCexYvQ++9kHbDR7O0+92fOCkf9g2ufjUMKvV9up8zV0atqOFTtt9FSzq+N6ZdT4ToAZOEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ph/NxGQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ph/NxGQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B07C433C7;
	Tue, 23 Jan 2024 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970440;
	bh=uQVNKohIJ/F1lH6ykVaDlXjFatd66WerlpPSJ9MjYOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ph/NxGQsKgsh/qoPTU8EnL+vEK6qCI+qetCqS8/JUYAM8za4ZP27UAtofsXIaZ2F7
	 ZY/dV3aV4IDv2WVUeO9rYNz/QJKrXTrOFdOulkI8lzlz+azAtgf6y1QpkSYMjaHwKa
	 stiaA/aokBJciyz4+LFv5ajeitti+iX3qNyWIlrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/417] platform/x86/intel/vsec: Use mutex for ida_alloc() and ida_free()
Date: Mon, 22 Jan 2024 15:53:08 -0800
Message-ID: <20240122235752.243205386@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 9a90ea7d378486aa358330dafc7e8c3b27de4d84 ]

ID alloc and free functions don't have in built protection for parallel
invocation of ida_alloc() and ida_free(). With the current flow in the
vsec driver, there is no such scenario. But add mutex protection for
potential future changes.

Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20230207125821.3837799-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 8cbcc1dbf8a6 ("platform/x86/intel/vsec: Fix xa_alloc memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 4d73ad741892..7e2e7a37e07e 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -124,11 +124,16 @@ static void intel_vsec_remove_aux(void *data)
 	auxiliary_device_uninit(data);
 }
 
+static DEFINE_MUTEX(vsec_ida_lock);
+
 static void intel_vsec_dev_release(struct device *dev)
 {
 	struct intel_vsec_device *intel_vsec_dev = dev_to_ivdev(dev);
 
+	mutex_lock(&vsec_ida_lock);
 	ida_free(intel_vsec_dev->ida, intel_vsec_dev->auxdev.id);
+	mutex_unlock(&vsec_ida_lock);
+
 	kfree(intel_vsec_dev->resource);
 	kfree(intel_vsec_dev);
 }
@@ -140,7 +145,9 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
 	struct auxiliary_device *auxdev = &intel_vsec_dev->auxdev;
 	int ret, id;
 
+	mutex_lock(&vsec_ida_lock);
 	ret = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
+	mutex_unlock(&vsec_ida_lock);
 	if (ret < 0) {
 		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
@@ -157,7 +164,9 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
 
 	ret = auxiliary_device_init(auxdev);
 	if (ret < 0) {
+		mutex_lock(&vsec_ida_lock);
 		ida_free(intel_vsec_dev->ida, auxdev->id);
+		mutex_unlock(&vsec_ida_lock);
 		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return ret;
-- 
2.43.0



