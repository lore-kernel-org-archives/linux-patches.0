Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860F446AEDF;
	Tue, 16 Jun 2026 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625597; cv=none; b=g1CVjqImnk4pKpyk8jleB+3Om3FmSbjyFoygf+cDrIG6Pl32p4aIsunU4KkC32sxcqE3XqvymDyp3TJans+AuXBGpXZQP1CcGNpMBtapgtFaSRuMPO1bccAvtBhd3gnWGhjsVMHGHQSjOVG914kGQ0S92Gc9j6WtMqlprwdUnAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625597; c=relaxed/simple;
	bh=PP/AkbTM3Oj/KkUJ8QJhTgHFm1MkUL0IATYKxI1TQnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKN5LClqQFcsCFH2HPmZyk7KVxcDVnRE30+PCsCVV8k6yNZE2LaA7aJFeLJc1Uw2SFTgr8OV/0gdC8hQII+sfMnFy3yHWj59V3A47XOwuO1V8EweQJ7HOBnRsCiF7XdHggpgzsoYWLH3Vw52YEQUSU+VwT6s33VD3Plel5RwSs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRX+k6nv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRX+k6nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6F81F000E9;
	Tue, 16 Jun 2026 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625596;
	bh=g7QVX3YGxhvFYuPx0/HHSVMB7VYjI9YfovAQ2SZDUDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRX+k6nvuvnswi9WMNk1KTCJNBdSi55XnNW8Hg6ZiQx1jPEluqWgxe6baOQlcfGdC
	 wlf7NOgUMf/lSDKxIgJWaSZisJ/kr7Y0MU5oJ3nNQg+6WUX1s43MgtBdhvoRhMSZ26
	 Khf+fxKnWnSZkoJSnA040xpu5ekVe5cPJvnhU+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 156/325] accel/ivpu: Fix signed integer truncation in IPC receive
Date: Tue, 16 Jun 2026 20:29:12 +0530
Message-ID: <20260616145105.513153963@linuxfoundation.org>
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

commit d9faef564438d1e4579c692c046603e7ada7bdf4 upstream.

Fix potential buffer overflow where firmware-supplied data_size is cast
to signed int before being used in min_t(). Large unsigned values
(>= 0x80000000) become negative, causing unsigned wraparound and
oversized memcpy operations that can overflow the stack buffer.

Change min_t(int, ...) to min() as both values are unsigned and can be
handled by min() without explicit cast.

Fixes: 3b434a3445ff ("accel/ivpu: Use threaded IRQ to handle JOB done messages")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260601161643.229342-1-andrzej.kacprowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_ipc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -276,7 +276,7 @@ int ivpu_ipc_receive(struct ivpu_device
 	if (ipc_buf)
 		memcpy(ipc_buf, rx_msg->ipc_hdr, sizeof(*ipc_buf));
 	if (rx_msg->jsm_msg) {
-		u32 size = min_t(int, rx_msg->ipc_hdr->data_size, sizeof(*jsm_msg));
+		u32 size = min(rx_msg->ipc_hdr->data_size, sizeof(*jsm_msg));
 
 		if (rx_msg->jsm_msg->result != VPU_JSM_STATUS_SUCCESS) {
 			ivpu_err(vdev, "IPC resp result error: %d\n", rx_msg->jsm_msg->result);


