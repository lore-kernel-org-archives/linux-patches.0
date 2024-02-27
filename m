Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CD914532C;
	Tue, 27 Feb 2024 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044183; cv=none; b=t2VudSQ2m8yWk6XOCmDm/fLnbufUs7R1U5UW/hg6C2jYojAIAUOAGerk0WjHceXS4IpB7IcY/Iy5QFbG+pQbh8VBilZ+UqDAtgBx/E/d+Ac7qXj1BnDYa+3MP6CYbrr9u5fDjkhSIvHpqYosxB8H7ulpcuL0g9VWc3csZtYHfrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044183; c=relaxed/simple;
	bh=fwlKt6z4yHVzPk2nwPaGVKRzyNZbH0ENl+CaVrYnY1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+cO3gyCW0oiNzsSbOKmHApvn4H0ldVedI6nTn+Y/wucmNrA/DZ3rZ2V+YFHjzjv9vfI2iXnHMVy5orrHkwpHxPIu3znWBJW5MrMtT2c9uQmO7YZWyA/iNNmF9OmHqT+s2ifgoe9XUXSDoYq/E0HflQkoR9tbUMS+De5seXk/Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV/8OcXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV/8OcXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E57C433C7;
	Tue, 27 Feb 2024 14:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044183;
	bh=fwlKt6z4yHVzPk2nwPaGVKRzyNZbH0ENl+CaVrYnY1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kV/8OcXNdRm/a/A5tF6hEbU2MiQr8DKB5SwO1eoguBLibtvBbqhYVDX0+bizXdLW4
	 WDGFWo+zT4PFjkeR/nTDmsYzFLIYIDn2OO5/cC2mu+1tZaU2bobcx4IreWMEr9bx6e
	 R4+D+Ks+Ol15L8xWwtwVG44Z4wGm0nGG85aLHSCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH 5.10 092/122] usb: gadget: ncm: Avoid dropping datagrams of properly parsed NTBs
Date: Tue, 27 Feb 2024 14:27:33 +0100
Message-ID: <20240227131601.716253117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 76c51146820c5dac629f21deafab0a7039bc3ccd upstream.

It is observed sometimes when tethering is used over NCM with Windows 11
as host, at some instances, the gadget_giveback has one byte appended at
the end of a proper NTB. When the NTB is parsed, unwrap call looks for
any leftover bytes in SKB provided by u_ether and if there are any pending
bytes, it treats them as a separate NTB and parses it. But in case the
second NTB (as per unwrap call) is faulty/corrupt, all the datagrams that
were parsed properly in the first NTB and saved in rx_list are dropped.

Adding a few custom traces showed the following:
[002] d..1  7828.532866: dwc3_gadget_giveback: ep1out:
req 000000003868811a length 1025/16384 zsI ==> 0
[002] d..1  7828.532867: ncm_unwrap_ntb: K: ncm_unwrap_ntb toprocess: 1025
[002] d..1  7828.532867: ncm_unwrap_ntb: K: ncm_unwrap_ntb nth: 1751999342
[002] d..1  7828.532868: ncm_unwrap_ntb: K: ncm_unwrap_ntb seq: 0xce67
[002] d..1  7828.532868: ncm_unwrap_ntb: K: ncm_unwrap_ntb blk_len: 0x400
[002] d..1  7828.532868: ncm_unwrap_ntb: K: ncm_unwrap_ntb ndp_len: 0x10
[002] d..1  7828.532869: ncm_unwrap_ntb: K: Parsed NTB with 1 frames

In this case, the giveback is of 1025 bytes and block length is 1024.
The rest 1 byte (which is 0x00) won't be parsed resulting in drop of
all datagrams in rx_list.

Same is case with packets of size 2048:
[002] d..1  7828.557948: dwc3_gadget_giveback: ep1out:
req 0000000011dfd96e length 2049/16384 zsI ==> 0
[002] d..1  7828.557949: ncm_unwrap_ntb: K: ncm_unwrap_ntb nth: 1751999342
[002] d..1  7828.557950: ncm_unwrap_ntb: K: ncm_unwrap_ntb blk_len: 0x800

Lecroy shows one byte coming in extra confirming that the byte is coming
in from PC:

 Transfer 2959 - Bytes Transferred(1025)  Timestamp((18.524 843 590)
 - Transaction 8391 - Data(1025 bytes) Timestamp(18.524 843 590)
 --- Packet 4063861
       Data(1024 bytes)
       Duration(2.117us) Idle(14.700ns) Timestamp(18.524 843 590)
 --- Packet 4063863
       Data(1 byte)
       Duration(66.160ns) Time(282.000ns) Timestamp(18.524 845 722)

According to Windows driver, no ZLP is needed if wBlockLength is non-zero,
because the non-zero wBlockLength has already told the function side the
size of transfer to be expected. However, there are in-market NCM devices
that rely on ZLP as long as the wBlockLength is multiple of wMaxPacketSize.
To deal with such devices, it pads an extra 0 at end so the transfer is no
longer multiple of wMaxPacketSize.

Cc: <stable@vger.kernel.org>
Fixes: 9f6ce4240a2b ("usb: gadget: f_ncm.c added")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20240205074650.200304-1-quic_kriskura@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1349,7 +1349,15 @@ parse_ntb:
 	     "Parsed NTB with %d frames\n", dgram_counter);
 
 	to_process -= block_len;
-	if (to_process != 0) {
+
+	/*
+	 * Windows NCM driver avoids USB ZLPs by adding a 1-byte
+	 * zero pad as needed.
+	 */
+	if (to_process == 1 &&
+	    (*(unsigned char *)(ntb_ptr + block_len) == 0x00)) {
+		to_process--;
+	} else if (to_process > 0) {
 		ntb_ptr = (unsigned char *)(ntb_ptr + block_len);
 		goto parse_ntb;
 	}


