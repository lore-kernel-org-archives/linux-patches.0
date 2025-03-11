Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2933025E836;
	Tue, 11 Mar 2025 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707052; cv=none; b=D8EsuqxAyXmAfFcOxD+yHvkinlNwIpplnQeQ9pLRnIHNqWQTTWz1gkAeGmJMHfx08ERdVGvUXhwjES6ghWvZQEr7+4Ja1Lq3vs5VmddY8MF+a8ODnV3rZJRgLebZXPC+wu8dyw2jULJWvDs7syNvVHDbynVbxsGSaP3+zohFjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707052; c=relaxed/simple;
	bh=8quFfHfUiH67ECWQKQeHxZm4mWBYyH+B/9z1ohMeruM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNi3QAH/pz8sqDPMimp9qpaZ/44/8FffZVRyhJFLXlcX3Twx83DNXMrGoZ4VCiUeCYI9KL153HJUGMqrq2xh89MiaTS9HZk2Lup20ImJHfVkpiUSnlzlD13ShB1Zt8gJR2ifMcGsPzRf/9OFBNcIFY3nk3WHwUFhk5q37gu9iYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoUli5OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoUli5OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA35FC4CEE9;
	Tue, 11 Mar 2025 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707052;
	bh=8quFfHfUiH67ECWQKQeHxZm4mWBYyH+B/9z1ohMeruM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoUli5OJ2hghE15ef0BeNd3b5uWK87ndHTT+rjRaVza/Jyt7iAJH7KFfKBJ9Iu+15
	 Ta4e0FzzGCTSfG1uMusNZ04EmflPWIq5BefTPIUhS3MbXd+55vvJU0w7DwQY2B862h
	 YrA8GEAgoFsHQQpu8P/FwqwWNPzHhlj3IiNTQ/QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.10 258/462] usb: cdc-acm: Fix handling of oversized fragments
Date: Tue, 11 Mar 2025 15:58:44 +0100
Message-ID: <20250311145808.554173709@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
@@ -405,7 +405,7 @@ static void acm_ctrl_irq(struct urb *urb
 	expected_size = sizeof(struct usb_cdc_notification) +
 					le16_to_cpu(dr->wLength);
 
-	if (current_size < expected_size) {
+	if (acm->nb_index != 0 || current_size < expected_size) {
 		/* notification is transmitted fragmented, reassemble */
 		if (acm->nb_size < expected_size) {
 			u8 *new_buffer;


