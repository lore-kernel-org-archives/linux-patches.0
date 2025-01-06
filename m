Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CB31DDC2C;
	Mon,  6 Jan 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177142; cv=none; b=KCiouv7QOpvcQAhhNTDkH/PmvKi2UBdWWQ1PAzzzFLki/W3qbh0oswbfwuLnQdHvaO1d+oCOq5ME/b2aO7geJGktcv3rXgmo1/ix2rjVbl2+ffOZaBIzGdVmwapsrXGRaWpQvZ1EHAxTn1Za5HdP/DPGZhrKb5mBdfrKEJoDWCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177142; c=relaxed/simple;
	bh=ik8wSQ0g5ox9WZDu9mzsIYx9jkjxmaYH4ZO5oZpRlek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubFePp5Uo2spBN8g6vX7INzYLTATMx5bQxvQiGZFCddqyke2F/UrfH0Sbbq7wcSpuruAr5j2VLauc+yw00AKHGjGoViyueevvn3Oc8IYBn+gLJBp3sO1rGzA43V5EKd+wrGczmeMQUWWFqjlJt12Fpkw7td5mk09dIO7JGYVNL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZKNvSKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZKNvSKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607B2C4CED2;
	Mon,  6 Jan 2025 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177142;
	bh=ik8wSQ0g5ox9WZDu9mzsIYx9jkjxmaYH4ZO5oZpRlek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZKNvSKDKGSxE2vPPu4PeBTa1spnMgajy3DzzzVhVbyNXhZGhxn73SOfX4eqF9ipg
	 K+wJSLCAwSX5eFwAjP2fkGkPFF54vqK1BNu8J62E7KWyuB7knrZmFnsXaFq/seDihZ
	 M6luB84/G3ZCF2vY4dtUGntv4utg6EqcClyEI3Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/222] usb: typec: ucsi: glink: set orientation aware if supported
Date: Mon,  6 Jan 2025 16:14:30 +0100
Message-ID: <20250106151153.104064946@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3d1b6c9d47707d6a0f80bb5db6473b1f107b5baf ]

If the PMIC-GLINK device has orientation GPIOs declared, then it will
report connection orientation. In this case set the flag to mark
registered ports as orientation-aware.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240411-ucsi-orient-aware-v2-5-d4b1cb22a33f@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: de9df030ccb5 ("usb: typec: ucsi: glink: be more precise on orientation-aware ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_glink.c b/drivers/usb/typec/ucsi/ucsi_glink.c
index 4c9352cdd641..f6c3af5846e6 100644
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -186,6 +186,17 @@ static int pmic_glink_ucsi_sync_write(struct ucsi *__ucsi, unsigned int offset,
 	return ret;
 }
 
+static void pmic_glink_ucsi_update_connector(struct ucsi_connector *con)
+{
+	struct pmic_glink_ucsi *ucsi = ucsi_get_drvdata(con->ucsi);
+	int i;
+
+	for (i = 0; i < PMIC_GLINK_MAX_PORTS; i++) {
+		if (ucsi->port_orientation[i])
+			con->typec_cap.orientation_aware = true;
+	}
+}
+
 static void pmic_glink_ucsi_connector_status(struct ucsi_connector *con)
 {
 	struct pmic_glink_ucsi *ucsi = ucsi_get_drvdata(con->ucsi);
@@ -207,6 +218,7 @@ static const struct ucsi_operations pmic_glink_ucsi_ops = {
 	.read = pmic_glink_ucsi_read,
 	.sync_write = pmic_glink_ucsi_sync_write,
 	.async_write = pmic_glink_ucsi_async_write,
+	.update_connector = pmic_glink_ucsi_update_connector,
 	.connector_status = pmic_glink_ucsi_connector_status,
 };
 
-- 
2.39.5



