Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8193E3C9893;
	Fri,  9 Oct 2026 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556608; cv=none; b=cmACJjhRU+TtMvg0zhyFwXdbJfslCoINvY/O+0VMumP2eDBQ8Prp1fBRKPHMLa04DBUw74FeJw9qdQI14gVdN042NmWLLSoMfDmDU2F4/UjXTd0y6HoKPto1YyptvLbjgkqV4qD5dg6lZj3ijXyOnbypzj9Gthc4a/v/ULjMhHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556608; c=relaxed/simple;
	bh=J4IAbH80CTPxS2qNR8ODaZoH2mDcUuBh+67jieHFkEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFfGqZ5ZSgHjW93tcI1TBWGLOHIxkUci6BuP/zvPRIyqsPl9j/M6/Nn0wlnxoboMoih7mD17E0mBC90TDEQbnE7VW9UkIc9QCVqPG6jy6NlmEen0rHF6fbTO/YOVvMD/bj+eoRB/sUe3WGIWgMgfi0/n+QDifPvEmsRV0uOs1KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZ0Av9dq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZ0Av9dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC311F000FF;
	Fri,  9 Oct 2026 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556607;
	bh=QZYJjcTBUMoDg8Zv5YQYZC1frRWcD8wjsN7mfRLvgS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZ0Av9dqBScxCI7SMo3WDfPnlC56l5zd3cYdUjP/d9YftnZVIqqdyICcEE+/RdLzR
	 gL0Mc3miUGwbLKQ8CXq+LqUZtsQ3uBZ8rgjroyF7HQ+d6nPmM8mc37PYZE6gLrHRti
	 2t6gZZvJUWbEHXs8W4CFb6eeXlmXzcfcS3ns79Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
Subject: [PATCH 7.2 208/428] usb: storage: sierra_ms: reject short SWoC info transfers
Date: Fri,  9 Oct 2026 16:09:05 +0200
Message-ID: <20261009140950.695751233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


