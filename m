Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1344F391A;
	Thu, 17 Sep 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660761; cv=none; b=RDxs/YcKib/xt1/j54nyYkwDc++k4hU/NyG6gdo9zMNaRZ3QeL7m4apMajequS6qxML6q6zrkukQafHnhPdglznFlm7QYbghPW7fb88zcK8IP37XjSzVFp9eDOBaI1mYNqdwMGqTx/AIKeKcQOmptCtgZv2V8onKJ8r/Q8rAokQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660761; c=relaxed/simple;
	bh=pkTaVW03EVK6H/nz+fHLJuW4a6ha5qAjUgKdTarYYTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1u95buVLdVkuMBMu+DNuTmov+qT1jJd1lrS5SIWtoHyT8PQRCCYpxFeUhOH3vTvb2qUBMWCPEKjTuRr2TXq4dv5G6mTVJ0Z/wClA/IWn9nMdPdWlnm8lvUWqOodncfj/AMQ8sovcaCbJJwnBaEHZRX9wOztHpvJKqqvNfp2eJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBAfoYYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBAfoYYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBB61F000FF;
	Thu, 17 Sep 2026 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660759;
	bh=wYPaTQnfc+JFnzIghcfZBNfzGdlHoN833b5CcjEoIz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBAfoYYPdUWs+ZttNG9AA973fnWyN87LijG/DHkER8DbJa7JAhOvPfSvUUUx8T+rn
	 Fv85sPBJGuO+kfS+v5EYSqlOccz89i6ITF7hJq7zR5Og9X8l101SX3kbrd+l3P+1WG
	 06TyPTL2LMhObEGw60dFy4Wj3p7vHenGNY/pQNAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Arie Miller <renari@arimil.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 698/733] hwmon: (asus_rog_ryujin) Synchronize HID command and report handling
Date: Thu, 17 Sep 2026 16:16:46 +0100
Message-ID: <20260917151410.237162536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arie Miller <renari@arimil.com>

[ Upstream commit 06d48355bf41028c1321acda6a4391cd70098be8 ]

rog_ryujin_execute_cmd() holds status_report_request_lock while
reinitializing a completion, intending to exclude raw-event handling.
However, rog_ryujin_raw_event() does not acquire the lock when it updates
the completion. A response can therefore race with reinit_completion() and
be lost, leaving the command to time out.

Hold the lock while parsing reports and updating their completions. Use the
irqsave variants in both paths because raw-event handling may run in
interrupt context.

Fixes: ed3e03790c5c ("hwmon: Add driver for ASUS ROG RYUJIN II 360 AIO cooler")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hwmon/20260812104617.858D01F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol sparse
Signed-off-by: Arie Miller <renari@arimil.com>
Link: https://patch.msgid.link/20260904022129.97896-3-renari@arimil.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/asus_rog_ryujin.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/hwmon/asus_rog_ryujin.c
+++ b/drivers/hwmon/asus_rog_ryujin.c
@@ -173,6 +173,7 @@ static int rog_ryujin_write_expanded(str
 static int rog_ryujin_execute_cmd(struct rog_ryujin_data *priv, const u8 *cmd, int cmd_length,
 				  struct completion *status_completion)
 {
+	unsigned long flags;
 	int ret;
 
 	/*
@@ -180,9 +181,9 @@ static int rog_ryujin_execute_cmd(struct
 	 * completion. Reinit is done because hidraw could have triggered
 	 * the raw event parsing and marked the passed in completion as done.
 	 */
-	spin_lock_bh(&priv->status_report_request_lock);
+	spin_lock_irqsave(&priv->status_report_request_lock, flags);
 	reinit_completion(status_completion);
-	spin_unlock_bh(&priv->status_report_request_lock);
+	spin_unlock_irqrestore(&priv->status_report_request_lock, flags);
 
 	/* Send command for getting data */
 	ret = rog_ryujin_write_expanded(priv, cmd, cmd_length);
@@ -410,15 +411,18 @@ static int rog_ryujin_raw_event(struct h
 				int size)
 {
 	struct rog_ryujin_data *priv = hid_get_drvdata(hdev);
+	unsigned long flags;
 
 	if (size < 2 || data[0] != RYUJIN_CMD_PREFIX)
 		return 0;
 
+	spin_lock_irqsave(&priv->status_report_request_lock, flags);
+
 	if (data[1] == RYUJIN_GET_COOLER_STATUS_CMD_RESPONSE) {
 		if (size <= priv->info->temp_offset + 1 ||
 		    size <= priv->info->pump_speed_offset + 1 ||
 		    size <= priv->info->fan_speed_offset + 1)
-			return 0;
+			goto unlock;
 
 		/* Received coolant temp and speeds of pump and internal fan */
 		priv->temp_input[0] = data[priv->info->temp_offset] * 1000 +
@@ -432,7 +436,7 @@ static int rog_ryujin_raw_event(struct h
 			complete_all(&priv->cooler_status_received);
 	} else if (data[1] == RYUJIN_GET_CONTROLLER_SPEED_CMD_RESPONSE) {
 		if (size <= RYUJIN_CONTROLLER_SPEED_3 + 1)
-			return 0;
+			goto unlock;
 
 		/* Received speeds of four fans attached to the controller */
 		priv->speed_input[2] = get_unaligned_le16(data + RYUJIN_CONTROLLER_SPEED_1);
@@ -444,7 +448,7 @@ static int rog_ryujin_raw_event(struct h
 			complete_all(&priv->controller_status_received);
 	} else if (data[1] == RYUJIN_GET_COOLER_DUTY_CMD_RESPONSE) {
 		if (size <= RYUJIN_INTERNAL_FAN_DUTY)
-			return 0;
+			goto unlock;
 
 		/* Received report for pump and internal fan duties (in %) */
 		if (data[RYUJIN_PUMP_DUTY] == 0 && data[RYUJIN_INTERNAL_FAN_DUTY] == 0) {
@@ -463,7 +467,7 @@ static int rog_ryujin_raw_event(struct h
 				 * We're expecting a report, so parse it.
 				 */
 				goto read_cooler_duty;
-			return 0;
+			goto unlock;
 		}
 read_cooler_duty:
 		priv->duty_input[0] = rog_ryujin_percent_to_pwm(data[RYUJIN_PUMP_DUTY]);
@@ -473,7 +477,7 @@ read_cooler_duty:
 			complete_all(&priv->cooler_duty_received);
 	} else if (data[1] == RYUJIN_GET_CONTROLLER_DUTY_CMD_RESPONSE) {
 		if (size <= RYUJIN_CONTROLLER_DUTY)
-			return 0;
+			goto unlock;
 
 		/* Received report for controller duty for fans (in PWM) */
 		if (data[RYUJIN_CONTROLLER_DUTY] == 0) {
@@ -492,7 +496,7 @@ read_cooler_duty:
 				 * We're expecting a report, so parse it.
 				 */
 				goto read_controller_duty;
-			return 0;
+			goto unlock;
 		}
 read_controller_duty:
 		priv->duty_input[2] = data[RYUJIN_CONTROLLER_DUTY];
@@ -501,6 +505,8 @@ read_controller_duty:
 			complete_all(&priv->controller_duty_received);
 	}
 
+unlock:
+	spin_unlock_irqrestore(&priv->status_report_request_lock, flags);
 	return 0;
 }
 


