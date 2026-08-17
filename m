Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497B644237B;
	Mon, 17 Aug 2026 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977184; cv=none; b=eYsgaC8+ft2qiHMZMpcceMlhdSLW9QUmbi//uJfuwFTpGK4y5AuZHkKrMvUGY92OLJhAV8Un/iljilzhc1GzSeQPOqCCo3xJFCwWIFjCyA58cF8KqRqX6TmbsZTh3kXxJANdAztVcE1tPJiuWrhDjb7Cs0vqrRd/dyKs65yML/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977184; c=relaxed/simple;
	bh=dh0SRFssaTElD2yBJb+Ck7GvhKFGhxo7kw41U4dyw5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOIq+UWw9TnbhEFB97SGrlGi+7pt86SiJIgcgyaStdnKBuynygnn/kbssG3LkhvsTmFXALrSszA9+8tioKLytse3C/izXug1V/m8LJBRYhtyfS8w/05JMHKgdZ8CptyCKdJErst59mmsdn8zxvyOqvPPbWA5/Ex8EzGOCDdkla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUSN/sf8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUSN/sf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDB71F00A3A;
	Mon, 17 Aug 2026 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977183;
	bh=bv7mZSalxdTOP7zA+kg2oWV6ioWQUw4I2NOqllNE3Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUSN/sf8YMwSD79zsJYo0UoSL+utqXNOeN3iCiopCz+/mf/gS7INtBLfFfjisPJTR
	 cg1buCgKmotJM49aJT8hShX5OLeVDhZDQuXPhldv+dgWeKbMvzm5sTp8geJuAFNqJx
	 2PTa/I2y9bmUjWsOp3AR7IAZQ3eYscIrk/gURQnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/456] HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report
Date: Mon, 17 Aug 2026 15:30:32 +0200
Message-ID: <20260817132549.550154797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 591a8f56ad2e9..8b11aade46c4d 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1797,7 +1797,8 @@ static int logi_dj_probe(struct hid_device *hdev,
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



