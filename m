Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E0826B098;
	Thu, 13 Feb 2025 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460639; cv=none; b=PxYt+xODc6xuJ03L9lFi+mPZp5Uoueu8QWPpddchL9oseqUcOwd4iIzrWsgVSKZcl7AtMCLtgfwvRodjf0+YTmgSygffuu5QnrPedJWOfrrGY6vV7Z5avf4a3fxeR7UlJjIXAWZIaVuJc5ZHaqAM8NDJC55SbaidJVfcsrfInYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460639; c=relaxed/simple;
	bh=otYxkzWB37ChRxUMWkdw14I+0ZZZWgkAW1WwBlEuLFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uX9rFGM/dOs4kSBNWHyLRyFqKsTK2qmI53tgtcCglYup9BShACmYFJj621pgcYbzAxxG/KV0Ck/nm6rckwjUZ8trvzxOi+j/v0UzACTCDVUqta5bOjDjPEufBFCrR46IkSAWe5djAaQX9Df64Qujo2UoE7iXcaq/0aN8I0XKFfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwlFdg1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwlFdg1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8234C4CED1;
	Thu, 13 Feb 2025 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460639;
	bh=otYxkzWB37ChRxUMWkdw14I+0ZZZWgkAW1WwBlEuLFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwlFdg1SJmVqKW2zAvTf4Ni2wQSloTSlkXZeCUMxmW/m96P7pxqxJgSDhY9fwsiC6
	 U2gbNSzJZGZR9aiP3Rhjy4glr/iH7dOEcQRhgLaV5YhJjk9tsjrZ40gpKXb0FHrLUx
	 hxfcQtuZ3bwvnJVFc8Tinfwy/1Wygb+39zoaCwR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 138/273] usbnet: ipheth: check that DPE points past NCM header
Date: Thu, 13 Feb 2025 15:28:30 +0100
Message-ID: <20250213142412.792124141@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Foster Snowhill <forst@pen.gy>

commit 429fa68b58cefb9aa9de27e4089637298b46b757 upstream.

By definition, a DPE points at the start of a network frame/datagram.
Thus it makes no sense for it to point at anything that's part of the
NCM header. It is not a security issue, but merely an indication of
a malformed DPE.

Enforce that all DPEs point at the data portion of the URB, past the
NCM header.

Fixes: a2d274c62e44 ("usbnet: ipheth: add CDC NCM support")
Cc: stable@vger.kernel.org
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -241,7 +241,8 @@ static int ipheth_rcvbulk_callback_ncm(s
 	dpe = ncm0->dpe16;
 	while (le16_to_cpu(dpe->wDatagramIndex) != 0 &&
 	       le16_to_cpu(dpe->wDatagramLength) != 0) {
-		if (le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
+		if (le16_to_cpu(dpe->wDatagramIndex) < IPHETH_NCM_HEADER_SIZE ||
+		    le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
 		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length -
 		    le16_to_cpu(dpe->wDatagramIndex)) {
 			dev->net->stats.rx_length_errors++;


