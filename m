Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593CA331A61;
	Fri,  7 Aug 2026 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114677; cv=none; b=aJ+d7kWURgkAGLaEOI9KzLOyFJBvpLjYLeSYZrUfFh6THZSEYiWeap8nyNgtz0+S6K7u+ST2BJ00Ucqpm9mQ7l6mmA5a4js8sWiphgAo+QoNKbRqiLaPpM2FlESrgaZsPHJkKnVSCNakWImjaQotxV03nXFlQR9LtCsbHpC+Soc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114677; c=relaxed/simple;
	bh=WofYrSHOEF9dmdAraZVa8u1eiDKsuXZvFEY8zs2NyEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHUS/7MXCVh91G4nHEhmC2UUpHD8mYSnHWTEY0372/iwpwR7OcC1lWQQrnCDbXVN8GLgHImADeJncIY4kzJ+r3DdMMRwbkpH0E/UR+hvyIEdFQAuAWtJj8c0qjdD95kagSBC9+LLDEelQaQlpvCCqKEOQDRQUtGjl2v5hZ6Pfg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmmpCBo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmmpCBo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49611F000E9;
	Fri,  7 Aug 2026 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114676;
	bh=TpQPj0JF/t53ABjqC1tr3NzZYbe3LdflpySoLv4tb/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmmpCBo/4Xqx8vYGt9httrVBIMQAVaHOYd++0v655sWf13cr4jQG5bWbMO+rWEmrM
	 4GMgPXtZ8Pc962lh04QTNxmbvot0LWwMaI8nXLI+EoC/ABNCw/ARc35X50YWkWEQlK
	 vnSMiek9NmGARcAnieF3sD40vHX0B0WV8j6kXGt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/396] HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report
Date: Fri,  7 Aug 2026 16:32:50 +0200
Message-ID: <20260807143424.495046061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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



