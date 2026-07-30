Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7796D2C0F93;
	Thu, 30 Jul 2026 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423745; cv=none; b=cSwy8mKG53Vjm8m+2rv77188UydMzRvzb2o8JAWKbTD6dXwJA/PlOjfv9eeMoG4bZMWyUaAFS0BWn5XANdGwbHEoJ507ydt3Jgprx6bDvAUf2y/T18kFt6uHJ2rE1zpsH4VgZYYD/ZwzY2fOBSdBhLFeO9TK8RVSBQs3hYAsi7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423745; c=relaxed/simple;
	bh=f89uQlja+nvyAytAHRy4aDZIe0gxLPVC8OJSu2FK6L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw8FskcjkGKmmKYcobUUO3sP2qa/mtpkYslha0DzSYooto5v2uTtLVS/sDgybfgCrKZYSYIB/BNHjVte/54+SntE7YA8JwZmJkxZmXHEUHZg6L72HBQ5blRhSOPXjmh14pKCA8Je4vhlUxr/NbxGzAKJ09WLAuZmTpmYAcqu6Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqGzYZ/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqGzYZ/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90911F000E9;
	Thu, 30 Jul 2026 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423744;
	bh=nlmSXp5HH4ephevNCfrXNj/qRD9jzDLIM+CwyeWLeoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqGzYZ/HCGHJaN1TswqtpXsP5d47jkgZ3YSOfw/U/CYpQ2SO4Zj9nXw9GE3E9ys4F
	 2ZU9a9v+d1rhMKfgVY+fOJ8X+rurOtPVBFqQx78wxy0cK33Ar32MBsoD49Swn0kApq
	 RAY+3eO8j/53HhavQlT1WFqc3BKm/aEo5BT9BEhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.18 151/675] usb: gadget: f_ncm: validate datagram bounds in ncm_unwrap_ntb()
Date: Thu, 30 Jul 2026 16:08:01 +0200
Message-ID: <20260730141448.347674066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Sonali Pradhan <sonalipradhan@google.com>

commit 1febec7e47cdcd01f43fb0211094e3010474666e upstream.

When unpacking host-supplied NTBs, ncm_unwrap_ntb() checks datagram length
against frame_max but does not verify that the datagram fits within the
declared block length. Additionally, when decoding multiple NTBs from a
single socket buffer, subsequent block lengths are not checked against the
actual remaining buffer data.

With these checks missing, a malicious USB host can specify datagram
offsets and lengths that point beyond the block, or supply secondary NTB
headers declaring lengths larger than the buffer. skb_put_data() then
copies adjacent kernel memory from skb_shared_info into the network skb.

Fix this by verifying that sufficient buffer space remains for the NTB
header before parsing, handling zero-length block declarations, ensuring
that block lengths never exceed the remaining buffer space, and verifying
that each datagram payload stays strictly within the block boundary.

Fixes: 427694cfaafa ("usb: gadget: ncm: Handle decoding of multiple NTB's in unwrap call")
Fixes: 2b74b0a04d3e ("USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()")
Cc: stable <stable@kernel.org>
Assisted-by: Jetski:Gemini-2.5-Pro
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260703083725.1903850-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1189,6 +1189,10 @@ static int ncm_unwrap_ntb(struct gether
 	frame_max = ncm_opts->max_segment_size;
 
 parse_ntb:
+	if (to_process < (int)opts->nth_size) {
+		INFO(port->func.config->cdev, "Packet too small for headers\n");
+		goto err;
+	}
 	tmp = (__le16 *)ntb_ptr;
 
 	/* dwSignature */
@@ -1209,8 +1213,12 @@ parse_ntb:
 	tmp++; /* skip wSequence */
 
 	block_len = get_ncm(&tmp, opts->block_length);
+	if (block_len == 0)
+		block_len = to_process;
+
 	/* (d)wBlockLength */
-	if ((block_len < opts->nth_size + opts->ndp_size) || (block_len > ntb_max)) {
+	if ((block_len < opts->nth_size + opts->ndp_size) || (block_len > ntb_max) ||
+			(block_len > to_process)) {
 		INFO(port->func.config->cdev, "Bad block length: %#X\n", block_len);
 		goto err;
 	}
@@ -1273,7 +1281,7 @@ parse_ntb:
 			index = index2;
 			/* wDatagramIndex[0] */
 			if ((index < opts->nth_size) ||
-					(index > block_len - opts->dpe_size)) {
+					(index > block_len)) {
 				INFO(port->func.config->cdev,
 				     "Bad index: %#X\n", index);
 				goto err;
@@ -1285,7 +1293,8 @@ parse_ntb:
 			 * ethernet hdr + crc or larger than max frame size
 			 */
 			if ((dg_len < 14 + crc_len) ||
-					(dg_len > frame_max)) {
+					(dg_len > frame_max) ||
+					(dg_len > block_len - index)) {
 				INFO(port->func.config->cdev,
 				     "Bad dgram length: %#X\n", dg_len);
 				goto err;
@@ -1310,7 +1319,7 @@ parse_ntb:
 			dg_len2 = get_ncm(&tmp, opts->dgram_item_len);
 
 			/* wDatagramIndex[1] */
-			if (index2 > block_len - opts->dpe_size) {
+			if (index2 > block_len) {
 				INFO(port->func.config->cdev,
 				     "Bad index: %#X\n", index2);
 				goto err;


