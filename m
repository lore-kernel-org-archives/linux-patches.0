Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F7B1DFF4;
	Mon,  1 Apr 2024 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991082; cv=none; b=Pc4meOJWa5RRPz8PvYEeB9S4wCC59eqKFGS5wqfii8jeZ13xuFaOPojmboYE2fYsELtJQDTpalGnHeDanpWo+Y4GbCh5jk2YVLzjl6u+AVZk/gMrpupACbl3iWBQY1MnE5hzYXLqst9pFiWc0KzX6IZ2sHpnRFZ1Ki+yp6K5808=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991082; c=relaxed/simple;
	bh=Kqu4uUeUuWsWRR2WNhJhOvQG01NPC6QMWoEeObhdIxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpG37kgRVJZcg5Ap1CiqDtRpFjkl21WyYKEpY3WQoPnp5ixgoNDv7TlLvvcj8oO6JE7Hg5+zbKzIk23ylCq6N5yoeTAxTAWU1LBb/ZKFXhVDZrQxyeR8BmiHIl96QflqkcdWIpUuvLA9Ud4+T0NiwAG7uBW068pmJgQR9SmdCgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwpfAnpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwpfAnpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D305CC433F1;
	Mon,  1 Apr 2024 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991082;
	bh=Kqu4uUeUuWsWRR2WNhJhOvQG01NPC6QMWoEeObhdIxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwpfAnpLnft2ZCBha7AEooQmZb70uk5U4YffJJAip+SPSkx66vVfIjmVvJRPswN8k
	 3uVuHcw+RaZ4v8QuhTNMGlVSvEJ4hnTAT0XrfcvhmLUawlsKLMBB/ljWqtpDgQviFy
	 e0qxvJ1pA64tPmFQlpybmaW0kK+pF91sFcUCJQ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 6.1 158/272] usb: gadget: ncm: Fix handling of zero block length packets
Date: Mon,  1 Apr 2024 17:45:48 +0200
Message-ID: <20240401152535.658632608@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1348,7 +1348,7 @@ parse_ntb:
 	if (to_process == 1 &&
 	    (*(unsigned char *)(ntb_ptr + block_len) == 0x00)) {
 		to_process--;
-	} else if (to_process > 0) {
+	} else if ((to_process > 0) && (block_len != 0)) {
 		ntb_ptr = (unsigned char *)(ntb_ptr + block_len);
 		goto parse_ntb;
 	}


