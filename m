Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6417B7D3F6;
	Mon,  8 Apr 2024 13:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582267; cv=none; b=idzdwA1gLr2QH9a8IzwMQuGmeVkeZPl2Zpq69OM6lNKjfEH9k9E+mdZI2dWjQoRgVuQ8e9aAETJHgIvKCjjq7JwKHKDaMStXiiGeHO9EaSr6yxSwY5+bDX2dGfPUCxaGFV13S/kl2Dyvvcfxf2Rkb87gSynqvoODGw8Qb91mOZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582267; c=relaxed/simple;
	bh=y5ZGkUKE6a7x+WcoYi7XyxGPfnXIwuIn8lTH8mGR798=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5A9mUUA1KYiQ6vIByMIsYIRRcZ+DLR1tdtYd51ggwJOkaXYq6525aahdseaSko+dOqSpofRvZbV86rgMml1Hppk8KdcPf/pv1LTFxF3U2Pzb2rZxPuBoCoP+oAf2ueaGBOPLTlT3Xq28hG/arZZ3mBSnYhuWVZUa3SAmvpnlr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IejM+3w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IejM+3w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0220C433C7;
	Mon,  8 Apr 2024 13:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582267;
	bh=y5ZGkUKE6a7x+WcoYi7XyxGPfnXIwuIn8lTH8mGR798=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IejM+3w1BZI22jOdleTG4EJqSb0UMo/qqkuRja8UasjtzzV/RjR11PgwY87zmmArc
	 Hu724Z7bPA9flNQK1D36LnyqBZmDP2cT31Mkr3kVw3YSicUmIprg0tSjLUYimceQJt
	 a04xrDztPMqLBicWIbxMq+OrpnwEEBebdeFv5mro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 5.15 128/690] usb: gadget: ncm: Fix handling of zero block length packets
Date: Mon,  8 Apr 2024 14:49:54 +0200
Message-ID: <20240408125404.179206857@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit f90ce1e04cbcc76639d6cba0fdbd820cd80b3c70 upstream.

While connecting to a Linux host with CDC_NCM_NTB_DEF_SIZE_TX
set to 65536, it has been observed that we receive short packets,
which come at interval of 5-10 seconds sometimes and have block
length zero but still contain 1-2 valid datagrams present.

According to the NCM spec:

"If wBlockLength = 0x0000, the block is terminated by a
short packet. In this case, the USB transfer must still
be shorter than dwNtbInMaxSize or dwNtbOutMaxSize. If
exactly dwNtbInMaxSize or dwNtbOutMaxSize bytes are sent,
and the size is a multiple of wMaxPacketSize for the
given pipe, then no ZLP shall be sent.

wBlockLength= 0x0000 must be used with extreme care, because
of the possibility that the host and device may get out of
sync, and because of test issues.

wBlockLength = 0x0000 allows the sender to reduce latency by
starting to send a very large NTB, and then shortening it when
the sender discovers that there’s not sufficient data to justify
sending a large NTB"

However, there is a potential issue with the current implementation,
as it checks for the occurrence of multiple NTBs in a single
giveback by verifying if the leftover bytes to be processed is zero
or not. If the block length reads zero, we would process the same
NTB infintely because the leftover bytes is never zero and it leads
to a crash. Fix this by bailing out if block length reads zero.

Cc: stable@vger.kernel.org
Fixes: 427694cfaafa ("usb: gadget: ncm: Handle decoding of multiple NTB's in unwrap call")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20240228115441.2105585-1-quic_kriskura@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1352,7 +1352,7 @@ parse_ntb:
 	if (to_process == 1 &&
 	    (*(unsigned char *)(ntb_ptr + block_len) == 0x00)) {
 		to_process--;
-	} else if (to_process > 0) {
+	} else if ((to_process > 0) && (block_len != 0)) {
 		ntb_ptr = (unsigned char *)(ntb_ptr + block_len);
 		goto parse_ntb;
 	}


