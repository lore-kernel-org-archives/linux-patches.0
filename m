Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2775629CE7;
	Wed,  2 Oct 2024 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875856; cv=none; b=Zl2OfmFv8DdpMBf2iRzOSnhYHSzl6DTeTjGPqW1QsI2R8k+B2NyKf4SeQKrjCh8H1s5O8HZZJm61UQOXUUyT5XcQomgsIZE13/OrHMtCY6V5VySQmLMkSDHjASjllI4/2UH3nClSrRVaDhf+1y/IiKQGw9fSNd44171Nq2/2EuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875856; c=relaxed/simple;
	bh=qir8hUIzjYOx/s6I5mhOWv+2j3LIUgP5ne2XUfA3268=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uo+ph1JXld1sIk19G4yoey9GQv6bU3JRlGnwLjqzlPSktPdf01TFnLHtCOnRr6pOCXyDKEFh1M3VfOEBpBauhuzJ7kjQNR1u87jAtIv+AWeAiJgiAyzPhpJy7ilk7lMrvZOS9uGLaSjWsZaMpwvrC4XH5fFN4e8Ky45l9jdAfMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7k6Z9Sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7k6Z9Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1629C4CEC5;
	Wed,  2 Oct 2024 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875856;
	bh=qir8hUIzjYOx/s6I5mhOWv+2j3LIUgP5ne2XUfA3268=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7k6Z9Szg3hidFCSzldpQXg/6xVU3/tKpG3FF9loRFAkB15r9hpnknSq7zY8Rdq/2
	 7ZDWnwf6ewdFjEPbqZK5Q39MdNnPNUBDUhfpiTnBsZjBX3GLgPcBwXTfEQ2mnulLOL
	 uODOv/npsdUholdl6ATAO+nP5oxk9JC20G75J+SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 244/695] HID: wacom: Do not warn about dropped packets for first packet
Date: Wed,  2 Oct 2024 14:54:02 +0200
Message-ID: <20241002125832.192328860@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
index 0c8713fe0d179..e86a37c3cf9c3 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2322,6 +2322,9 @@ static void wacom_wac_pen_usage_mapping(struct hid_device *hdev,
 		wacom_map_usage(input, usage, field, EV_KEY, BTN_STYLUS3, 0);
 		features->quirks &= ~WACOM_QUIRK_PEN_BUTTON3;
 		break;
+	case WACOM_HID_WD_SEQUENCENUMBER:
+		wacom_wac->hid_data.sequence_number = -1;
+		break;
 	}
 }
 
@@ -2446,7 +2449,8 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
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
index 6ec499841f709..e6443740b462f 100644
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



