Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA540802F;
	Tue, 21 Jul 2026 18:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659023; cv=none; b=XjHbCO5iRorishov+M2HlchkWh3fQl9ZUG/y2Rlhshc4bFv+HKSLvTZQ8O08NI8bnVgjp4sSExih4u4GYWmQq/1up+txc7DcNrHMyKqmbnr/LCez+YT8Kl1+UOccbv0M6TiC6730t2H1lmpCn7StH5MsNidb7RmOakx0bjoApyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659023; c=relaxed/simple;
	bh=nxYY+gfiWdpsL4EQiTml/IJ2Xncigv5xw1luNs6apZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmrfoiDN6lYIWzR5YRtE3wJ/uQrQ1e2MzytBZ3lO9XJU2WWavUaFNYnCNmKjhFxWF52lwfhGh1XCe2lF5TbTplRKpKagiwNa+oHi6V5U3JzyB59QQwDQ4cW03MHFi68Yd312UmxzhHVP2AVBLCW6aYY/eTzUw7e/6GNOTMQ3QYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSkMobAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSkMobAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048C61F000E9;
	Tue, 21 Jul 2026 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659022;
	bh=CExdT9Tog77529Dae/XLWz9gHKJpmt61Xd7QoVB8vFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSkMobAf3UWvtt0hDhGFqrqNMl6Zr6WKRiMK6CXBAhUiesdONq3v38YLfMdlWU5SC
	 KCTDFlDD99kNpLCEex1JkJ5bmREjP5LSuhBb0Xfw8f2eo5szAiNZwq3YrPPbnd8Ius
	 hsanIbFtvg+OQQprq7qD7a1HInZsRs+mB9WIK7kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonraushan <raushan.jhon@gmail.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 1364/1611] accel/ivpu: Reject firmware log with size smaller than header
Date: Tue, 21 Jul 2026 17:24:40 +0200
Message-ID: <20260721152546.133089386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jhonraushan <raushan.jhon@gmail.com>

commit ddb44baed257560f192b145ed36cf8c0a412de47 upstream.

fw_log_from_bo() validates the tracing buffer header_size and that the
log fits within the BO, but never checks that log->size is at least
log->header_size. fw_log_print_buffer() then computes:

  u32 data_size = log->size - log->header_size;

which underflows to a near-U32_MAX value when firmware reports a log whose
size is smaller than its header. That huge data_size defeats the
log_start/log_end bounds clamps added by commit dd1311bcf0e6 ("accel/ivpu:
Add bounds checks for firmware log indices"), so fw_log_print_lines() reads
far past the small real data region of the BO. A size of 0 also makes
fw_log_from_bo() advance the offset by 0, causing the callers to loop
forever on the same header.

Reject logs whose size is smaller than the header (which also rejects
size == 0).

Fixes: d4e4257afa6e ("accel/ivpu: Add firmware tracing support")
Cc: stable@vger.kernel.org
Signed-off-by: Jhonraushan <raushan.jhon@gmail.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260715074206.867712-1-raushan.jhon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -43,6 +43,10 @@ static int fw_log_from_bo(struct ivpu_de
 		ivpu_dbg(vdev, FW_BOOT, "Invalid header size 0x%x\n", log->header_size);
 		return -EINVAL;
 	}
+	if (log->size < log->header_size) {
+		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
+		return -EINVAL;
+	}
 	if ((char *)log + log->size > (char *)ivpu_bo_vaddr(bo) + ivpu_bo_size(bo)) {
 		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
 		return -EINVAL;


