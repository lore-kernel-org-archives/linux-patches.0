Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E0384258;
	Tue, 21 Jul 2026 20:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666846; cv=none; b=kGaVeVsiegm4x9gOB9KIeySLsYzwd4HM33w85m4xcNePUxNi7SpGblEpIV+em01YaGa/aOYKRcqzy6L1/qgnoOpEEK27R458GQSYpg2fbnaUNlRupC4+8ZQuW55sp8miKxt4FW2ZycKutI0CDNnn1quGpOC2FKMQ4lKdH9SaYyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666846; c=relaxed/simple;
	bh=aJHu2EkD/tNeJc5ks+HnhKV3rkWqh1ox3P9N3S2yQs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6ZFqB41PsXJtzFLdLXf7/RIc7JQ7tsXVyA1qafSZlPGAVsa4pFVD40ZxoQeDNOEahCxTXDyC0nEq2UHv1q3dQFib95nMl3IGvCs3aCfCE946z+GDtATNsmwpGaIQ6m6xIPRpTHGplrgtkbENhYbvfM4VsGiutLm8Rqbuy+aBWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6lCJM/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6lCJM/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88171F00A3A;
	Tue, 21 Jul 2026 20:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666845;
	bh=SFs7SSWpgErp94kwjFBGJClRmvH1Km0lW2RYxMOu85Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6lCJM/dvwK+M2PAuEQOOFfcTs46gYFqfsrfv468eO3HA5WCfAXaEf6tnmFhgc/7f
	 do9/GTqHT6bKEpZZYZZeBM6E8tWjQfgvxbk1rAKXfFnNhpHJB+fCVRiaI7ksRn1jSz
	 8V0QKhvHxYgltDXhR3RlyIvxl+jQ4i18ycBfNcVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0838/1266] HID: core: Fix OOB read in hid_get_report for numbered reports
Date: Tue, 21 Jul 2026 17:21:15 +0200
Message-ID: <20260721152500.605815267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit af1a9b65ebe8a948eda805c14b78d4d0767cb1b5 ]

When a caller passes a size of 0 to hid_report_raw_event() for a
numbered report, the function originally called hid_get_report() before
performing any size validation.

Inside hid_get_report(), if the report is numbered (report_enum->numbered
is true), it unconditionally dereferences data[0] to extract the report ID.
With a size of 0, this results in an out-of-bounds read or kernel panic.

Fix this by moving the numbered report size validation check before the
call to hid_get_report(), ensuring that size is at least 1 before
dereferencing the data pointer.

Fixes: 2c85c61d1332 ("HID: pass the buffer size to hid_report_raw_event")
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2de4d831c526a8..b3bcc0fdede7ff 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1998,6 +1998,13 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 	u8 *cdata = data;
 	int ret = 0;
 
+	if (report_enum->numbered && (size < 1 || bufsize < 1)) {
+		hid_warn_ratelimited(hid,
+				     "Event data for numbered report is too short (%d vs %zu)\n",
+				     size, bufsize);
+		return -EINVAL;
+	}
+
 	report = hid_get_report(report_enum, data);
 	if (!report)
 		return 0;
-- 
2.53.0



