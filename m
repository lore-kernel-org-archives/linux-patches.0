Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BE6253B5E;
	Thu, 17 Apr 2025 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914407; cv=none; b=eDufm8XhVnJUcGDFryy7dPB1zIifMXv12QZt0CKuts8DF4v0ItJhqFXwii9uqd9jLMu+l6k9CeDL+B0VX4A+9C1kiSdwPnJYPSZZ8YyCcwjewG/EzLpcglqXB+E6dSEMDJAfwmtt0KzNVnoL4PJ+I/PWKjECJQU9ywiIHe8tkO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914407; c=relaxed/simple;
	bh=xDnt4i9FjaBf29C50K0NRD/hyqAPoN19pbrQWVC5XHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tvy4XdiRbEEQiPG8BdDh7S0ZT2u/q340eSNC9efYoYZrImISfo6T0sMNbfb64WOCsgtdZnQM8Prtx+Zf0xUX197ET6IZpIB5QodiKP5b+MuIFJCIC74/9q+QOBzLeey2bxapJw66cGMavU3uZ2eEL6uDtecL0rgAkWJKO1VGrHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwDaHYeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwDaHYeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221A7C4CEE4;
	Thu, 17 Apr 2025 18:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914407;
	bh=xDnt4i9FjaBf29C50K0NRD/hyqAPoN19pbrQWVC5XHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwDaHYeAUjfwP/8SaTfa46t3PTJ8noBYN7kHu4et+bpJgT2tZiWzd7Ueoii4fwBOq
	 XOs4zfC3D7lE8MLPdPY+V5XIkcmHcPz5uyMaGfmQ3RsBZpPwVh6cX+EwsABaJYFDHH
	 L+S0Xk8Bv6YvZ0s+v4VBY6kcXfER3UxtIS2yepy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 205/414] media: venus: hfi: add check to handle incorrect queue size
Date: Thu, 17 Apr 2025 19:49:23 +0200
Message-ID: <20250417175119.683083163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


