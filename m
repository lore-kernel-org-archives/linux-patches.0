Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF6E1547F3;
	Mon, 14 Oct 2024 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916156; cv=none; b=CFtbGlu3UcCaFiZgtWUYT3eeS4Ly31Dzg4PNVuzvxYChWm1zHAKaNsv6wsYJSu9iJR+BYWkII9vXYrcK8mRDZlEezIFzt7wkHJa1OUzWjzit8jaHdnQieHhUChYi8Ub/IwXsI29KK+U0sGWHpBBoGK/h+l258gDdjIQeTknfeTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916156; c=relaxed/simple;
	bh=VulfSATv7IOfWM8yPIsyk/rglBh7UxbcghQg3eKztPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pClu1LdoYApX3/8Z2X2nmfTPveW3REMV+wB7yWQNnQQuyVVnBZOc+BAxbs6v4gI9KP71/+UjYJseiudxKLmZ+TfEqqychZ3tBRO3IildP6miqywwGnUJJW2hnefIEa7O0iorFDnuY32Dqb8ANuAur6AFJ7pBrtHLW8O0n+i3WFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnFHggh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnFHggh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430A0C4CEC3;
	Mon, 14 Oct 2024 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916155;
	bh=VulfSATv7IOfWM8yPIsyk/rglBh7UxbcghQg3eKztPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnFHggh7EWVNSVRo65S5RrFBXOCRXwK7zCQTcquDEru283fgfcFPrGfQBebd66xFZ
	 8LrbWrqAhshhTTlHX4XKz3ucLIinzLYk1Wb/m9dZ4F4dXhUyv+RmOUlUkmDFARNtIy
	 hkaU04OSij/nrAxYCuFO0G9leyJQAnAwdpOOiid0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 101/214] net: pse-pd: Fix enabled status mismatch
Date: Mon, 14 Oct 2024 16:19:24 +0200
Message-ID: <20241014141048.936623074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit dda3529d2e84e2ee7b97158c9cdf5e10308f37bc ]

PSE controllers like the TPS23881 can forcefully turn off their
configuration state. In such cases, the is_enabled() and get_status()
callbacks will report the PSE as disabled, while admin_state_enabled
will show it as enabled. This mismatch can lead the user to attempt
to enable it, but no action is taken as admin_state_enabled remains set.

The solution is to disable the PSE before enabling it, ensuring the
actual status matches admin_state_enabled.

Fixes: d83e13761d5b ("net: pse-pd: Use regulator framework within PSE framework")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241002121706.246143-1-kory.maincent@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/pse_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
index 4f032b16a8a0a..f8e6854781e6e 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -785,6 +785,17 @@ static int pse_ethtool_c33_set_config(struct pse_control *psec,
 	 */
 	switch (config->c33_admin_control) {
 	case ETHTOOL_C33_PSE_ADMIN_STATE_ENABLED:
+		/* We could have mismatch between admin_state_enabled and
+		 * state reported by regulator_is_enabled. This can occur when
+		 * the PI is forcibly turn off by the controller. Call
+		 * regulator_disable on that case to fix the counters state.
+		 */
+		if (psec->pcdev->pi[psec->id].admin_state_enabled &&
+		    !regulator_is_enabled(psec->ps)) {
+			err = regulator_disable(psec->ps);
+			if (err)
+				break;
+		}
 		if (!psec->pcdev->pi[psec->id].admin_state_enabled)
 			err = regulator_enable(psec->ps);
 		break;
-- 
2.43.0



