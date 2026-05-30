Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C364C223DC6;
	Sat, 30 May 2026 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163176; cv=none; b=Xgi9zqCzdaZYzRtumiCcYJyQWp9OhrN657wGL1azSR0veYz0h8rpTutlNYwifyXFpXqBQX5SGvkNALp6Rmb89dgtD6RG2qlMlPRiCxolpNKsnXUS6M1xgAUvxgiEIbxVukqLS/IXz+90IQ6xanVBUVTLN5KwLTNpzRgIXg1VoFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163176; c=relaxed/simple;
	bh=krFK53l77oo/a1ZxlOzR4TGfvCD58u3HrSliXOBUgMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKti9ul4J4krpsNybKopqdwpITqKXD5O+fmMuWZoJ8bdGk5n+05UDwsaYKZZnk9JzweVLIwMp62xjFIP4a9vEhvJ0Tku8Liuu5BuCBwvO1lAXbkOmJpOfUYdQMfdd/6q+TDCteU3t/MGj7YuL0dkhDkg6Zl1lLGfaKHfNN/pCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLR2FHZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLR2FHZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1379A1F00893;
	Sat, 30 May 2026 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163175;
	bh=PTISUM+ESGvFjLBRWrTmMIHQGQ2+PhIJ4TfcNa1I5TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLR2FHZnemC9Qup/66QMs1gBsPEpRbxrFy44dqrqSqf3uH4T8BfmmY44MHjRR4jn7
	 65sK2ae74l6VuSGjivRFtg3ESypGL/FWvK6gIxE++qDRKDs+OELy06Ed1+ipqiwknZ
	 hNdf9IqfM3hR+8FIyCTsiO15wd+NsVXxboroTk44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.15 179/776] tty: n_gsm: fix flow control handling in tx path
Date: Sat, 30 May 2026 17:58:13 +0200
Message-ID: <20260530160245.125617544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 59ff0680ecbfec742b1e0381e7cc46b41eb06647 upstream.

The current implementation constipates all transmission paths during flow
control except for flow control frames. However, these may not be located
at the beginning of the transmission queue of the control channel.
Ensure that flow control frames in the transmission queue for the control
channel are always handled even if constipated by skipping through other
messages.

Fixes: 0af021678d5d ("tty: n_gsm: fix deadlock and link starvation in outgoing data path")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220707113223.3685-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -897,7 +897,7 @@ static int gsm_data_kick(struct gsm_mux
 	/* Serialize control messages and control channel messages first */
 	list_for_each_entry_safe(msg, nmsg, &gsm->tx_ctrl_list, list) {
 		if (gsm->constipated && !gsm_is_flow_ctrl_msg(msg))
-			return -EAGAIN;
+			continue;
 		ret = gsm_send_packet(gsm, msg);
 		switch (ret) {
 		case -ENOSPC:


