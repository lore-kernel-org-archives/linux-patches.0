Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9643F482E;
	Thu, 16 Jul 2026 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210879; cv=none; b=H6qfnB3gkAC6TGOByBPO2o4w2CLFyu7hsXWTC62nGGteu7Xd2gEc08+RhNSJ5GF5cVDV6dpx0agK5XjwEgfWuPYuBHOs/ZNzEWXnkjKBTMLnPc6hNAJcR/7UJL38dgWKtQXVBbfH9HwUFZ8FjjItwp2eCqAFr4p1PRiOc3/S9dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210879; c=relaxed/simple;
	bh=qHRSMjIldjV6PpfUv46fiJGnn4UA8pxanSO078CTzfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pidByBZhvGYqdHCJLimyBb1xuM/RuUKuUn9aW9EgSVmedZf2Q+75FhrYgaovHsF/A5eWCOeZN4zUV815YI3/eWLhbkpb//EQoNTSyPz0m0nS703RgRWJNqHpVblJ2rsuUtl7CyPctVxtv332yiV+yKlLscc/zf5RyAp5lchsbX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaQlApuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaQlApuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E227A1F000E9;
	Thu, 16 Jul 2026 14:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210878;
	bh=vNOC4kx8/dz8t2KUTnR7tgDzQA9mPNqRWNQEsBq+OQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaQlApuDlgZO26PwLo6QZ0ZTFzFg4Ns6tP2r2SqYDTgcj1IobWFKqLTVeb8nCdhj6
	 D8iwk7Dv+KVP99KghgAuLwi3WsuEPVZi93XhybvIR0uE2STvPry7lTX0ObbK67pMLY
	 WsB8y5v62C9Z77lOVq+hIVVxBBLrG98NQnARsITE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.18 214/480] coresight: ultrasoc-smb: Fix OOB write in smb_sync_perf_buffer()
Date: Thu, 16 Jul 2026 15:29:21 +0200
Message-ID: <20260716133049.363201169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 98495b5a4d77dd22e106f462b76e1093a55b29a7 upstream.

When the SMB sink is used as a perf AUX sink, smb_update_buffer() calls
smb_sync_perf_buffer() to copy hardware trace data into the perf AUX ring
buffer pages. It derives pg_idx = head >> PAGE_SHIFT from @head, which is
handle->head, and indexes dst_pages[pg_idx]. The pg_idx %= nr_pages
normalization is only applied after the first loop iteration.

This leaves the initial page index underived from the buffer size, which
can result in an out-of-bounds write past dst_pages[] when head exceeds
the AUX buffer size.

Normalize head modulo the AUX buffer size before deriving the page index
and offset, mirroring tmc_etr_sync_perf_buffer().

Fixes: 06f5c2926aaa ("drivers/coresight: Add UltraSoc System Memory Buffer driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/SYBPR01MB788156B3380A36835DB22290AF102@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/ultrasoc-smb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwtracing/coresight/ultrasoc-smb.c
+++ b/drivers/hwtracing/coresight/ultrasoc-smb.c
@@ -338,6 +338,7 @@ static void smb_sync_perf_buffer(struct
 	unsigned long to_copy;
 	long pg_idx, pg_offset;
 
+	head %= (unsigned long)buf->nr_pages << PAGE_SHIFT;
 	pg_idx = head >> PAGE_SHIFT;
 	pg_offset = head & (PAGE_SIZE - 1);
 


