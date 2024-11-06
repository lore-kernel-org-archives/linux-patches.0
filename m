Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8621D5AD7;
	Wed,  6 Nov 2024 12:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895118; cv=none; b=QEkwx0x6808ytwRkA6euJzzG2gmyvtWADGGjAydoUqZVFN3+7DUzlugHi1qFdBMaIreDXDijDVqMjQ8q+GpuX5NMHh2MbgUtdrb/JvtA7ED39wA24PtoDZf5O0xrzeuVyZCNzHF3lnDlWlb6oVxQvACakbHM5GeIR7Qkfmai6i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895118; c=relaxed/simple;
	bh=DVpqmLtZMMMV9K0o+oodi3/uO1dyMLSUFSVheyK9XNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO8EJTNAx8qm25AzT+v9tPShGYivAjalBmaPmHHTLdYAhgoSPG6uvSAffSCiTg62KI/vobumfuUrgliGH6nOi2ra0UmKxVHb4YMclF27xIUFrPNo46tJTAV/eWB+FtIgM5QiA1tUZMmIqUH9eEr8Uqg1neb5U6Hf4DNx4NESXUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeagDPcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeagDPcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AD1C4CECD;
	Wed,  6 Nov 2024 12:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895118;
	bh=DVpqmLtZMMMV9K0o+oodi3/uO1dyMLSUFSVheyK9XNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeagDPcc+1P2XPrdPhf4al9JprI2ucCV00YRHVEHxoMmzEPuyDt2WcTcMpvpDPMrL
	 UnZEo6pGQ88/RU7FfIxBvdPksjNmDc8lMDsrlX3mykWxIVxt26VapJp7s56u4JEfDx
	 OtDpbp3GiDvpRkWvs1a0Q89rF7PNsM/LBI6pF1js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Jann Horn <jannh@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4.19 111/350] firmware_loader: Block path traversal
Date: Wed,  6 Nov 2024 13:00:39 +0100
Message-ID: <20241106120323.643637760@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit f0e5311aa8022107d63c54e2f03684ec097d1394 upstream.

Most firmware names are hardcoded strings, or are constructed from fairly
constrained format strings where the dynamic parts are just some hex
numbers or such.

However, there are a couple codepaths in the kernel where firmware file
names contain string components that are passed through from a device or
semi-privileged userspace; the ones I could find (not counting interfaces
that require root privileges) are:

 - lpfc_sli4_request_firmware_update() seems to construct the firmware
   filename from "ModelName", a string that was previously parsed out of
   some descriptor ("Vital Product Data") in lpfc_fill_vpd()
 - nfp_net_fw_find() seems to construct a firmware filename from a model
   name coming from nfp_hwinfo_lookup(pf->hwinfo, "nffw.partno"), which I
   think parses some descriptor that was read from the device.
   (But this case likely isn't exploitable because the format string looks
   like "netronome/nic_%s", and there shouldn't be any *folders* starting
   with "netronome/nic_". The previous case was different because there,
   the "%s" is *at the start* of the format string.)
 - module_flash_fw_schedule() is reachable from the
   ETHTOOL_MSG_MODULE_FW_FLASH_ACT netlink command, which is marked as
   GENL_UNS_ADMIN_PERM (meaning CAP_NET_ADMIN inside a user namespace is
   enough to pass the privilege check), and takes a userspace-provided
   firmware name.
   (But I think to reach this case, you need to have CAP_NET_ADMIN over a
   network namespace that a special kind of ethernet device is mapped into,
   so I think this is not a viable attack path in practice.)

Fix it by rejecting any firmware names containing ".." path components.

For what it's worth, I went looking and haven't found any USB device
drivers that use the firmware loader dangerously.

Cc: stable@vger.kernel.org
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Fixes: abb139e75c2c ("firmware: teach the kernel to load firmware files directly from the filesystem")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20240828-firmware-traversal-v3-1-c76529c63b5f@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/main.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -565,6 +565,26 @@ static void fw_abort_batch_reqs(struct f
 	mutex_unlock(&fw_lock);
 }
 
+/*
+ * Reject firmware file names with ".." path components.
+ * There are drivers that construct firmware file names from device-supplied
+ * strings, and we don't want some device to be able to tell us "I would like to
+ * be sent my firmware from ../../../etc/shadow, please".
+ *
+ * Search for ".." surrounded by either '/' or start/end of string.
+ *
+ * This intentionally only looks at the firmware name, not at the firmware base
+ * directory or at symlink contents.
+ */
+static bool name_contains_dotdot(const char *name)
+{
+	size_t name_len = strlen(name);
+
+	return strcmp(name, "..") == 0 || strncmp(name, "../", 3) == 0 ||
+	       strstr(name, "/../") != NULL ||
+	       (name_len >= 3 && strcmp(name+name_len-3, "/..") == 0);
+}
+
 /* called from request_firmware() and request_firmware_work_func() */
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
@@ -582,6 +602,14 @@ _request_firmware(const struct firmware
 		goto out;
 	}
 
+	if (name_contains_dotdot(name)) {
+		dev_warn(device,
+			 "Firmware load for '%s' refused, path contains '..' component\n",
+			 name);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = _request_firmware_prepare(&fw, name, device, buf, size,
 					opt_flags);
 	if (ret <= 0) /* error or already assigned */
@@ -622,6 +650,8 @@ _request_firmware(const struct firmware
  *      @name will be used as $FIRMWARE in the uevent environment and
  *      should be distinctive enough not to be confused with any other
  *      firmware image for this or any other device.
+ *	It must not contain any ".." path components - "foo/bar..bin" is
+ *	allowed, but "foo/../bar.bin" is not.
  *
  *	Caller must hold the reference count of @device.
  *


