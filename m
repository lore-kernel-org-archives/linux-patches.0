Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795217A2E8;
	Mon, 10 Mar 2025 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629661; cv=none; b=TE0LMeP+GgnT0M1YW3m3DIDKghaSWh8KHIkfqv1nJNhQUp7q3zOrSR7eodSLruNcTBa87Bc5ODituPuLy8xJuFIAstFZ/6pElQlWHH4nZfCfiTyrs11iAUuUnGC4pnBnUknbJHcrui6i56pKrTopBAlsgLwIM07xCDCIRLyoXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629661; c=relaxed/simple;
	bh=FGRSV9RHzDscxiJE2y18u1iVSXdUVM4Z4/o67LxkpMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID5jVJzo68xO6G61x8BiIJI3/d3mrXZC0a2WHTVw0ZUG2MKJ9UJlULRpv4/qSEyXmCvW+LnE9EHN3iYdUf1sXWxmuC5fl97FQfisxQ3c5UMxhxwRPGthIRvKkBjlLKb+NuRIglJftXZYBHyJWMJ31dAui5avDCelg4ssXgcb+JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPClmaNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPClmaNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938AAC4CEE5;
	Mon, 10 Mar 2025 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629661;
	bh=FGRSV9RHzDscxiJE2y18u1iVSXdUVM4Z4/o67LxkpMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPClmaNeTx+l+nXpn6pKDg9eZcPZ3KIft+xRgytO7BasuhFVRc/9bj/6jyl4hkXwK
	 gtthLo8/aRgXRrKSth1kosT6qXWl22q5M9Gf+h53AkzzCocdy+Ty8xb+3g3Zi78vmC
	 QopRBgtduQyKHUR8sOaDI5yCPxchyK1SZ7Od26Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.15 371/620] usb: cdc-acm: Fix handling of oversized fragments
Date: Mon, 10 Mar 2025 18:03:37 +0100
Message-ID: <20250310170600.248129319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


