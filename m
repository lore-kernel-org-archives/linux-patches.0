Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F29BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CE5C433D2;
	Tue,  7 Mar 2023 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213016;
	bh=w/OFUmNltoAFo66qK+uQlG9sHZGyUPwRkXH2JuihsB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0d1HjcTyyz0vksnFUn/j0mRVExiI47YWXlmyq75qzucxzosKzTdjPWmRZauFD71U
	 nZStlktIexvoTuLyH3cp8fQu5FTolWedKPlEEGaeRSTus4DYmviqCrCyBkXRxITZxf
	 Ee99wHHoKInbUpW1HH/aMKMF79WOOxYqETy60lhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 370/885] hid: bigben_probe(): validate report count
Date: Tue,  7 Mar 2023 17:55:04 +0100
Message-Id: <20230307170018.395104502@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit b94335f899542a0da5fafc38af8edcaf90195843 ]

bigben_probe() does not validate that the output report has the
needed report values in the first field.
A malicious device registering a report with one field and a single
value causes an head OOB write in bigben_worker() when
accessing report_field->value[1] to report_field->value[7].
Use hid_validate_values() which takes care of all the needed checks.

Fixes: 256a90ed9e46 ("HID: hid-bigbenff: driver for BigBen Interactive PS3OFMINIPAD gamepad")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230211-bigben-oob-v1-1-d2849688594c@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index 9d6560db762b1..a02cb517b4c47 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -371,7 +371,6 @@ static int bigben_probe(struct hid_device *hid,
 {
 	struct bigben_device *bigben;
 	struct hid_input *hidinput;
-	struct list_head *report_list;
 	struct led_classdev *led;
 	char *name;
 	size_t name_sz;
@@ -396,14 +395,12 @@ static int bigben_probe(struct hid_device *hid,
 		return error;
 	}
 
-	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	if (list_empty(report_list)) {
+	bigben->report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 8);
+	if (!bigben->report) {
 		hid_err(hid, "no output report found\n");
 		error = -ENODEV;
 		goto error_hw_stop;
 	}
-	bigben->report = list_entry(report_list->next,
-		struct hid_report, list);
 
 	if (list_empty(&hid->inputs)) {
 		hid_err(hid, "no inputs found\n");
-- 
2.39.2



