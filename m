Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A8326FD9B;
	Tue, 17 Mar 2026 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767695; cv=none; b=Ug5t33xNo79VawTl80jtxsogySccfcwRvF8dumTF9GhzCmjykgGfJF7VWWbmQPoUhsLMBgzEV63nGdXJR+qmjWaWAsWOjYF2Hazw8pWbCsJ1jTGO1fYGJUHB6SFebF8hGXt/tJT3XXWgLRo3YkQAYULTBsri1MP4mtW4qsfZd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767695; c=relaxed/simple;
	bh=2/0/njgYFQbUKzgPUAAqUU9sc6fPuND/SH8hx6MteZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHAW89ofw0b4Wftp4xgFHVFw9237+hbv8GYrUjqLLEjOkrFx3udPiL2c0RFFswj+7K/jI6KbjGac/VCVHOseyYz9t8c8O1j9hQjgjmYZSpcbsKvs99dyyB0nnSaZ7cubuX8XanYadGeiocMMuGGpSJQqPtQce0zJ5AXPceLdNrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCaBQ0y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCaBQ0y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA2BC4CEF7;
	Tue, 17 Mar 2026 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767694;
	bh=2/0/njgYFQbUKzgPUAAqUU9sc6fPuND/SH8hx6MteZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCaBQ0y7LB0uCcr194VnPBE5FuzVqr7aofN2eCiQkJSZEFPMh7ywVpBJYdWqs8PnU
	 sD39ub8GnChtGwgedJB/LGLpbW/oKjyvaCfGnFEJMhNtSigGHO/a/s5nkNDbnOIKe4
	 HVFGRS7YFZCsKlRnvo2QCFdNaIcjq1+ZLnoX+mxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 137/333] usb: typec: altmode/displayport: set displayport signaling rate in configure message
Date: Tue, 17 Mar 2026 17:32:46 +0100
Message-ID: <20260317163004.441549683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -100,9 +100,14 @@ static int dp_altmode_configure(struct d
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


