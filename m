Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6011D04A8;
	Wed,  2 Oct 2024 14:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879673; cv=none; b=Cx91kmK0EPUDgAv2SzKTdr6so6/wKvl0HmYf2GASe5hw0ui76MbtkQdGfG2hQqYSki4rRHbSyFb1+qEcUqtSISEs1xZ7PK5VwJAWatWTfN3TggiMGhKunrDQcoIhrCpmdjO/IgalfpT1XruNsZEdXqiHMLGkLSeGLKRxLoORhaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879673; c=relaxed/simple;
	bh=BaDWNXJRkz2f2zOpQTC2Y6AWzOznmkm+AkOpyOi1wi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK0g3+O47dmrOGly4K3QiNgn+x/ze6+Egl54H5YDiFs5fURTeMczRNaNw+1qNCtgZ0miXYaT2MnnOazpJH64lrcW0RU1bbcV7PAletA94NpX8n0OKyjg5wK6hpK+8vrJ+3oiSWCT+10rNCSL00DYEafAvFN9wIAj6oKXXciHBjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9QKs60k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9QKs60k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71C2C4CEC2;
	Wed,  2 Oct 2024 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879673;
	bh=BaDWNXJRkz2f2zOpQTC2Y6AWzOznmkm+AkOpyOi1wi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9QKs60k/KsOnEJb6aHvBxl6N551qK1fiLlNl/C44yFxvCiszs9OD7gfk2Upu3fVW
	 4+R4d31mPAh/57McdBDKMdoOucDacYvOWcKwPe0NpPQ/6yqoiMgwJgm7IT/SOYIpaP
	 KeH+cmeN2BY8FwxTLwUhfFdUYhmypXZgdK9J+Ns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/538] HID: wacom: Support sequence numbers smaller than 16-bit
Date: Wed,  2 Oct 2024 14:56:47 +0200
Message-ID: <20241002125758.884982499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5db26a8af7728..c3c576641a38e 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2492,9 +2492,14 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
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



