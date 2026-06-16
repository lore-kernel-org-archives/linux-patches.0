Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6F23A8746;
	Tue, 16 Jun 2026 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627156; cv=none; b=aALNv8fxjtKcRerEUzrUhkNbqyfpM6XrBpDYPTTJFNOaEBvBTR/rLu8eeaIaYIj4WQ4Mhpivy5yy24fCkPIRjrx6E8Brxt1Gt3WUB/VsHc7lxsnmuRqIMUYylI0Vl/+GwWcoWMPlofJkRSmyZVhrc4ISPsXLYF0qG9GlXcse2ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627156; c=relaxed/simple;
	bh=OIzVVvn2hpuvmws6nRCQdr+SgbqNzZyB1Eb7OKIjudM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB/s26W2OUqOqIGTwoYxjBcsmu7UfcKeS5T/bl1QZIWArFEcvLW6DhhtlRZpmeMgVeutpjbrGNuIYl9OQIxDHuysTqpKBbfD1Jx4rN4d6M4JdDrra9r6raIOJYYrR23iXMv7bN9s7BxSxZ03hWShzIpQ/6WMvtjN/REnXNunOXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgK8s6Bk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgK8s6Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C041F000E9;
	Tue, 16 Jun 2026 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627155;
	bh=QNpDJjmVWtuCqL+SnALRdOAJlCwzuwtk9ezxJyiDyXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgK8s6BkmBae73IFyy89pMoTkmXBOPYwq02wihdqVC5rwL+hNPdmUNJ+KajwJWdwg
	 gIjphlHso4z6SJapb5oCmMC09RjA2ZzXPkDz96rsU6eYbP+A+Bpq8i0TPOv7lKwhQH
	 eaAK0M0inna5C3cmHFuigsSpsaJBWUz/Wqfa5WPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 127/261] accel/ivpu: Fix signed integer truncation in IPC receive
Date: Tue, 16 Jun 2026 20:29:25 +0530
Message-ID: <20260616145050.971215254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -275,7 +275,7 @@ int ivpu_ipc_receive(struct ivpu_device
 	if (ipc_buf)
 		memcpy(ipc_buf, rx_msg->ipc_hdr, sizeof(*ipc_buf));
 	if (rx_msg->jsm_msg) {
-		u32 size = min_t(int, rx_msg->ipc_hdr->data_size, sizeof(*jsm_msg));
+		u32 size = min(rx_msg->ipc_hdr->data_size, sizeof(*jsm_msg));
 
 		if (rx_msg->jsm_msg->result != VPU_JSM_STATUS_SUCCESS) {
 			ivpu_dbg(vdev, IPC, "IPC resp result error: %d\n", rx_msg->jsm_msg->result);


