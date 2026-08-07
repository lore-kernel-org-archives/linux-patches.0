Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3307142BC42;
	Fri,  7 Aug 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113767; cv=none; b=FFylnt/cytWhOSgYWpzrNPEZsaEt8k5mvnWM1uMoDSSbLtyr27PnXSnq/gNYUYnYBNafG/AYzeiwjCx/DxqxWt7o0QBG11cPRbgP2rPTIQyyo/RDekuyk+O+MPZdoXxc8RWtggeP/VPmE2gUaLzE4ojBUXgbt04AuohxrYFKzxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113767; c=relaxed/simple;
	bh=9d9tA1+X7SOxFDSJKnwzdIVnQn3RQYStctbCTpEh0iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZbM+jfinrvsNkv5Cu3tQjoCdPyHgoAun6qgC4E/lf84nd+c4tORkYp7NwKfv59YSnlizhn+Sit+LQkkJzhb0Ai3njBRmgWu+B7PwtsmjD4SvuQA6kpqC0JuYvfAz6kkNFipnB0G9zOejJsbNsSX6m9oX+gfWZfbmiIJ6Kv0FSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJNzKBB/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJNzKBB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B228B1F00AC4;
	Fri,  7 Aug 2026 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113731;
	bh=6MRvl+4upOhvtKS4FkRcgZ6zNDPuN6w9hhUQ69JS3es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJNzKBB/PE10bA4nJEI2bCe6qurJDU1Otf7iDz5NP4Z3FpgXMv67FprSyWbn6LEP8
	 0m9LAW4jJCTanP5+oWugZ62FBHVR6fcnOdVoxvboZJ90VDN4W3HBbMPxZNaL6zxR8f
	 3Zb5V63YXJa/XXiCbeMMbJRCLtfyvYeqFAYtxVI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/337] HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report
Date: Fri,  7 Aug 2026 16:33:39 +0200
Message-ID: <20260807143418.870308539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3a37d61616293..f1e923ed9d1c5 100644
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



