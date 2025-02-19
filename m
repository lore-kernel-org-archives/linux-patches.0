Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896091C6FFC;
	Wed, 19 Feb 2025 09:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957410; cv=none; b=bo2s4L3irT/b0SwHBdQ1Dq7Y8aL7k/PQbCGiFVAXS/W1Sr0ImSLNyJIBE2j1GSVktHUUz5xhdJJnhD+YIxArUpMOemMfCOW2cN2ffFCiJ9DC8rt7UznFUnFvv4CRfnAnF8IUy7jF4PzAncpWFGRHOaYEoylg96+3Hob2Llgws+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957410; c=relaxed/simple;
	bh=azgihGF5YrntKsim4c9Cd4YdbCP05bgVMgIaIRSpYpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfM4VPKR7vzj89z8m8Hv7u0c8pFtLc4J18uaCN5dIVcIGvIK8WUMSLYET3lN2GO5zQ0UqS/107bczNQK4Ek7lUi/ZlxeIJ8dZ+Q8DwpAbyxmMsTNnfpZDyHmMkNBclL5GJt2PP3FkQ0PEAcDmAn+a7BbNyhkvQe8Xl3Jqa93jeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ckq5GEQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ckq5GEQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103D4C4CED1;
	Wed, 19 Feb 2025 09:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957410;
	bh=azgihGF5YrntKsim4c9Cd4YdbCP05bgVMgIaIRSpYpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ckq5GEQ+d77nf7du63dLDGKXnPKzjENHok+ftv9mFwOEGeGawWqXNBz6IvSBifuzx
	 SVQV17s1b8JM0UTQagC4XAJJHAJqPsPsqsZywf5+sBgtrHPayzj9mWIy8jfw+bZmNQ
	 VApbntXAqFkAVzWPc66Mfw4W+Om4XJPLr2WTtFlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.1 515/578] usb: cdc-acm: Fix handling of oversized fragments
Date: Wed, 19 Feb 2025 09:28:39 +0100
Message-ID: <20250219082713.239467799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


