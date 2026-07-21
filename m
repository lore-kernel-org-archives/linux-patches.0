Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A353C435A96;
	Tue, 21 Jul 2026 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665250; cv=none; b=fcqaDa4k241V2q5LXrxryts/ZKzAmhsxN0+o1K2IfWkJGSRwJuztv/yln2oapuwzgt2/ikj622hsIev0j+WnEO6MDmTthwRgQZY2TZDumvDbH6lkC0xeUqf0+9gViSXDQ4cS+yPx3fO3oyeufxaaQ2NsuW1FrbsV0ThaQ+yqhPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665250; c=relaxed/simple;
	bh=BtZ8+OsLV2Tx5zfCpSCry7cZSv1TCl/xAm13SIhK5Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIx10G8EPHLbqKFWDs8OYxRy4/b69BDC45VMrz1+Qhd9SiMADtUPqHH2F+kAHy59jkXh3CDnZETb1it1yRh4j47/+DH0PBsyKJoEaVjRmPHaPvoK2QZb1pFQ1q2rX3oSpxxe6WV9xLmOZCYpgEHPz+4J/t53yh8Y60hq0PuRo5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygAKnyUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygAKnyUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AD51F000E9;
	Tue, 21 Jul 2026 20:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665249;
	bh=ilMckJcawzHyJ4Cgd4N0i2O1pIeS3bsjLqffuXwka5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygAKnyUFO8xjTwaWA6s1t6lweBVCU99UEo0QVybLva7fBRaLwZ2YaDc9V7UtxDmS/
	 O+0NG0Wx2pzucU2mkJgmVLLk9LfDqFbP4Y2lx9lu98tgQKMDkyXQBPzSLQh2xxp6bi
	 4bZ+co4dadGGTDvjtRZNJ+Cg+zpGHvfmniviggwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.6 0179/1266] coresight: ultrasoc-smb: Fix OOB write in smb_sync_perf_buffer()
Date: Tue, 21 Jul 2026 17:10:16 +0200
Message-ID: <20260721152445.812876847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -361,6 +361,7 @@ static void smb_sync_perf_buffer(struct
 	unsigned long to_copy;
 	long pg_idx, pg_offset;
 
+	head %= (unsigned long)buf->nr_pages << PAGE_SHIFT;
 	pg_idx = head >> PAGE_SHIFT;
 	pg_offset = head & (PAGE_SIZE - 1);
 


