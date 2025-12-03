Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE903074BA;
	Wed,  3 Dec 2025 15:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776671; cv=none; b=LLL+/5Gc2GxUj8eG6DM9UxFqraSIINaS48bXGL4bailM41ZmHMlX7HXM/6ftYULfAnIfeBuwR/G6KvG/zBIerKfaZOLPzzYWOnVKM09Sb9E4CO5K0TMLwIcK7VejRIWDXRKfU8i7rcfTBIqGNJkzcXBJ5VcLLKf1qeO7YTxN/ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776671; c=relaxed/simple;
	bh=1q21mOeBl/zzrBc07A8/xwjpRuBizfiStdz2jqBlc3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/AzkRzaSScfVk0tsvNci2ejBN4Y7zw1VDQSfgeZuWUO0Z1WFFCd6JRC/6GxJC2xuxzEEpYHGcT7b79Bp9FeJ/assUhJ9vRO3zZzIvVbtty9Lf2qdEf9LCIGLsqUqDbY+QGtcATaw5R2o99Snho/CSwrzIDdMRyJn7PotRb/Mag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iF8dkv5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iF8dkv5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72018C4CEF5;
	Wed,  3 Dec 2025 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776670;
	bh=1q21mOeBl/zzrBc07A8/xwjpRuBizfiStdz2jqBlc3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iF8dkv5c9EKTBk8hUXm6IOg6s/Csw0MVH7jHKJJ9/uGBy62EvL3J9LtD+U48JWfPQ
	 j/r4T0JgRgUjZ+iVs4Mgb6eLpC26RZEu80ORSwTagY+F2WpOQeoglVzsvU0+CD3EEp
	 hIGfiRvC9myM8+PlWbO2w2XoqNA7S0MQyT30eQCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/300] usb: deprecate the third argument of usb_maxpacket()
Date: Wed,  3 Dec 2025 16:27:37 +0100
Message-ID: <20251203152410.010884123@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1980,21 +1980,17 @@ usb_pipe_endpoint(struct usb_device *dev
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
 
@@ -2002,8 +1998,6 @@ usb_maxpacket(struct usb_device *udev, i
 	return usb_endpoint_maxp(&ep->desc);
 }
 
-/* ----------------------------------------------------------------------- */
-
 /* translate USB error codes to codes user space understands */
 static inline int usb_translate_errors(int error_code)
 {


