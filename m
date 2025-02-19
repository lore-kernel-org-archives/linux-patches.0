Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6301DF987;
	Wed, 19 Feb 2025 08:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955077; cv=none; b=p5wiholsj0ZwTpxPZlwuJY6lzwpyjBocby9c+aniv6VUvvr0MFhoXz4hHuyUfBwhE7JPTC47T2EVDAVIV0Z4jdJjOz9j/r7QDM82M40HCaO2g+jqHt2c37IzRb8GBzysw0AePhc1NXkpTSIRgTBEFZQU5pAU9IdBXZ0LAm4D1sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955077; c=relaxed/simple;
	bh=F545RWDLfU9HU3ZjvmNhQWlLV76ANNn5d8g2cTFquZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jp10h7/YRyzwMW1O9u5/zCyH4o5UgTB3wGvJchXPJyyts+3Ms4p7Fr6IPtX6/j0iJ+8TeNJdYOiCLREKk8JFZfpqUg7sbrrLB+5vAg/zLjVSQCkeSI3jmj2bt2deW1wJVj3uocMZguP8xfsP4JhQmtd5L2EkBI39HqX3t3L9KDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq74OyqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq74OyqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB09C4CED1;
	Wed, 19 Feb 2025 08:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955077;
	bh=F545RWDLfU9HU3ZjvmNhQWlLV76ANNn5d8g2cTFquZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fq74OyqMmwjFv60nU9eYvyP+e7HZ7zg1cTMXNiLq4/zJdcv3Q2IWP3R8wKrTOjsUj
	 BRAly+pl7Ni3mSXmczcvTqcApxu/CffrQ/Mh5vKWnM3+QcIdWjV3DdYMtrTCRN0GOE
	 AxsoKv1iO3F/aHHfkkT5OkjMeNI2XnBcH4yeq5lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.12 123/230] usb: cdc-acm: Fix handling of oversized fragments
Date: Wed, 19 Feb 2025 09:27:20 +0100
Message-ID: <20250219082606.498920079@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 12e712964f41d05ae034989892de445781c46730 upstream.

If we receive an initial fragment of size 8 bytes which specifies a wLength
of 1 byte (so the reassembled message is supposed to be 9 bytes long), and
we then receive a second fragment of size 9 bytes (which is not supposed to
happen), we currently wrongly bypass the fragment reassembly code but still
pass the pointer to the acm->notification_buffer to
acm_process_notification().

Make this less wrong by always going through fragment reassembly when we
expect more fragments.

Before this patch, receiving an overlong fragment could lead to `newctrl`
in acm_process_notification() being uninitialized data (instead of data
coming from the device).

Cc: stable <stable@kernel.org>
Fixes: ea2583529cd1 ("cdc-acm: reassemble fragmented notifications")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -416,7 +416,7 @@ static void acm_ctrl_irq(struct urb *urb
 	expected_size = sizeof(struct usb_cdc_notification) +
 					le16_to_cpu(dr->wLength);
 
-	if (current_size < expected_size) {
+	if (acm->nb_index != 0 || current_size < expected_size) {
 		/* notification is transmitted fragmented, reassemble */
 		if (acm->nb_size < expected_size) {
 			u8 *new_buffer;


