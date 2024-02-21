Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C337F7F2;
	Wed, 21 Feb 2024 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521971; cv=none; b=lLhjju9fx6DoC9qDK6Nkwqk0a2h8GvCxyjCaiZucZjyKNzWt0680so3rYgGF3Gcd6mj3tcGsN7kkq5fdG7Fb+dH3fFhqfPkj4gKEWYLwamGDyORQM4wJkFn0BrQP4f30Vi9xL/m5FLsu6fi3LfaS4FM0hPEjkp8MWnwMvwCCh/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521971; c=relaxed/simple;
	bh=lD9tXeeKj1Dvph7MAyOycXIVbrRfIyb5sugphCvDXyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJkm7jpiNKQEQYYmcOPfn/WexVtcXqM6Ra0xsJEe9iBTu/K4aboWxhPJXGVV89XrvUkmcLGVp8SJiQGjUO7kJ9lmy+0bhmfFb+xcZJYIuRUbNsCZ35osXQLhk6k92h3VIBEaoy43fOrnvKSTFVSqhgZkLYSBHH2jb7SxhNcUrzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9J8QPnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9J8QPnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8611EC433B2;
	Wed, 21 Feb 2024 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521971;
	bh=lD9tXeeKj1Dvph7MAyOycXIVbrRfIyb5sugphCvDXyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9J8QPnS28bxH8F2O7RCtFy+ZIeXPrneOgdvh/qMxteMihqZqmImBx3M13XQOMscB
	 Ix7cqS7FPrNGfhaX6TyTsqNFXtbo0ySTn+pW9g7npxeYWPh+cQZURFRyp/l3vTWxN7
	 YzB8gX6FRBTYqLGGDfZO7/4ThDsNwpQ5D/oqwuvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhaumik Bhatt <bbhatt@codeaurora.org>,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 024/476] bus: mhi: host: Add spinlock to protect WP access when queueing TREs
Date: Wed, 21 Feb 2024 14:01:15 +0100
Message-ID: <20240221130008.803613668@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

commit b89b6a863dd53bc70d8e52d50f9cfaef8ef5e9c9 upstream.

Protect WP accesses such that multiple threads queueing buffers for
incoming data do not race.

Meanwhile, if CONFIG_TRACE_IRQFLAGS is enabled, irq will be enabled once
__local_bh_enable_ip is called as part of write_unlock_bh. Hence, let's
take irqsave lock after TRE is generated to avoid running write_unlock_bh
when irqsave lock is held.

Cc: stable@vger.kernel.org
Fixes: 189ff97cca53 ("bus: mhi: core: Add support for data transfer")
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Tested-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1702276972-41296-2-git-send-email-quic_qianyu@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -1114,17 +1114,15 @@ static int mhi_queue(struct mhi_device *
 	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)))
 		return -EIO;
 
-	read_lock_irqsave(&mhi_cntrl->pm_lock, flags);
-
 	ret = mhi_is_ring_full(mhi_cntrl, tre_ring);
-	if (unlikely(ret)) {
-		ret = -EAGAIN;
-		goto exit_unlock;
-	}
+	if (unlikely(ret))
+		return -EAGAIN;
 
 	ret = mhi_gen_tre(mhi_cntrl, mhi_chan, buf_info, mflags);
 	if (unlikely(ret))
-		goto exit_unlock;
+		return ret;
+
+	read_lock_irqsave(&mhi_cntrl->pm_lock, flags);
 
 	/* Packet is queued, take a usage ref to exit M3 if necessary
 	 * for host->device buffer, balanced put is done on buffer completion
@@ -1144,7 +1142,6 @@ static int mhi_queue(struct mhi_device *
 	if (dir == DMA_FROM_DEVICE)
 		mhi_cntrl->runtime_put(mhi_cntrl);
 
-exit_unlock:
 	read_unlock_irqrestore(&mhi_cntrl->pm_lock, flags);
 
 	return ret;
@@ -1196,6 +1193,9 @@ int mhi_gen_tre(struct mhi_controller *m
 	int eot, eob, chain, bei;
 	int ret;
 
+	/* Protect accesses for reading and incrementing WP */
+	write_lock_bh(&mhi_chan->lock);
+
 	buf_ring = &mhi_chan->buf_ring;
 	tre_ring = &mhi_chan->tre_ring;
 
@@ -1213,8 +1213,10 @@ int mhi_gen_tre(struct mhi_controller *m
 
 	if (!info->pre_mapped) {
 		ret = mhi_cntrl->map_single(mhi_cntrl, buf_info);
-		if (ret)
+		if (ret) {
+			write_unlock_bh(&mhi_chan->lock);
 			return ret;
+		}
 	}
 
 	eob = !!(flags & MHI_EOB);
@@ -1231,6 +1233,8 @@ int mhi_gen_tre(struct mhi_controller *m
 	mhi_add_ring_element(mhi_cntrl, tre_ring);
 	mhi_add_ring_element(mhi_cntrl, buf_ring);
 
+	write_unlock_bh(&mhi_chan->lock);
+
 	return 0;
 }
 


