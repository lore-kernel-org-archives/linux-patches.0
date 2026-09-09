Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A76855C1D2;
	Wed,  9 Sep 2026 14:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964100; cv=none; b=cIQb8fTMzbFghui5H8iFBI8sqisMVjEDoWkfmBBXjsqQnJ+aFiWRrgvwNcCFIg1ZdcRHf73TqmY2LlEuaKavDiPmYjqPhnYGhR3h0rfiMVpVS9GBY++SRZi8QrrB0W3We/o4VI05N/l/AGYOXeAHYbPK2r0mB+DQ03SuEjyDWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964100; c=relaxed/simple;
	bh=e5QNryxGdeghiBa2uAHNIrBxGa9JH+MOzU9dnDD2FzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf4bw1fO5yzwsnpGebxYQHtdYX0PrBt1+ZlZjHlPWBQWs9XgEPZnfkEtfy7ffyc6H1OkTR5gCjDDPoIBJ9/09YRwrWbYXrQZVUO3ypKmSlkhUHKNX/SUCp5iIZ/RFlI0bPgm1sacSs3Jj+s8l7fWkcbMiHBJTiOWeLnBty33foU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdAzO9hc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdAzO9hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0F61F00A3A;
	Wed,  9 Sep 2026 14:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964098;
	bh=aAj6uUdeUNhFVm7/Wb9h6MBQnQLcPHJN7sA1Ec5Iyf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdAzO9hcP+tIedt56H60n3Qya5ll5ZIEeM0n538NV0z0agM3aMggAqTqQDA9hXVUX
	 JzAYLHGtLkB2SRz0JQY9kzrqbjYpIQ6owjdIbGCEbxKovwb/pvREK9PYyM3YBlly/5
	 jF8DMBFwJGOjBcwAkm4HDTl9L6RdO75IhN6EdEJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 305/583] media: rtl2832_sdr: release URBs and stream buffers on start_streaming() failure
Date: Wed,  9 Sep 2026 15:39:50 +0200
Message-ID: <20260909134248.581245001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Valery Borovsky <vebohr@gmail.com>

commit fe50cdaebf12cd32ff9a44d92bfd6fbc2300dbd4 upstream.

rtl2832_sdr_start_streaming() calls rtl2832_sdr_alloc_stream_bufs(),
rtl2832_sdr_alloc_urbs() and rtl2832_sdr_submit_urbs() in sequence and
shares a single err: label that only unlocks the mutex and returns.
When alloc_urbs() succeeds but submit_urbs() fails, or when alloc_urbs()
itself returns -ENOMEM after alloc_stream_bufs() has already succeeded,
the URBs and/or the coherent DMA stream buffers stay allocated while
streaming reports failure to vb2. Two latent defects follow on the next
VIDIOC_STREAMON:

1) rtl2832_sdr_alloc_stream_bufs() unconditionally resets dev->buf_num
   to 0 and overwrites dev->buf_list[]/dev->dma_addr[], permanently
   leaking the coherent DMA memory allocated by the previous attempt.

2) rtl2832_sdr_alloc_urbs() never resets dev->urbs_initialized and only
   increments it. After a second successful pass urbs_initialized can
   exceed MAX_BULK_BUFS, so the subsequent rtl2832_sdr_free_urbs() walks
   from urbs_initialized - 1 down to 0 and reads past the end of
   dev->urb_list[], passing garbage pointers to usb_free_urb().

Mirror the teardown that stop_streaming() already performs: on the error
path call rtl2832_sdr_free_urbs() and rtl2832_sdr_free_stream_bufs()
before unlocking. Both helpers are idempotent (free_urbs kills and zeros
urbs_initialized; free_stream_bufs is gated on URB_BUF and clears the
buf_num counter), so partial-failure paths and the no-allocation paths
remain safe.

Issue identified by automated review of the INV-003 series at
https://sashiko.dev/

Fixes: 771138920eaf ("[media] rtl2832_sdr: Realtek RTL2832 SDR driver module")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -906,9 +906,12 @@ static int rtl2832_sdr_start_streaming(s
 		goto err;
 
 	mutex_unlock(&dev->v4l2_lock);
+
 	return 0;
 
 err:
+	rtl2832_sdr_free_urbs(dev);
+	rtl2832_sdr_free_stream_bufs(dev);
 	rtl2832_sdr_cleanup_queued_bufs(dev, VB2_BUF_STATE_QUEUED);
 	mutex_unlock(&dev->v4l2_lock);
 


