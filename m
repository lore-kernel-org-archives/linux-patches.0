Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247903451DE;
	Tue, 26 Aug 2025 11:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207875; cv=none; b=TixdHFX6UENeV3RQ6nQracwlnntgOUtrK+7d32GICLnvsDrvUlWc4nBOiQsfYB62/wyyc1momb57urGrw9MSAJjz4lvrlxrr0Yu6ZKH63KzJoodSHPSe3DqnoZ655axlpJgOVY5kan+UMI4FWGPpDZf/aXWY5R6vy+qcl0+4hS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207875; c=relaxed/simple;
	bh=9g7FODQvcbQaHmcsMS69z3l2e7bKxOUQfFK8Gf2ndls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJNP02IUil67zl7pT0z4z6wyHQfNsEs1y9oqC04dMKxJ0dKrzy67d4sD6WlY0DKLgiAbWZ2jW8qAp0A4DAmzvfYsr1mKImP2Cv/3f6fv9NzOiIRaY4J556VTt3U9Lc8rQVJYKJQGIsk2kyiAZfJlFv/c3ytAtV+082RrlThOawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IosT0W2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IosT0W2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D3C116B1;
	Tue, 26 Aug 2025 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207875;
	bh=9g7FODQvcbQaHmcsMS69z3l2e7bKxOUQfFK8Gf2ndls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IosT0W2txnMiPBxo8QE69h+QqMX27jVTl9HWSds7VJT5+SSsAmdbWbLlEMAnAcLCE
	 9tCIprlDnXouxs1FfjbatEIyWBACpnrfgiOk4yPz877MdZ1Bi9G/Y4AUalCD39nkmd
	 8k2pNxyC4XWtg4GLxES5eUftZmqNhTEoAgwQYpjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.16 320/457] usb: typec: maxim_contaminant: re-enable cc toggle if cc is open and port is clean
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826110945.262074207@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit a381c6d6f646226924809d0ad01a9465786da463 upstream.

Presently in `max_contaminant_is_contaminant()` if there's no
contaminant detected previously, CC is open & stopped toggling and no
contaminant is currently present, TCPC.RC would be programmed to do DRP
toggling. However, it didn't actively look for a connection. This would
lead to Type-C not detect *any* new connections. Hence, in the above
situation, re-enable toggling & program TCPC to look for a new
connection.

Also, return early if TCPC was looking for connection as this indicates
TCPC has neither detected a potential connection nor a change in
contaminant state.

In addition, once dry detection is complete (port is dry), restart
toggling.

Fixes: 02b332a06397e ("usb: typec: maxim_contaminant: Implement check_contaminant callback")
Cc: stable <stable@kernel.org>
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250815-fix-upstream-contaminant-v2-2-6c8d6c3adafb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/maxim_contaminant.c |   53 +++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/drivers/usb/typec/tcpm/maxim_contaminant.c
+++ b/drivers/usb/typec/tcpm/maxim_contaminant.c
@@ -329,6 +329,39 @@ static int max_contaminant_enable_dry_de
 	return 0;
 }
 
+static int max_contaminant_enable_toggling(struct max_tcpci_chip *chip)
+{
+	struct regmap *regmap = chip->data.regmap;
+	int ret;
+
+	/* Disable dry detection if enabled. */
+	ret = regmap_update_bits(regmap, TCPC_VENDOR_CC_CTRL2, CCLPMODESEL,
+				 FIELD_PREP(CCLPMODESEL,
+					    LOW_POWER_MODE_DISABLE));
+	if (ret)
+		return ret;
+
+	ret = regmap_update_bits(regmap, TCPC_VENDOR_CC_CTRL1, CCCONNDRY, 0);
+	if (ret)
+		return ret;
+
+	ret = max_tcpci_write8(chip, TCPC_ROLE_CTRL, TCPC_ROLE_CTRL_DRP |
+			       FIELD_PREP(TCPC_ROLE_CTRL_CC1,
+					  TCPC_ROLE_CTRL_CC_RD) |
+			       FIELD_PREP(TCPC_ROLE_CTRL_CC2,
+					  TCPC_ROLE_CTRL_CC_RD));
+	if (ret)
+		return ret;
+
+	ret = regmap_update_bits(regmap, TCPC_TCPC_CTRL,
+				 TCPC_TCPC_CTRL_EN_LK4CONN_ALRT,
+				 TCPC_TCPC_CTRL_EN_LK4CONN_ALRT);
+	if (ret)
+		return ret;
+
+	return max_tcpci_write8(chip, TCPC_COMMAND, TCPC_CMD_LOOK4CONNECTION);
+}
+
 bool max_contaminant_is_contaminant(struct max_tcpci_chip *chip, bool disconnect_while_debounce,
 				    bool *cc_handled)
 {
@@ -345,6 +378,12 @@ bool max_contaminant_is_contaminant(stru
 	if (ret < 0)
 		return false;
 
+	if (cc_status & TCPC_CC_STATUS_TOGGLING) {
+		if (chip->contaminant_state == DETECTED)
+			return true;
+		return false;
+	}
+
 	if (chip->contaminant_state == NOT_DETECTED || chip->contaminant_state == SINK) {
 		if (!disconnect_while_debounce)
 			msleep(100);
@@ -377,6 +416,12 @@ bool max_contaminant_is_contaminant(stru
 				max_contaminant_enable_dry_detection(chip);
 				return true;
 			}
+
+			ret = max_contaminant_enable_toggling(chip);
+			if (ret)
+				dev_err(chip->dev,
+					"Failed to enable toggling, ret=%d",
+					ret);
 		}
 	} else if (chip->contaminant_state == DETECTED) {
 		if (!(cc_status & TCPC_CC_STATUS_TOGGLING)) {
@@ -384,6 +429,14 @@ bool max_contaminant_is_contaminant(stru
 			if (chip->contaminant_state == DETECTED) {
 				max_contaminant_enable_dry_detection(chip);
 				return true;
+			} else {
+				ret = max_contaminant_enable_toggling(chip);
+				if (ret) {
+					dev_err(chip->dev,
+						"Failed to enable toggling, ret=%d",
+						ret);
+					return true;
+				}
 			}
 		}
 	}


