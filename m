Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6885929D27A;
	Fri,  7 Aug 2026 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114557; cv=none; b=sRKpd7vdNQkKMQIxy5zFvy3z+hkP3vpvxpt11zj3mIuMUIGMWdyh+qqHTjOrhy5mE7YYloFOPJzm/jPYUdxm7ls+PN8xwZCOgqJfcGIsUVNPQVw0CPMbd9smTYrtKiD3oVZ0WVdeEXbrhmL/CWrh8WyPUjavoltTWvyY2RaYSpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114557; c=relaxed/simple;
	bh=mrKGereVNEkTnwx79A4ms/ziNru+5NSat4K5usqTbMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJp3YV7iahev50vzIn5X9UyjRpqENRYeRpbTHlmMdlOWr1ui5BkDqtb0B0CrAlNlHPhEKgLXeXZ6/8h4DzypOiySvUE/FBVZq6KXq4y8mCUdnFx7p62z3ZlPa8yoF2KUkxyRURosVOOwfOpcx3s73XsJQ4MXjCnqnxgfoIHiSyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2OakDLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2OakDLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C01F000E9;
	Fri,  7 Aug 2026 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114556;
	bh=sLoKPRRgD36jgBlIDkQRecJ9h7RTMZPsA7s9UXXOfu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2OakDLNpK+ifbX61v4G7rXmqP/w/6WY/ieABTrpO7nLH0MLZSspXDqZbd98qnMmg
	 wjQ6B7fsvuDBdHnQTo+mmRPfUcNB8zePPhTBZU1Tu2PzCoThotO/BfxIqyC21je1El
	 9D6EkqBXO9Ha1CMEWHCmvF395VG/BLsyBeOciLOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 268/337] HID: logitech-dj: Fix maxfield check in DJ short report validation
Date: Fri,  7 Aug 2026 16:37:51 +0200
Message-ID: <20260807143424.352542079@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 590cc4d782487632a52f37c2171bee1eeea29627 upstream.

Commit b6a57912854e ("HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT
related user initiated OOB write") added validation for the DJ short
output report, but the error path dereferences rep->field[0] even when
rep->maxfield is zero.

Commit 8b9a097eb2fc ("HID: logitech-dj: fix wrong detection of bad
DJ_SHORT output report") made the check conditional on rep being present,
but a crafted descriptor can still create report ID 0x20 with only padding
output items. hid-core registers the report, ignores the padding field,
and leaves rep->maxfield as zero.

In that case the validation enters the rep->maxfield < 1 branch and then
dereferences rep->field[0]->report_count while printing the error message,
causing a NULL pointer dereference during probe. This is reproducible with
uhid by emulating a Logitech receiver with a padding-only DJ short output
report:

  BUG: KASAN: null-ptr-deref in logi_dj_probe+0xb1/0x754 [hid_logitech_dj]
  Read of size 4 at addr 0000000000000028 by task kworker/4:1/129
  ...
  Call Trace:
   logi_dj_probe+0xb1/0x754 [hid_logitech_dj]
   hid_device_probe+0x329/0x3f0 [hid]
   really_probe+0x162/0x570
   __device_attach+0x137/0x2c0
   bus_probe_device+0x38/0xc0
   device_add+0xa56/0xce0
   hid_add_device+0x19c/0x280 [hid]
   uhid_device_add_worker+0x2c/0xb0 [uhid]

Reject the zero-field report before printing the field report_count.

Fixes: b6a57912854e ("HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-dj.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1797,8 +1797,13 @@ static int logi_dj_probe(struct hid_devi
 	output_report_enum = &hdev->report_enum[HID_OUTPUT_REPORT];
 	rep = output_report_enum->report_id_hash[REPORT_ID_DJ_SHORT];
 
-	if (rep && (rep->maxfield < 1 ||
-		    rep->field[0]->report_count != DJREPORT_SHORT_LENGTH - 1)) {
+	if (rep && rep->maxfield < 1) {
+		hid_err(hdev, "Expected size of DJ short report is %d, but got 0",
+			DJREPORT_SHORT_LENGTH - 1);
+		return -EINVAL;
+	}
+
+	if (rep && rep->field[0]->report_count != DJREPORT_SHORT_LENGTH - 1) {
 		hid_err(hdev, "Expected size of DJ short report is %d, but got %d",
 			DJREPORT_SHORT_LENGTH - 1, rep->field[0]->report_count);
 		return -EINVAL;


