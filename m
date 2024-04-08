Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6291326AC7;
	Mon,  8 Apr 2024 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584892; cv=none; b=hgGkp0wGfkKdoPtb8TJfB5hwULfyPjApYpt/3Oa1RyZqFPJxpXdzrQzJZ1cQkmT8EVzDz8Y03UZhinQl2WcmiA0wHXESqb1OSVu0RYLM7IC74KPhiPTVGOMxl0lrzL9tUaUfvkRSHslrVqUZk5JxNTXurgmrN/hcnMjJzgUUcFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584892; c=relaxed/simple;
	bh=5X3/T6q8/PiyFnLHyBhNsdZj8ppJGjNazCEfdkGLQeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvLTDRyyIxogrXINFEwJLEdD/uC8A7lZSEOqle43bHqgVf244rLELtbCL8pE406723RbIUEo8/UpghKkdlTjNxeqN9Jgs9F2/ABZn9FJuKEknjStzp/3oXXmhET0m3WP1ja2dbd8/CjobdLIGrxrrQYMGTjkJ2nslTnzN3RfEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ue+Bryc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ue+Bryc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA2C433F1;
	Mon,  8 Apr 2024 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584891;
	bh=5X3/T6q8/PiyFnLHyBhNsdZj8ppJGjNazCEfdkGLQeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ue+BrycJRTgs6lJ4QnkjHZHKqhiGukY3uNB56ghRPPtcQ24eOmxi7sknw6ZzHM60
	 dk/VQ+R1lZd7bODVtSVCyVpd6pAk4MXsc2Nv9harqeRQSeyHdi/G/0RNsvQuyYtsTY
	 R1E2PNYNyb6oJIvXJXWj7hMeYmw7+R/uyiW+dlxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 593/690] usb: typec: ucsi: Clear UCSI_CCI_RESET_COMPLETE before reset
Date: Mon,  8 Apr 2024 14:57:39 +0200
Message-ID: <20240408125421.079485520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 3de4f996a0b5412aa451729008130a488f71563e upstream.

Check the UCSI_CCI_RESET_COMPLETE complete flag before starting
another reset. Use a UCSI_SET_NOTIFICATION_ENABLE command to clear
the flag if it is set.

Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240320073927.1641788-6-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -879,13 +879,47 @@ static int ucsi_reset_connector(struct u
 
 static int ucsi_reset_ppm(struct ucsi *ucsi)
 {
-	u64 command = UCSI_PPM_RESET;
+	u64 command;
 	unsigned long tmo;
 	u32 cci;
 	int ret;
 
 	mutex_lock(&ucsi->ppm_lock);
 
+	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * If UCSI_CCI_RESET_COMPLETE is already set we must clear
+	 * the flag before we start another reset. Send a
+	 * UCSI_SET_NOTIFICATION_ENABLE command to achieve this.
+	 * Ignore a timeout and try the reset anyway if this fails.
+	 */
+	if (cci & UCSI_CCI_RESET_COMPLETE) {
+		command = UCSI_SET_NOTIFICATION_ENABLE;
+		ret = ucsi->ops->async_write(ucsi, UCSI_CONTROL, &command,
+					     sizeof(command));
+		if (ret < 0)
+			goto out;
+
+		tmo = jiffies + msecs_to_jiffies(UCSI_TIMEOUT_MS);
+		do {
+			ret = ucsi->ops->read(ucsi, UCSI_CCI,
+					      &cci, sizeof(cci));
+			if (ret < 0)
+				goto out;
+			if (cci & UCSI_CCI_COMMAND_COMPLETE)
+				break;
+			if (time_is_before_jiffies(tmo))
+				break;
+			msleep(20);
+		} while (1);
+
+		WARN_ON(cci & UCSI_CCI_RESET_COMPLETE);
+	}
+
+	command = UCSI_PPM_RESET;
 	ret = ucsi->ops->async_write(ucsi, UCSI_CONTROL, &command,
 				     sizeof(command));
 	if (ret < 0)


