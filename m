Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE41391E4B;
	Sat, 12 Sep 2026 19:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243153; cv=none; b=em4/ylD6PrB+fKLxXNMTPZ8RHanyQnIb1A2ZkNmEy/G4nKpmiPk9uzP1WpLXAv9PytsHPLRsoIYK8rp4WsAHcPxKuwuh1x3EoMqAPzGn9a73kJUukM9xbAF1AkPA+WTH/HSiZUqvuokQdHBqhTWO/xhaCW6eTOIQWX0JrR0eWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243153; c=relaxed/simple;
	bh=+K9gBnKXxOau3n35nJYOgCupspuSCPYxEWiXe3ZHIes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trwBS95HwAdGxF2tYdUfa+F5djXUpnuhe8IW6k7g9pGabta0QxGsgeKTy0zmPtwEVMJc8qzpURfnpCAo1aiye88TkC5us4+j2WJs+SinVq5uPHkupiYVCm5S37+zr9MhG51KPtmYGePDPtStKq2xElRBSrJXobwk79daRi0Q9UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU4toyIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU4toyIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337FE1F000FF;
	Sat, 12 Sep 2026 19:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243151;
	bh=qvIMp1m9R+xw6kHvZOC/mVlv/aORuLGwglPfQeNK5wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mU4toyIlks+iJn6ibbIDgwoDbbD3V7dQAr5/rP2UgScvJm4OeySvr67akjhA8bGE5
	 8jo5i0R0Uw7++TEp8aXpjw9Rl5YNlsjoapf7TA7z7Ss/mN7BQQh9DFBFfuKKsa4vta
	 yKM6kx+6y8KKpG3qrnCxZIYE7RFyMHA1f3oTxczw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishabh Bhatnagar <rishabhb@codeaurora.org>,
	Suman Anna <s-anna@ti.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 602/798] remoteproc: Add a rproc_set_firmware() API
Date: Sat, 12 Sep 2026 09:03:50 +0200
Message-ID: <20260912065530.923591579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 4c1ad562d303526b5d9b49f5e0d72da13ef78dec ]

A new API, rproc_set_firmware() is added to allow the remoteproc platform
drivers and remoteproc client drivers to be able to configure a custom
firmware name that is different from the default name used during
remoteproc registration. This function is being introduced to provide
a kernel-level equivalent of the current sysfs interface to remoteproc
client drivers, and can only change firmwares when the remoteproc is
offline. This allows some remoteproc drivers to choose different firmwares
at runtime based on the functionality the remote processor is providing.
The TI PRU Ethernet driver will be an example of such usage as it
requires to use different firmwares for different supported protocols.

Also, update the firmware_store() function used by the sysfs interface
to reuse this function to avoid code duplication.

Reviewed-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
Link: https://lore.kernel.org/r/20201121032042.6195-1-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: bb840ea69347 ("remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c  | 63 +++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_sysfs.c | 33 +-------------
 include/linux/remoteproc.h            |  1 +
 3 files changed, 66 insertions(+), 31 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index a5c13aab898e0..3b12d438ae514 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1989,6 +1989,69 @@ struct rproc *rproc_get_by_phandle(phandle phandle)
 #endif
 EXPORT_SYMBOL(rproc_get_by_phandle);
 
+/**
+ * rproc_set_firmware() - assign a new firmware
+ * @rproc: rproc handle to which the new firmware is being assigned
+ * @fw_name: new firmware name to be assigned
+ *
+ * This function allows remoteproc drivers or clients to configure a custom
+ * firmware name that is different from the default name used during remoteproc
+ * registration. The function does not trigger a remote processor boot,
+ * only sets the firmware name used for a subsequent boot. This function
+ * should also be called only when the remote processor is offline.
+ *
+ * This allows either the userspace to configure a different name through
+ * sysfs or a kernel-level remoteproc or a remoteproc client driver to set
+ * a specific firmware when it is controlling the boot and shutdown of the
+ * remote processor.
+ *
+ * Return: 0 on success or a negative value upon failure
+ */
+int rproc_set_firmware(struct rproc *rproc, const char *fw_name)
+{
+	struct device *dev;
+	int ret, len;
+	char *p;
+
+	if (!rproc || !fw_name)
+		return -EINVAL;
+
+	dev = rproc->dev.parent;
+
+	ret = mutex_lock_interruptible(&rproc->lock);
+	if (ret) {
+		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, ret);
+		return -EINVAL;
+	}
+
+	if (rproc->state != RPROC_OFFLINE) {
+		dev_err(dev, "can't change firmware while running\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	len = strcspn(fw_name, "\n");
+	if (!len) {
+		dev_err(dev, "can't provide empty string for firmware name\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	p = kstrndup(fw_name, len, GFP_KERNEL);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	kfree(rproc->firmware);
+	rproc->firmware = p;
+
+out:
+	mutex_unlock(&rproc->lock);
+	return ret;
+}
+EXPORT_SYMBOL(rproc_set_firmware);
+
 static int rproc_validate(struct rproc *rproc)
 {
 	switch (rproc->state) {
diff --git a/drivers/remoteproc/remoteproc_sysfs.c b/drivers/remoteproc/remoteproc_sysfs.c
index 8e39414265ef7..3f44e850ed6f7 100644
--- a/drivers/remoteproc/remoteproc_sysfs.c
+++ b/drivers/remoteproc/remoteproc_sysfs.c
@@ -154,38 +154,9 @@ static ssize_t firmware_store(struct device *dev,
 			      const char *buf, size_t count)
 {
 	struct rproc *rproc = to_rproc(dev);
-	char *p;
-	int err, len = count;
+	int err;
 
-	err = mutex_lock_interruptible(&rproc->lock);
-	if (err) {
-		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, err);
-		return -EINVAL;
-	}
-
-	if (rproc->state != RPROC_OFFLINE) {
-		dev_err(dev, "can't change firmware while running\n");
-		err = -EBUSY;
-		goto out;
-	}
-
-	len = strcspn(buf, "\n");
-	if (!len) {
-		dev_err(dev, "can't provide a NULL firmware\n");
-		err = -EINVAL;
-		goto out;
-	}
-
-	p = kstrndup(buf, len, GFP_KERNEL);
-	if (!p) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	kfree(rproc->firmware);
-	rproc->firmware = p;
-out:
-	mutex_unlock(&rproc->lock);
+	err = rproc_set_firmware(rproc, buf);
 
 	return err ? err : count;
 }
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index d5afad248c451..6b38be3a53932 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -665,6 +665,7 @@ rproc_of_resm_mem_entry_init(struct device *dev, u32 of_resm_idx, size_t len,
 
 int rproc_boot(struct rproc *rproc);
 void rproc_shutdown(struct rproc *rproc);
+int rproc_set_firmware(struct rproc *rproc, const char *fw_name);
 void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type);
 int rproc_coredump_add_segment(struct rproc *rproc, dma_addr_t da, size_t size);
 int rproc_coredump_add_custom_segment(struct rproc *rproc,
-- 
2.53.0



