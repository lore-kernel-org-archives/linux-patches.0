Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BD8359FB9;
	Tue, 16 Dec 2025 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887288; cv=none; b=ascCgiJZ6xrFUaXMhDKQaiymHP9eYKP6Vac1Wp+8TK70j1w8DgbOwTMl5lvH6wexh88PDgQdVHcn0qpWWnwvCwuJleQIyA7d79M0jyrw6ZKaJlIoi7ECDGmPMMdFCUOcgn4ClTYSdofnUujMXVRbdv7WVDdgyNe3G3WeRgf7W5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887288; c=relaxed/simple;
	bh=EZ5Tk8YQuijQK0KlbTrWdBD7hiooDmFTTMXApZoRt9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i62d3aretHulykD+IB4RrXk3fuxrK7qIx9RITCOlTtisH75zOLP5/7O1xq2i4B/4azLKYJ9ISZwk6tLbqREDsN5gv9xBReaznRdpyUPD2v525SGwF4NNrdzox4Yfp02kt0kYVZMJt0lDD63pOkkeLm6blFsiXij+N5M2RTYDRPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13E1IAzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13E1IAzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4292C4CEF1;
	Tue, 16 Dec 2025 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887288;
	bh=EZ5Tk8YQuijQK0KlbTrWdBD7hiooDmFTTMXApZoRt9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13E1IAzQDawVvinOpH9jS+NyPvG02AwETW5ZAcMLVJ5EwBdHkGLr3/PnzvXevVF5o
	 4kIMqlGWlW4yU4ivFF9KCVCvZKqeCIDlkLtcQSfwLbzf2xA4JBFrXqIpczDPr1OgmG
	 +txAjen7KYyYJw60o6ck/qAflIhOPuKIh0Ips+ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/614] power: supply: qcom_battmgr: support disabling charge control
Date: Tue, 16 Dec 2025 12:09:12 +0100
Message-ID: <20251216111408.076117355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 446fcf494691da4e685923e5fad02b163955fc0e ]

Existing userspace (in particular, upower) disables charge control by
setting the start threshold to 0 and the stop threshold to 100.

Handle that by actually setting the enable bit to 0 when a start
threshold of 0 was requested.

Fixes: cc3e883a0625 ("power: supply: qcom_battmgr: Add charge control support")
Signed-off-by: Val Packett <val@packett.cool>
Link: https://patch.msgid.link/20251012233333.19144-4-val@packett.cool
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index c8028606bba00..e6f01e0122e1c 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -257,6 +257,7 @@ struct qcom_battmgr_info {
 	unsigned int capacity_warning;
 	unsigned int cycle_count;
 	unsigned int charge_count;
+	bool charge_ctrl_enable;
 	unsigned int charge_ctrl_start;
 	unsigned int charge_ctrl_end;
 	char model_number[BATTMGR_STRING_LEN];
@@ -659,13 +660,13 @@ static int qcom_battmgr_bat_get_property(struct power_supply *psy,
 }
 
 static int qcom_battmgr_set_charge_control(struct qcom_battmgr *battmgr,
-					   u32 target_soc, u32 delta_soc)
+					   bool enable, u32 target_soc, u32 delta_soc)
 {
 	struct qcom_battmgr_charge_ctrl_request request = {
 		.hdr.owner = cpu_to_le32(PMIC_GLINK_OWNER_BATTMGR),
 		.hdr.type = cpu_to_le32(PMIC_GLINK_REQ_RESP),
 		.hdr.opcode = cpu_to_le32(BATTMGR_CHG_CTRL_LIMIT_EN),
-		.enable = cpu_to_le32(1),
+		.enable = cpu_to_le32(enable),
 		.target_soc = cpu_to_le32(target_soc),
 		.delta_soc = cpu_to_le32(delta_soc),
 	};
@@ -677,6 +678,7 @@ static int qcom_battmgr_set_charge_start_threshold(struct qcom_battmgr *battmgr,
 {
 	u32 target_soc, delta_soc;
 	int ret;
+	bool enable = start_soc != 0;
 
 	start_soc = clamp(start_soc, CHARGE_CTRL_START_THR_MIN, CHARGE_CTRL_START_THR_MAX);
 
@@ -696,9 +698,10 @@ static int qcom_battmgr_set_charge_start_threshold(struct qcom_battmgr *battmgr,
 	}
 
 	mutex_lock(&battmgr->lock);
-	ret = qcom_battmgr_set_charge_control(battmgr, target_soc, delta_soc);
+	ret = qcom_battmgr_set_charge_control(battmgr, enable, target_soc, delta_soc);
 	mutex_unlock(&battmgr->lock);
 	if (!ret) {
+		battmgr->info.charge_ctrl_enable = enable;
 		battmgr->info.charge_ctrl_start = start_soc;
 		battmgr->info.charge_ctrl_end = target_soc;
 	}
@@ -710,6 +713,7 @@ static int qcom_battmgr_set_charge_end_threshold(struct qcom_battmgr *battmgr, i
 {
 	u32 delta_soc = CHARGE_CTRL_DELTA_SOC;
 	int ret;
+	bool enable = battmgr->info.charge_ctrl_enable;
 
 	end_soc = clamp(end_soc, CHARGE_CTRL_END_THR_MIN, CHARGE_CTRL_END_THR_MAX);
 
@@ -717,7 +721,7 @@ static int qcom_battmgr_set_charge_end_threshold(struct qcom_battmgr *battmgr, i
 		delta_soc = end_soc - battmgr->info.charge_ctrl_start;
 
 	mutex_lock(&battmgr->lock);
-	ret = qcom_battmgr_set_charge_control(battmgr, end_soc, delta_soc);
+	ret = qcom_battmgr_set_charge_control(battmgr, enable, end_soc, delta_soc);
 	mutex_unlock(&battmgr->lock);
 	if (!ret) {
 		battmgr->info.charge_ctrl_start = end_soc - delta_soc;
-- 
2.51.0



