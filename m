Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465833BED23;
	Mon, 17 Aug 2026 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979672; cv=none; b=iTrXiMUfBu5WvmuCbcV/aM3DohxfYNEBlyUl1PJY4+3EGSVUw28aic4rgVkgoatKOQrZ95u9+EohmihSetQreTCPJ0jN4toDRT1NrhLUTQvxdBXH6JzvVTTOrRpcXlPMCX8LyOMkmOmWlsXfCsvfrN0jssl0meY90mf3oNBe36M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979672; c=relaxed/simple;
	bh=QPMOPeKKMyAW/lNpFN5beCmvz1yboWgH4dF2VK7IQLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7TA0iaGxuWJ7vu6rPXwvI6O2xWaAv5zkaGvB62TxGYCSFmlc1HjoZ3CCZ5ipN0uRpu8d+RgyRTlyde+YhHW8rP9v1vYrhUMWDZNmvvDun1HKPUuh9JhPgjecE4/zzMEESL+w6Ya/CcxAs2VeNawaYA3snUXTjIwUqZ61yJMSbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZzwrLcN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZzwrLcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE371F00ACF;
	Mon, 17 Aug 2026 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979671;
	bh=0waXONIGK+y1iK9uzmrnqZY/fws6OFNWH4vIZbRpnko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZzwrLcNZ46yfAonxS9K09p6ETYlJD/yQJfmEXLaCYARdAbQbfmPpQ8+k2Dy4Wcbu
	 RVefB9ZpvR0KVN5P4+ZtrVPTBBlkI9pTqyx6kZ1z6fQkB/KoA9rMcbVlCaHYpZgPpE
	 rHqWh/WkBYxJRGhDpuQd0UKjK5pKmwBvVH92NrD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 306/609] HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report
Date: Mon, 17 Aug 2026 15:30:02 +0200
Message-ID: <20260817132554.484926569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



