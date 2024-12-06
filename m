Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1538E20A5E5;
	Fri,  6 Dec 2024 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498036; cv=none; b=EbdrQfIBLvP3CjBIXJbKcWL2SneNMsXQfECNdELbtmNMKJzXQiTUCmiq1KXI7IQdpb0cL1fWLyud//5ixVe39PplcFqtd4gzd/5R/m8hxcF7z+MbjejLZjz9IvV5vCAsUUqb0CbtHZ1kdJOK/0+pv6IY1BAApUUdgeqRvIQMf9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498036; c=relaxed/simple;
	bh=U2uisAJ524ojFtUG7gHl4u9ymNX2XeNCkm6F5s2JPeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXTG2bS3m6fRpfPiuP1NUl+R57AhFXGLDLHnLd8rhxO0uAX8q/hsItCXdp4kvC2kaJyhdkkDlMlYQgmkuF1ONxukv5Y9TruDwJ5GK3dRMTP7FD9F1g1dl29rIBdIUFeHLGcQgGWKiVJ6wLXkBI7lhuxND7W4G6C3gnM56e8fRrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnSBCgdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnSBCgdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71534C4CED1;
	Fri,  6 Dec 2024 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498035;
	bh=U2uisAJ524ojFtUG7gHl4u9ymNX2XeNCkm6F5s2JPeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnSBCgddThZeR8x1wNYF2Qan2Wr/skK1xzUd9VrYfE8tETDhIUjbNMUxrU71TE1i5
	 UmS7U90+99V2O3wu5vMDr6RfQ/yhYyhL+jb7a0T7mmIvdXWj2XVaASGFX9/ukUwO4v
	 TRm7a2v6iVtLG1uWWSpiF1JBr6SnNtSvD03cjLdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 450/676] ALSA: usb-audio: Fix out of bounds reads when finding clock sources
Date: Fri,  6 Dec 2024 15:34:29 +0100
Message-ID: <20241206143710.944679737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a3dd4d63eeb452cfb064a13862fb376ab108f6a6 upstream.

The current USB-audio driver code doesn't check bLength of each
descriptor at traversing for clock descriptors.  That is, when a
device provides a bogus descriptor with a shorter bLength, the driver
might hit out-of-bounds reads.

For addressing it, this patch adds sanity checks to the validator
functions for the clock descriptor traversal.  When the descriptor
length is shorter than expected, it's skipped in the loop.

For the clock source and clock multiplier descriptors, we can just
check bLength against the sizeof() of each descriptor type.
OTOH, the clock selector descriptor of UAC2 and UAC3 has an array
of bNrInPins elements and two more fields at its tail, hence those
have to be checked in addition to the sizeof() check.

Reported-by: Benoît Sevens <bsevens@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/20241121140613.3651-1-bsevens@google.com
Link: https://patch.msgid.link/20241125144629.20757-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/clock.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -36,6 +36,12 @@ union uac23_clock_multiplier_desc {
 	struct uac_clock_multiplier_descriptor v3;
 };
 
+/* check whether the descriptor bLength has the minimal length */
+#define DESC_LENGTH_CHECK(p, proto) \
+	((proto) == UAC_VERSION_3 ? \
+	 ((p)->v3.bLength >= sizeof((p)->v3)) :	\
+	 ((p)->v2.bLength >= sizeof((p)->v2)))
+
 #define GET_VAL(p, proto, field) \
 	((proto) == UAC_VERSION_3 ? (p)->v3.field : (p)->v2.field)
 
@@ -58,6 +64,8 @@ static bool validate_clock_source(void *
 {
 	union uac23_clock_source_desc *cs = p;
 
+	if (!DESC_LENGTH_CHECK(cs, proto))
+		return false;
 	return GET_VAL(cs, proto, bClockID) == id;
 }
 
@@ -65,13 +73,27 @@ static bool validate_clock_selector(void
 {
 	union uac23_clock_selector_desc *cs = p;
 
-	return GET_VAL(cs, proto, bClockID) == id;
+	if (!DESC_LENGTH_CHECK(cs, proto))
+		return false;
+	if (GET_VAL(cs, proto, bClockID) != id)
+		return false;
+	/* additional length check for baCSourceID array (in bNrInPins size)
+	 * and two more fields (which sizes depend on the protocol)
+	 */
+	if (proto == UAC_VERSION_3)
+		return cs->v3.bLength >= sizeof(cs->v3) + cs->v3.bNrInPins +
+			4 /* bmControls */ + 2 /* wCSelectorDescrStr */;
+	else
+		return cs->v2.bLength >= sizeof(cs->v2) + cs->v2.bNrInPins +
+			1 /* bmControls */ + 1 /* iClockSelector */;
 }
 
 static bool validate_clock_multiplier(void *p, int id, int proto)
 {
 	union uac23_clock_multiplier_desc *cs = p;
 
+	if (!DESC_LENGTH_CHECK(cs, proto))
+		return false;
 	return GET_VAL(cs, proto, bClockID) == id;
 }
 


