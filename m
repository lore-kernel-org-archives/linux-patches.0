Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2043339061C;
	Tue, 13 Oct 2026 12:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895157; cv=none; b=q300prFMiUOOp11Ff4cguJCBXL0kLPmnnCFahvCV5t7H8dddF25viL3wmIp8XnHxWrBDkWKAxZ4tqpCFFD0CNQT/FwLo0Y+Kf4Ijp1HceNK1acMmjdY1BuHox4Qnn13FjnFo0L+eUJFt/W0nE5wcAYfEZcP06dNZlmqs7XUn4Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895157; c=relaxed/simple;
	bh=SaOY1SlH+AcmfZmFdWnzeCdAd5iCGnDlYP+lcn6JkP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQKr8K+xjhgXd4PHSxvh/loD1u6n/DR3frTlUOOGTNNQ6aPiu7J3DTTw1PEEkmUjVTGmutHZEpyBVlP75/Yi9lv1unB3SjxzDyPdLeMw1ckI7PwY+TWUsv44RMX11WddUA0bos2sohX8jMfvxbJKSSDsRr37SlTx/kSW007x1fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACUWXVFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACUWXVFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6DD1F000FF;
	Tue, 13 Oct 2026 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895155;
	bh=3NyrCXIWWcEgAKeKQxlZ95K6n8kaCSkdRG/Fnh7bJBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACUWXVFpsyMbC1hDYoWIU6vnz+Ns1RR4Wv8jWfKUVRcNYLT6vwzOAZ97m7ItFq8rZ
	 fqtijZDQGI+VZgy0HpL63wjJkXsYNy3nOeBGY7rMU+UqZCX5NH7VmfX76szWXNE5Eq
	 CuOKmwZp5bGVsXmLDzLt5B6WuDsyXn3l9uSTHvSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
Subject: [PATCH 6.12 136/497] usb: storage: sierra_ms: reject short SWoC info transfers
Date: Tue, 13 Oct 2026 13:35:03 +0200
Message-ID: <20261013112911.118257453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>

commit 8a0200d14acd9db388b85cd016e68a4e60d900ec upstream.

sierra_get_swoc_info() requests sizeof(struct swoc_info) (60) bytes
from the device via usb_control_msg(), but its callers only treat a
negative return value as failure. A device that answers the
vendor-specific GetSwocInfo request with a short IN transfer is
therefore accepted, leaving the tail of the freshly allocated
(kmalloc(), non-zeroing) swoc_info buffer uninitialized.

truinst_show() subsequently prints swocInfo->rev, swocInfo->LinuxSKU
and swocInfo->LinuxVer from that buffer into the world-readable
(0444) "truinst" sysfs attribute. An emulated/malicious USB device
(VID 0x1199, PID 0x0fff) can exploit this to disclose up to 5 bytes
of stale kernel heap memory (kmalloc-64) to unprivileged userspace,
once per sysfs read, indefinitely. On kernels built without
init_on_alloc this leaks recently freed heap contents.

Only accept the transfer when the full structure was received.
sierra_ms_init() already retries failed queries, so well-behaved
devices are unaffected.

Fixes: 32fe5e393455 ("USB Storage Sierra: TRU-Install feature update")
Cc: stable <stable@kernel.org>
Signed-off-by: Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
Assisted-by: Kimi:K2 [Kimi Code CLI]
Link: https://patch.msgid.link/20260910140343.49371-1-syedlabeeq@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/sierra_ms.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -77,6 +77,13 @@ static int sierra_get_swoc_info(struct u
 			sizeof(struct swoc_info),	/* __u16 size 	     */
 			USB_CTRL_SET_TIMEOUT);		/* int timeout 	     */
 
+	/*
+	 * A short IN transfer leaves the tail of swocInfo uninitialized;
+	 * only a full transfer is valid.
+	 */
+	if (result != sizeof(struct swoc_info))
+		return -EIO;
+
 	swocInfo->LinuxSKU = le16_to_cpu(swocInfo->LinuxSKU);
 	swocInfo->LinuxVer = le16_to_cpu(swocInfo->LinuxVer);
 	return result;


