Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA1427453;
	Tue, 29 Apr 2025 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946744; cv=none; b=Ze0X02NodtWcFxM3xEaCo3BjYaVWsa5tjPODWI2rzbTRBZ+IYQSdYaYWUt6vWECOm6zgxWw+eUFSMffQOvRH886LqWNTvAAFY709bRDOI68xmc3+UzmGQns49hgFR/WRs+UiFATJTywCSDUTFlzOwU+YmgRjg5lSzFaVOyBWKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946744; c=relaxed/simple;
	bh=Cp347MWo4sn3G4YybbN1ucA2UuwBHJDnQcdxMIJx7Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9dDLds2s479goh8WZ/A7IkuZzIBX3sKoCkRwDoJKUe2ksXELBeb/KxAX1yWsi8ZPHaMe3E4L5gKxO5fxd+cxsbwMPlNOAk/zbTUKeAU8I2wz2nm5UCWd46/uZbkXbxaJTAZaKgzu7ZlbCGcuBMkXDG7nqr9EtM2j+kbjtJ6cwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2DDlO7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2DDlO7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD179C4CEE3;
	Tue, 29 Apr 2025 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946744;
	bh=Cp347MWo4sn3G4YybbN1ucA2UuwBHJDnQcdxMIJx7Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2DDlO7y1POrOfY7mxhgTSE53yrEUbDy6HaMAQ8IR4jaW6M3U1GQk+EsmY6itfDlp
	 G9yFquoZ1a8wyMadovNOYsOBGC6sA7EjvuGdwjuj/6MKl2jJ5wbdhlNb5NipNGmS8E
	 EuhV+9o2g2iRqJjTTz2Q1xFQ8UGM1wmE0oWKdnLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 055/286] media: venus: hfi: add check to handle incorrect queue size
Date: Tue, 29 Apr 2025 18:39:19 +0200
Message-ID: <20250429161110.113581211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,6 +188,9 @@ static int venus_write_queue(struct venu
 	/* ensure rd/wr indices's are read from memory */
 	rmb();
 
+	if (qsize > IFACEQ_QUEUE_SIZE / 4)
+		return -EINVAL;
+
 	if (wr_idx >= rd_idx)
 		empty_space = qsize - (wr_idx - rd_idx);
 	else
@@ -256,6 +259,9 @@ static int venus_read_queue(struct venus
 	wr_idx = qhdr->write_idx;
 	qsize = qhdr->q_size;
 
+	if (qsize > IFACEQ_QUEUE_SIZE / 4)
+		return -EINVAL;
+
 	/* make sure data is valid before using it */
 	rmb();
 


