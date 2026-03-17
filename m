Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B3C3F54BE;
	Tue, 17 Mar 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766026; cv=none; b=TkdUST6LXKTX7tlwpxCyZJl95bmqjdNFpr8tsXmxt5ZIzRPCFxj81La/DstqSD3YaoCqHQeqfPTJbe2JXVJnWA+eZX1VUVkMkpRLno5a4ARYmNvgBACZ4KS9X5+Nlav5PQ9a/x1JiMLjSzO20PY9Snu5pxRYqaBIXiSo9rUQx9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766026; c=relaxed/simple;
	bh=DJ9triO5upS21goRgfJ2SRBnBtmxM7URLq/NrXbehXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEEKa+NxJRP49MA99rXthMo4WHFWSn0mvTDow7pOsRmnKs/aU/hpWXA1ojAz/jolhut+91CW633+0HVwYoMSqgPKgEZc4TFjlvU2mHMQllpYn/yJ+4IVhXOeVIPHO76WzrLh3hyKgYk3vMq8gdMtj7EujlDKMM6OwCSi9jB7AZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5xkWNgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5xkWNgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146B0C19424;
	Tue, 17 Mar 2026 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766026;
	bh=DJ9triO5upS21goRgfJ2SRBnBtmxM7URLq/NrXbehXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5xkWNglJuOfOWRX1A3+/aDef7nvZxpO3JhNBH8h4C8+gMn6jqrTkqgwQSSfRqNSi
	 eDnq+7QYBrWZhBiezMtOa8U/gMBCMbeyjsKQhG1Sr7Th4YqbxtWsDgC/ZKvb+qEd6n
	 LLHorB36ZoKJ9Z8LrlxEBJYhX/UXd8lBQaHiHOLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.19 154/378] usb: typec: altmode/displayport: set displayport signaling rate in configure message
Date: Tue, 17 Mar 2026 17:31:51 +0100
Message-ID: <20260317163012.678962911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


