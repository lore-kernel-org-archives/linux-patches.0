Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6441D0DC3;
	Wed,  2 Oct 2024 14:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877849; cv=none; b=eMFVmTN7E+8GKLq3aaDOuJbPPgqHV+72mGhgJgJHfh2Vd61RCmXkiXm3spmrHn22McGo/ISh0DFGaiCr0IUi0lOijKeBE9bpynZFNVbKyQs7orMGM23ceztSbGPpybsB6W/k+2D3YJnxQXGdg5TXhYa3KEzqD2LuD67O3iyxuZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877849; c=relaxed/simple;
	bh=kJPzDIsOyPavXjf1wluvBuWrqc4BmOwhf424WRrNSos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfWhCVdVEaWhUqemikt5H6Mw8W520Sj25q08igLBIm7Z31h6VdVk2t1dJogVRTh9r84jhEogw0EziJ4lzoDdWOrjVdkteiiS97o4BnYjiam2HBy6z3lH4QXSmGWVgwYIPmyTcnT8arEPfiGIG8oihUATfk7PLruc4rqQJfFA6sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYaC4Ewf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYaC4Ewf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA39C4CEC2;
	Wed,  2 Oct 2024 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877849;
	bh=kJPzDIsOyPavXjf1wluvBuWrqc4BmOwhf424WRrNSos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYaC4EwfTzUFtLir3ktjAGYZm9OS5/SybR4YK3/wjITVBYLMWe7iBFAooa8G0hNqv
	 dGM8h05omBurF4oPZsSn40H/S38prKp7nc/P95jKgoZmZljCBRseExfutm+cQlH5Bm
	 PoJTGs6+6DCwdKpAkN3Bp1lBSh7tmGE1iouZJZgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 216/634] HID: wacom: Support sequence numbers smaller than 16-bit
Date: Wed,  2 Oct 2024 14:55:16 +0200
Message-ID: <20241002125819.628938506@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d84740be96426..8cf82a5f3a5bf 100644
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



