Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3C51BE223;
	Mon, 14 Oct 2024 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917781; cv=none; b=tyzdK0/NiKkxeArMvo7p4psK0LvZEWYRSwHlbtxHlFzsl0xHmclNvFfadJeBw7xUea0D9Yqlw1qEK5yK/31WMclBW16q2cTvbSa4KzHBu6ojt5PoXqgxrajPzD4I+QIAU4DpK48AifEqdDTCQKBg5EgbA7dRAO2mnavDqJ8cfOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917781; c=relaxed/simple;
	bh=VRFfFXimrKzPkAGakim63OUPzXOkOxFa8ErmPwOqw+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBYHZZAxojyxSllnZ9M/I+zQbGINcEKaQNMouEtJ+teMEEGr2H5GhHea6c6tDXASMz6Q2mc7fLhichEHiiLpESvwRMWGYVfDHGx0bTBT5fJmYrhh4mjXv0kax2qlW4SSfO2qysxCSvjm3Zr0VSmfFRFjnw0UkjYFND8NuE7apt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzuTqUoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzuTqUoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5CDC4CEC3;
	Mon, 14 Oct 2024 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917781;
	bh=VRFfFXimrKzPkAGakim63OUPzXOkOxFa8ErmPwOqw+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzuTqUoGSE5RIu6l5aTvhDgsyWnSopMFMLz0jPI7HhCcSBA/sgpCyeIAJklNZG4gf
	 9f1+J2R1r+0YCNja4xI051uWayG9vHsf3LwtIZeNzncgsAW074NSlQAoCUf5l3Xi1w
	 y1kI3Cow1V1g3xAgCDDRaDbxih6oj1F0txKf9ECI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/798] HID: wacom: Support sequence numbers smaller than 16-bit
Date: Mon, 14 Oct 2024 16:11:27 +0200
Message-ID: <20241014141223.146234052@linuxfoundation.org>
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

[ Upstream commit 359673ea3a203611b4f6d0f28922a4b9d2cfbcc8 ]

The current dropped packet reporting assumes that all sequence numbers
are 16 bits in length. This results in misleading "Dropped" messages if
the hardware uses fewer bits. For example, if a tablet uses only 8 bits
to store its sequence number, once it rolls over from 255 -> 0, the
driver will still be expecting a packet "256". This patch adjusts the
logic to reset the next expected packet to logical_minimum whenever
it overflows beyond logical_maximum.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 82f171f6d0c53..ae5bd49d89082 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2489,9 +2489,14 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 		wacom_wac->hid_data.barrelswitch3 = value;
 		return;
 	case WACOM_HID_WD_SEQUENCENUMBER:
-		if (wacom_wac->hid_data.sequence_number != value)
-			hid_warn(hdev, "Dropped %hu packets", (unsigned short)(value - wacom_wac->hid_data.sequence_number));
+		if (wacom_wac->hid_data.sequence_number != value) {
+			int sequence_size = field->logical_maximum - field->logical_minimum + 1;
+			int drop_count = (value - wacom_wac->hid_data.sequence_number) % sequence_size;
+			hid_warn(hdev, "Dropped %d packets", drop_count);
+		}
 		wacom_wac->hid_data.sequence_number = value + 1;
+		if (wacom_wac->hid_data.sequence_number > field->logical_maximum)
+			wacom_wac->hid_data.sequence_number = field->logical_minimum;
 		return;
 	}
 
-- 
2.43.0



