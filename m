Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CA546C4A4;
	Tue, 21 Jul 2026 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654873; cv=none; b=cjm9YN055HBhiLT6X9Em36b41Ilrn6ZGcDVKDr80SkWTu043zWYC4VhV480FeWiTy6EX2DPPZqcQTayVzhiBvUh9ptu83RGg9dbdXnvgHXJp5aX9kVsxJZ5tpHVCoOJHEIpqpFpNfCWUO9y/KuE7asUzwY26R6HCZZN1MR/u2As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654873; c=relaxed/simple;
	bh=xBKtguv0BnoD6Q5u35lO4xH6LiRzX3KozOwQnmCS+Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byAfo34Mr9bUNaBQ7ASDi5xp6gnyGCf8fDYns2xBQtxB7cRxdpzx4hmajz/rXbe+JHyhiOq7q3LzvFwS5DeVkzgjT2SP6pkV/spoDkT9Iup/oUD94R6sg6BQtIQhwAyQIZ0YqcyE2shh0KeLik5av05gbESHj0yp3dUS3vUcjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll743GUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll743GUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B4C1F000E9;
	Tue, 21 Jul 2026 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654870;
	bh=nHyW271tk7megVbmgSDaJwTRKzaKpLj6tRwq+l2N+Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll743GUnPKGjpZBLQuhBK0Y57TP0gGANuJ/sC0tW1F/di9aWtOc60RxvTz3rx53sb
	 p2tG8DFp3fD4U7GPf3BMqjZ2u85MJIsJnyBT7QzPgAGAWQZeMHL9YOV3LSs/Vtxkde
	 HM119Zo4H8Ox1zY26JUxYSSsdvv2BWmfpbHFrnGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonraushan <raushan.jhon@gmail.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 7.1 1869/2077] accel/ivpu: Reject firmware log with size smaller than header
Date: Tue, 21 Jul 2026 17:25:42 +0200
Message-ID: <20260721152636.815913679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


