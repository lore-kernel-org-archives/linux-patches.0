Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C58834C83A;
	Wed,  3 Dec 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778364; cv=none; b=E628kjklJKDKJ62pX7Inc1c0GCNuPc9Dkvj9kRZFGYlssy0RFQLDPM0QqaTP0CKaUtbHqTAtBIfZCEp7r1c0XTc8zBGZnjR/lx+5NfV2khd2BHFCQ2Agot/wCmY94Aa5UvHY/LXn7cpcWFzrOA9KDesRo1RjzT3aWulWGoAvUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778364; c=relaxed/simple;
	bh=hoclxPDgydsNeHq40g4aJGdcjxSNh59wMkw+729IdvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8crG9YkvjFkz/gH3NbhW0nJsKFodnif8lOM7lSHDT5ANBCef/fK+dvVs4BVkj8j+lbEmNvI0Af3tJjCoD7U/nsPupFy0TexXFVpi293xuTgXAAwe9WELOtftUI9ZcLtDKEQuyVoW2v4oD2YGuXYrF9doiU39xYl0sPAFlBX5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkXea4YG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkXea4YG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DDAC4CEF5;
	Wed,  3 Dec 2025 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778364;
	bh=hoclxPDgydsNeHq40g4aJGdcjxSNh59wMkw+729IdvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkXea4YGmL/Xi09kBPgGXTy1Vn+LDMwY44Fxz+nE65sRFGPqfzFDu758K33yPadRj
	 W+B41Q3n1Ci5q3mVfFRYUJBh2Zfl9rLHw13YFhq2l10ClRnDwWfeFac5xd6kDIDzM3
	 e++3P8veP+aqrpQcriDsKN6bXab3pDitmgMkRx8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/392] usb: deprecate the third argument of usb_maxpacket()
Date: Wed,  3 Dec 2025 16:27:54 +0100
Message-ID: <20251203152426.085894160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 0f08c2e7458e25c967d844170f8ad1aac3b57a02 ]

This is a transitional patch with the ultimate goal of changing the
prototype of usb_maxpacket() from:
| static inline __u16
| usb_maxpacket(struct usb_device *udev, int pipe, int is_out)

into:
| static inline u16 usb_maxpacket(struct usb_device *udev, int pipe)

The third argument of usb_maxpacket(): is_out gets removed because it
can be derived from its second argument: pipe using
usb_pipeout(pipe). Furthermore, in the current version,
ubs_pipeout(pipe) is called regardless in order to sanitize the is_out
parameter.

In order to make a smooth change, we first deprecate the is_out
parameter by simply ignoring it (using a variadic function) and will
remove it later, once all the callers get updated.

The body of the function is reworked accordingly and is_out is
replaced by usb_pipeout(pipe). The WARN_ON() calls become unnecessary
and get removed.

Finally, the return type is changed from __u16 to u16 because this is
not a UAPI function.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20220317035514.6378-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 69aeb5073123 ("Input: pegasus-notetaker - fix potential out-of-bounds access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/usb.h |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1987,21 +1987,17 @@ usb_pipe_endpoint(struct usb_device *dev
 	return eps[usb_pipeendpoint(pipe)];
 }
 
-/*-------------------------------------------------------------------------*/
-
-static inline __u16
-usb_maxpacket(struct usb_device *udev, int pipe, int is_out)
+static inline u16 usb_maxpacket(struct usb_device *udev, int pipe,
+				/* int is_out deprecated */ ...)
 {
 	struct usb_host_endpoint	*ep;
 	unsigned			epnum = usb_pipeendpoint(pipe);
 
-	if (is_out) {
-		WARN_ON(usb_pipein(pipe));
+	if (usb_pipeout(pipe))
 		ep = udev->ep_out[epnum];
-	} else {
-		WARN_ON(usb_pipeout(pipe));
+	else
 		ep = udev->ep_in[epnum];
-	}
+
 	if (!ep)
 		return 0;
 
@@ -2009,8 +2005,6 @@ usb_maxpacket(struct usb_device *udev, i
 	return usb_endpoint_maxp(&ep->desc);
 }
 
-/* ----------------------------------------------------------------------- */
-
 /* translate USB error codes to codes user space understands */
 static inline int usb_translate_errors(int error_code)
 {


