Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897971C0DCB;
	Mon, 14 Oct 2024 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917784; cv=none; b=LUD7DFvPqajodW2IiG8UXmcFUmF4+R57oPjCBM9/Z/B1gafADA+hOq433QqQHHidskM5INoymkDYPvkYhgBJ4iK24nemiQAPxCr1b6ivOb+QaE9nAwa6NfcLb0X4xIMsTe1L9/tB5vSF7MT8wdLUO4vVknPv/w4fDhLqTecwBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917784; c=relaxed/simple;
	bh=oZbuQSsPNSTKwKR+t20g3BrjQVV7n3+L1pc0MICTV3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWAKtH79wWQXwtDVN+h3M4pmmrQbb/yMIxzkhhpeM+kymU2iNSMi7QqGTB3zBeqVqzFYomF2a4sopxWw9K2/DgeIRKwqgFWmv7sau3cMRkINCIvfGdDmPNBJViSViHs750E6O8fPpKa2q2tXeSuh39oaHXU/ZkJLM9u3EBBlcvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPhsQ1b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPhsQ1b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC70FC4CEC3;
	Mon, 14 Oct 2024 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917784;
	bh=oZbuQSsPNSTKwKR+t20g3BrjQVV7n3+L1pc0MICTV3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPhsQ1b+Gh6Tc3Wbqn89kgzH/NA9BDXAZNkhlhNmsjjcl4cgBVLsOSaEI7btOSbdo
	 A4WwpvvkUCsi6pnEVRv4YMKneUQyMBIIREPyVB7yGrfV79nJDGo4dXuDBw8TiBUYfU
	 lNjpSLiupJJ7jqJE+b4C8y5gCewjWmHjicqNK49Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/798] HID: wacom: Do not warn about dropped packets for first packet
Date: Mon, 14 Oct 2024 16:11:28 +0200
Message-ID: <20241014141223.184785118@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

[ Upstream commit 84aecf2d251a3359bc78b7c8e58f54b9fc966e89 ]

The driver currently assumes that the first sequence number it will see
is going to be 0. This is not a realiable assumption and can break if,
for example, the tablet has already been running for some time prior to
the kernel driver connecting to the device. This commit initializes the
expected sequence number to -1 and will only print the "Dropped" warning
the it has been updated to a non-negative value.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 6 +++++-
 drivers/hid/wacom_wac.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index ae5bd49d89082..245a6e9631a04 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2365,6 +2365,9 @@ static void wacom_wac_pen_usage_mapping(struct hid_device *hdev,
 		wacom_map_usage(input, usage, field, EV_KEY, BTN_STYLUS3, 0);
 		features->quirks &= ~WACOM_QUIRK_PEN_BUTTON3;
 		break;
+	case WACOM_HID_WD_SEQUENCENUMBER:
+		wacom_wac->hid_data.sequence_number = -1;
+		break;
 	}
 }
 
@@ -2489,7 +2492,8 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 		wacom_wac->hid_data.barrelswitch3 = value;
 		return;
 	case WACOM_HID_WD_SEQUENCENUMBER:
-		if (wacom_wac->hid_data.sequence_number != value) {
+		if (wacom_wac->hid_data.sequence_number != value &&
+		    wacom_wac->hid_data.sequence_number >= 0) {
 			int sequence_size = field->logical_maximum - field->logical_minimum + 1;
 			int drop_count = (value - wacom_wac->hid_data.sequence_number) % sequence_size;
 			hid_warn(hdev, "Dropped %d packets", drop_count);
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 2e7cc5e7a0cb7..4fd42c1de53a7 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -324,7 +324,7 @@ struct hid_data {
 	int bat_connected;
 	int ps_connected;
 	bool pad_input_event_flag;
-	unsigned short sequence_number;
+	int sequence_number;
 	ktime_t time_delayed;
 };
 
-- 
2.43.0



