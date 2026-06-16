Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A35B4657CF;
	Tue, 16 Jun 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625592; cv=none; b=g/4Vvw5YCLj+1NOWrzYeu7g9y79GCUSsHMjh5A6Zb6h1UHBoNL1piXtRk5NVxo/Tyj4JPIE/BPvZZd468oPX9azrehdztgvKtcCuOck3UzZN+DkEvPstRxcm1ezNjUbdsf9odRfkQokr8U0eijnIr0c1u62IfjOcml6MP9R8RvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625592; c=relaxed/simple;
	bh=7JWvoYyCEuERgLdFhzpSUHYtkHj2wTuDXYS2tPXOMJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJTuw0VJIChVoJyf3nDkbEh31Cqc193PcCkx5cCpjWfqVBGN3OdEqC+A4WbITAGG6MAPbKmvfTnRIxzq0CHddukRKmZ//kXr0OR8AQzqBp0tmllkidEE9LsUft/XkyEy88XcLjcJoT9CdUs51IKC/DXH7IensuOddN9LOjEBf6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lInZGqXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lInZGqXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9B61F000E9;
	Tue, 16 Jun 2026 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625590;
	bh=ubBVsrjTsTzQaAd/YJmQo9qGvMiFXZsRF35kYbCWf/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lInZGqXFbTR7CgIexQFI7K/W1K8bt4APDlqyhEmVl8NaBT4rmqROutEni8sme+aod
	 ruOqxv5jgNYX2JH+hhn8yy1P6ujU7y4kAc764TsXkXySojnWkYJa4iwwQv6mMrfP1g
	 RZxnLEG3UdU1d09kOXBkhctNxanEHbrHhwOq4nBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 155/325] accel/ivpu: Add buffer overflow check in MS get_info_ioctl
Date: Tue, 16 Jun 2026 20:29:11 +0530
Message-ID: <20260616145105.453240343@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>

commit fb176425837693f50c5c9fc8db6fbb04af22bd0a upstream.

Add validation that the info size returned from the metric stream info
query is not exceeded when checked against the allocated buffer size.
If the firmware returns a size larger than the buffer, reject the
operation with -EOVERFLOW instead of proceeding with an incorrect
buffer copy.

Fixes: cdfad4db7756 ("accel/ivpu: Add NPU profiling support")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260529120841.135852-1-andrzej.kacprowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_ms.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/accel/ivpu/ivpu_ms.c
+++ b/drivers/accel/ivpu/ivpu_ms.c
@@ -282,6 +282,13 @@ int ivpu_ms_get_info_ioctl(struct drm_de
 	if (ret)
 		goto unlock;
 
+	if (info_size > ivpu_bo_size(bo)) {
+		ivpu_warn_ratelimited(vdev, "MS info overflow: %#llx > %#zx\n",
+				      info_size, ivpu_bo_size(bo));
+		ret = -EOVERFLOW;
+		goto unlock;
+	}
+
 	if (args->buffer_size < info_size) {
 		ret = -ENOSPC;
 		goto unlock;


