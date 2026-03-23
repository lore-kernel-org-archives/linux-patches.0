Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46457175A80;
	Mon, 23 Mar 2026 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275459; cv=none; b=N9gEOeQVIZyef9q8d5kN2DnGIB9k1t2uU1fh0Pg+tcr/zuZLz0hoUhsk3u9ncbbR/dTaw7Ti/UXZXvLTnrCLiWbJZoxkUksvWLoKqvZ8YsH6F5yDsUvobQZtQj1hges2vHKSgid+SaQNQh7SInI15minluFdGS0vDw1cMul1Gc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275459; c=relaxed/simple;
	bh=fI3gq+UKo+oSXXc66iKBhWnAb4cNGfxsn+LXNO3bwKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2VltHlrRaOIX10FVF3hNA8IXS4JwTQjEvdY8Nes8KwKF17RgyemiMdIyiwTbwU7g/KahrHagvXSnnBzopXTsGMPdQGAkSVzNM8sW2fUzn8bmW4XayT13i3nrbU2QEQEXzqGxguOMF5NenfZNK/drP55jZESQtqhBA9LRRmLOVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzbr2Xrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzbr2Xrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4CBC4CEF7;
	Mon, 23 Mar 2026 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275459;
	bh=fI3gq+UKo+oSXXc66iKBhWnAb4cNGfxsn+LXNO3bwKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vzbr2Xrb0THIE5QCm8xxJiDON1Ack5FJhADVMr1ry1E3664wYv5hjxIGLVbe8NtnI
	 Ke3aM93MSiJk8YdjW4PRU5/+Yzw+ms3LMl58pmvvgavUmgCPZqbimyGyke2Sf5yaou
	 hWZ0W1D+KW/fBZYRNofCywGhZfQ3cv6NsWd6MWBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 109/460] usb: typec: altmode/displayport: set displayport signaling rate in configure message
Date: Mon, 23 Mar 2026 14:41:45 +0100
Message-ID: <20260323134529.319475261@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

commit e8557acfa079a54b59a21f447c82a31aec7717df upstream.

dp_altmode_configure sets the signaling rate to the current
configuration's rate and then shifts the value to the Select
Configuration bitfield. On the initial configuration, dp->data.conf
is 0 to begin with, so the signaling rate field is never set, which
leads to some DisplayPort Alt Mode partners sending NAK to the
Configure message.

Set the signaling rate to the capabilities supported by both the
port and the port partner. If the cable supports DisplayPort Alt Mode,
then include its capabilities as well.

Fixes: a17fae8fc38e ("usb: typec: Add Displayport Alternate Mode 2.1 Support")
Cc: stable <stable@kernel.org>
Signed-off-by: RD Babiera <rdbabiera@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260310204106.3939862-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -93,9 +93,14 @@ static int dp_altmode_configure(struct d
 {
 	u8 pin_assign = 0;
 	u32 conf;
+	u32 signal;
 
 	/* DP Signalling */
-	conf = (dp->data.conf & DP_CONF_SIGNALLING_MASK) >> DP_CONF_SIGNALLING_SHIFT;
+	signal = DP_CAP_DP_SIGNALLING(dp->port->vdo) & DP_CAP_DP_SIGNALLING(dp->alt->vdo);
+	if (dp->plug_prime)
+		signal &= DP_CAP_DP_SIGNALLING(dp->plug_prime->vdo);
+
+	conf = signal << DP_CONF_SIGNALLING_SHIFT;
 
 	switch (con) {
 	case DP_STATUS_CON_DISABLED:


