Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF95B3B38B8;
	Thu, 30 Jul 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427022; cv=none; b=MMbVaklVx41wXGTY9mhiWfpRuNCfXOaveuWLTgZ5klPPCNYZJRu1h6qUHNnzIMWiAxywBtLJc33WdfJEA51dzfSBFhnmB5v/FWDIgDxexwuM3LhdfaW6IW7mvX7zVzkUqpsy8+3wBc7/IOupMbqca+KFSvL4MM7zf/Eya2wsqsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427022; c=relaxed/simple;
	bh=ZwJWyh0DVYjAyz7OdoLsQbn/a1pobCHlClh6WQWP7Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXxQc1FSgzIhfoP4jpiOx/FN64LYs7r//CYy2TYXsHmSszA+AZjPpAk6+2EFa2hFBASoxiP7gC9VPayk2teI7abWZ5XyGWosDtSJ8TzSvs1n6dQC2/Pqdf2F8p8LOf0xAGzyqmFeQfidVakYRLeXn9rqzx/u2n9bTzhB/zgvBzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3qJuC48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3qJuC48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1668F1F000E9;
	Thu, 30 Jul 2026 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427021;
	bh=wpZTymfrC2zVnRj70rh75BASxhzZqV8mmzedOekmMk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3qJuC48OUvvS2SaQKklMXO96O8oIzqQfHa/jiUYoE/+ROdaYT0rm+TrR20vOUq8Y
	 ztZjw8eLiUNNd1LMnqHFwTCnwFTo5G3a3O5QWqGA6RTGXeZvPxGszEyIs3O50VxIJf
	 Dp00NmqeWWdLPXORv1iY74KG9q3iXwBQxokZQpfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonraushan <raushan.jhon@gmail.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/484] accel/ivpu: Reject firmware log with size smaller than header
Date: Thu, 30 Jul 2026 16:08:41 +0200
Message-ID: <20260730141423.951550944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Raushan Patel <raushan.jhon@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_fw_log.c b/drivers/accel/ivpu/ivpu_fw_log.c
index 95065cac9fbdc4..ccad9aa99e5d64 100644
--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -43,6 +43,10 @@ static int fw_log_ptr(struct ivpu_device *vdev, struct ivpu_bo *bo, u32 *offset,
 		ivpu_dbg(vdev, FW_BOOT, "Invalid header size 0x%x\n", log->header_size);
 		return -EINVAL;
 	}
+	if (log->size < log->header_size) {
+		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
+		return -EINVAL;
+	}
 	if ((char *)log + log->size > (char *)bo->kvaddr + bo->base.size) {
 		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
 		return -EINVAL;
-- 
2.53.0



