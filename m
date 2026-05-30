Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4DD2F25E4;
	Sat, 30 May 2026 16:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158527; cv=none; b=dqM2bKTTzd9UB9G9GndD8EgvjfWU+rpCQOwEXJsaIjo3q9Qyug4ENusqDXkkcTmf+IpjeT0D7BZ2VGbtbenBQ+h13MP5tH6bOSIDMDiRF2UtgZu5h+ID8DdeBLzeCcunwTpOjS4UI9FpOJOA+CHE5kRQrevYKowaFPPcTSG20bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158527; c=relaxed/simple;
	bh=ijfzh8tVV8/IO7NrZRHRXpm+hxnD3iUiqnZYhRGRGQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1SvUENSQbzEMIVEZHCn90HjUaQXIZzf78dGE8Uox57PVEWPruuBUDbITklQpC3sMj8KlgHR4Q4HVJqAO5YC7nM1YCVCRT3mQQ8tBfHL9NrlBINTnh1EWGNZa/OJsTj3YwvmFCoMfUcgi1SjK0Ts8NfjvUZEhSOoEcRplgrCcS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+IBab4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+IBab4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877B41F00893;
	Sat, 30 May 2026 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158525;
	bh=2HuPvQyl4/4slJ8sBWJkPp31TE0LiXLR547JYgRm8+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+IBab4EsIv21HYUWPp+5v4nSG1lIofWe9XyMXeM4ocVV+xtFfIGcley+Qn4uCYSA
	 8sQEOr+oNUKMoaGSXQCAHe0KFfud4CS/REDI9EZx10FSUV/gGX2cophBVfTRDu/FaI
	 DRLDShNZrHSO4DO4E9S1J5zFpBIBWY3wKLVR9uL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Masaki Ota <masaki.ota@jp.alps.com>,
	linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 060/969] HID: alps: fix NULL pointer dereference in alps_raw_event()
Date: Sat, 30 May 2026 17:53:04 +0200
Message-ID: <20260530160302.041549959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1badfc4319224820d5d890f8eab6aa52e4e83339 upstream.

Commit ecfa6f34492c ("HID: Add HID_CLAIMED_INPUT guards in raw_event
callbacks missing them") attempted to fix up the HID drivers that had
missed the previous fix that was done in 2ff5baa9b527 ("HID: appleir:
Fix potential NULL dereference at raw event handle"), but the alps
driver was missed.

Fix this up by properly checking in the hid-alps driver that it had been
claimed correctly before attempting to process the raw event.

Fixes: 73196ebe134d ("HID: alps: add support for Alps T4 Touchpad device")
Cc: stable <stable@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Masaki Ota <masaki.ota@jp.alps.com>
Cc: linux-input@vger.kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-alps.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -437,6 +437,9 @@ static int alps_raw_event(struct hid_dev
 	int ret = 0;
 	struct alps_dev *hdata = hid_get_drvdata(hdev);
 
+	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !hdata->input)
+		return 0;
+
 	switch (hdev->product) {
 	case HID_PRODUCT_ID_T4_BTNLESS:
 		ret = t4_raw_event(hdata, data, size);


