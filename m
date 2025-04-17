Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6984502F;
	Thu, 17 Apr 2025 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915652; cv=none; b=FjF2/WWiaqwOVqgS679UqIRubaO4jx6c/sKH0oTavrQec0n0m5YA6nv529BTAJ4XtZ7wxOC3CJQVdf78OTi+YXUJ1G1mdPBSmIbYaSpDNf/vJruhbvauHmGt2WzmbkML13tb5htxxf0m6Qx5pGPd4F9fbMHnnwQt7CnUXI/k7Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915652; c=relaxed/simple;
	bh=wgVbUH9KoFQcc7ion4FVfpsn6LlP4368x8hiREnGUFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmHl5FKIMc24McjL2s8OfuKG75ow8RpNLTF5gW+oaA3XYdIojSbzMo8nVjmALH3ymNXCJEodNh+THMUtDETK3KgpuawXldHnQ1q/cNvlA8dCkEztQ7SgmkJ7iw3Tr9FSgI/X0FfEA6N6Z+A7MRYn1cfsx/Ub4dKWtD2hcemL35Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0P1y3xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0P1y3xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA16C4CEE4;
	Thu, 17 Apr 2025 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915652;
	bh=wgVbUH9KoFQcc7ion4FVfpsn6LlP4368x8hiREnGUFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0P1y3xD5fMznWj73++t5ogThI2wr7a6AoIhuopeGyY9uEHmWQCtQgTSMXY4uML4o
	 R6FlvQ6dBAzCZ5kRuNLjNkyDOdCtZSye8B0CsFj144lLISNnivjnftpBesZnOy99VU
	 A5hk7lCEtQh1rW9ZngNM6azanMLjEzfYr+l6YHGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 197/393] media: venus: hfi: add check to handle incorrect queue size
Date: Thu, 17 Apr 2025 19:50:06 +0200
Message-ID: <20250417175115.511203347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit 69baf245b23e20efda0079238b27fc63ecf13de1 upstream.

qsize represents size of shared queued between driver and video
firmware. Firmware can modify this value to an invalid large value. In
such situation, empty_space will be bigger than the space actually
available. Since new_wr_idx is not checked, so the following code will
result in an OOB write.
...
qsize = qhdr->q_size

if (wr_idx >= rd_idx)
 empty_space = qsize - (wr_idx - rd_idx)
....
if (new_wr_idx < qsize) {
 memcpy(wr_ptr, packet, dwords << 2) --> OOB write

Add check to ensure qsize is within the allocated size while
reading and writing packets into the queue.

Cc: stable@vger.kernel.org
Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -187,6 +187,9 @@ static int venus_write_queue(struct venu
 	/* ensure rd/wr indices's are read from memory */
 	rmb();
 
+	if (qsize > IFACEQ_QUEUE_SIZE / 4)
+		return -EINVAL;
+
 	if (wr_idx >= rd_idx)
 		empty_space = qsize - (wr_idx - rd_idx);
 	else
@@ -255,6 +258,9 @@ static int venus_read_queue(struct venus
 	wr_idx = qhdr->write_idx;
 	qsize = qhdr->q_size;
 
+	if (qsize > IFACEQ_QUEUE_SIZE / 4)
+		return -EINVAL;
+
 	/* make sure data is valid before using it */
 	rmb();
 


