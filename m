Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA86A3F9A1C;
	Mon, 17 Aug 2026 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976046; cv=none; b=KbNkiPUFpyhagEOFEzivyf6Euj2rEEwjFjyKaXzK5H0MQDGzMxVOl0bt37fIJjvEp/VN4yOZk4ttZs1Syxm+HzVbaSe5qPuLfRzJQMjU75qbcjZSwrGBk5u+IaRsDxtRpW5xd29Bk1zQBAVBA1yrCL63u/QkGKlu3+6sl6qcYBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976046; c=relaxed/simple;
	bh=LT0h1evKg9gQEl3WItgjngxlORw3cPdHLmhsM/HK0bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx4dSmn4SRICbqXN80uwuS9uspHRlKb/56wpyk/Dfo4zcIivOJKe9a0DMtqnV9xT0A1i179RmJvI9SNgUhBNwu1NiP+8zLZtkoITg8FBODFVC4rzLSHjIaoX2trFeeCAEA/WG9OiJAsrShcayxHhQj7FiqEf5lTaXkiImryuGq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAfWvSSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAfWvSSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1746E1F000E9;
	Mon, 17 Aug 2026 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976045;
	bh=0TWy/HU21dn83En77n4yNkbLOM5qY4T5x3g8J6mA09w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAfWvSSs1LozDBcM+Qf8UqtCM1f8eq2ybe3CCicI0uZOYgfm35reeSZDcbnDqvEzn
	 cDyRl5peY8NAbZ+6D1F4Ed4nQ2AwbPH/WC2FGE8yBWLPhQ1s6ZcEAGxYO2+Irp9T7A
	 eHzeCykRPICz/y69qNmZmoBUyOoMVOcFqwbryuyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/389] HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report
Date: Mon, 17 Aug 2026 15:30:38 +0200
Message-ID: <20260817132546.971685372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 8b9a097eb2fc37b486afd81388c693bf3ab44466 ]

commit b6a57912854e ("HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT
related user initiated OOB write") assumed that all HID devices attached
to the logitech-dj driver was having an output report of DJ_SHORT.

However, on the receiver itself, we have 2 other HID device we attach
here: the mouse emulation and the keyboard emulation. For those devices
the value of rep is NULL and we are triggered a segfault here.

This is doubly required because logitech-dj also handles non DJ devices
that might not have the DJ collection.

Fixes: b6a57912854e ("HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write")
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index d3f63bac518ae..4bb324b73629e 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1715,7 +1715,8 @@ static int logi_dj_probe(struct hid_device *hdev,
 	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
 	rep = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
 
-	if (rep->maxfield < 1 || rep->field[0]->report_count != DJREPORT_SHORT_LENGTH - 1) {
+	if (rep && (rep->maxfield < 1 ||
+		    rep->field[0]->report_count != DJREPORT_SHORT_LENGTH - 1)) {
 		hid_err(hdev, "Expected size of DJ short report is %d, but got %d",
 			DJREPORT_SHORT_LENGTH - 1, rep->field[0]->report_count);
 		return -EINVAL;
-- 
2.53.0



