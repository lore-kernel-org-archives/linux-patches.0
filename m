Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8563290AD;
	Tue, 16 Jun 2026 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623717; cv=none; b=fBkyfCMN6IjXehgJd9NKUXfebolY2GCeCKDzw+6hzseNagWAlJjbbJcNliIJHjmp1M+o1kySCGCpHKRwr8RY1LmBOKaPwZs6fqlV/v8s6znA1RPijVwy/ZVTegdQZ69q/fIu1JJoLwkwjmmWOtGnnXM47P2Uf5dy6nDnitMlcPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623717; c=relaxed/simple;
	bh=AO2OfowXtIv023dRXVwtzVE2nk+8q8qhrF4r5m9g2/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATVz6AMTLYH/7kCbq6NfvmPRURLhVQIk87ecWtL6nvmKNrQvnAKODPS9brSn8jVjXpmQPPdtbl3VgcB6Rp6v/NxtFY02/+PQrk+aFp7G53I/5ajm7A6SiRqrZtmIPKJCOPQ3znC6bMkA/dFksPwAkNTRyENSnipdNbQ5rrKYGcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIX9Sld3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIX9Sld3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425301F000E9;
	Tue, 16 Jun 2026 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623716;
	bh=8NPZ5k7gAi0kFixJqo1xd70jQcq7Pvd/4F0eYO7RPMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIX9Sld3PHInqz/QZAz1cY3k7guZPr3i4YYhu9mFK0vQG2UK1ETDTrByn37jPs0bd
	 RcucbL+lSpLMXoEQ45upnqUTe8QsPomWRzxhYpO8xXopnuOi2N/WZuLkU7Que2vZfQ
	 cXNkTQ5GcbrLHD/WsJP1cKkQcbhpnHbj/OKHo82Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 7.0 183/378] accel/ivpu: Fix signed integer truncation in IPC receive
Date: Tue, 16 Jun 2026 20:26:54 +0530
Message-ID: <20260616145120.012538590@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


