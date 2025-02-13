Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C618826B08A;
	Thu, 13 Feb 2025 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459338; cv=none; b=SWWTZjAnet1/RInipBLDXFa/qNMo7gZTZouTQudZ4iEYhzYsCTTPZit6YMv8/LJjtLKw93N2FZDdAEA3xyt/tbliR7zt20CWH+KeBCvtkWcjnuX819l62xdzsHPL+Jgw35eMHHRIpu7MRXWRFbAJ7kf7K5lv5IHgtvpQlbbi10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459338; c=relaxed/simple;
	bh=XHko+KCOIdAt8FS2LB+QievrU/KqzLVMeI7rb6SAcoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oISwFpj6T06HLRapquYwyaiclIEVjwXMZDSzl/neB3W1Ihofgp3B5OpIGher/tCqnEWGse/eQQawAekYSIaxzqsvEBtx/a5jwNr0zmmYTTs4HGWPDMAwF4y03PoA9FLVTpU7NQOEPMWT8aw+WPl+GJuf5ZQe0yo0UL1TCl1BBqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aD7Jmf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aD7Jmf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CB3C4CED1;
	Thu, 13 Feb 2025 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459338;
	bh=XHko+KCOIdAt8FS2LB+QievrU/KqzLVMeI7rb6SAcoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aD7Jmf+TNa1Y+Knj0xefVL6qFe9iWWRS2AlW4frsQYH8N9/VBDUO65otkNeAa5Oo
	 H+ilI5ZLEpXbGJhcHTa5v1NfYFvBily8/Bx0rBiVZm2KY9S3xtbHymiD+2H8xMt0Pl
	 niTWoTwZj85VBYo/N/M28Dogsn4+UDoCBQvCLRBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 234/443] usbnet: ipheth: fix possible overflow in DPE length check
Date: Thu, 13 Feb 2025 15:26:39 +0100
Message-ID: <20250213142449.643241588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Foster Snowhill <forst@pen.gy>

commit c219427ed296f94bb4b91d08626776dc7719ee27 upstream.

Originally, it was possible for the DPE length check to overflow if
wDatagramIndex + wDatagramLength > U16_MAX. This could lead to an OoB
read.

Move the wDatagramIndex term to the other side of the inequality.

An existing condition ensures that wDatagramIndex < urb->actual_length.

Fixes: a2d274c62e44 ("usbnet: ipheth: add CDC NCM support")
Cc: stable@vger.kernel.org
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -243,8 +243,8 @@ static int ipheth_rcvbulk_callback_ncm(s
 	while (le16_to_cpu(dpe->wDatagramIndex) != 0 &&
 	       le16_to_cpu(dpe->wDatagramLength) != 0) {
 		if (le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
-		    le16_to_cpu(dpe->wDatagramIndex) +
-		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length) {
+		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length -
+		    le16_to_cpu(dpe->wDatagramIndex)) {
 			dev->net->stats.rx_length_errors++;
 			return retval;
 		}


