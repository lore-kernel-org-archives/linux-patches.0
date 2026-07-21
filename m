Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC444AB71;
	Tue, 21 Jul 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669765; cv=none; b=i4K4MTeicc7RfzQlixcfj9yB5zWiZHq3KH9acLycku9Yks1loJBnQsUJUh8EFi2nO+j4jfuiGqDGBTZLQtYIrvRtGxPWB3b9UegncvO3iwEWJDZsEC/6+hriFpjbrC84F90Z+/9SmlLep36ovO6EMxAKB/8hz4ZgKiMJaZgJqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669765; c=relaxed/simple;
	bh=rg9Z094kNSBszcTz0wl5EJaSNQfvThec9Tp1BO6bJ2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+r6x6HQC1nPGxwrGZCBg6je+DQJCZTHMPN9ZDRMjZRgzEkz8mI0xMup71fJIjenQ7fSyiinpPkBv9SSc99xWIWu0gGd9fcFwl/VJ8sE6JSOJRTCB6Nru7ltZEgv2QRE9/AlL1F/i5cEMl6L8YNaIiCKWKnSqDBmVxJLYQdC8hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LquV1qWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LquV1qWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22661F000E9;
	Tue, 21 Jul 2026 21:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669764;
	bh=BJZCuyNXrM0SoDjox9k0xXXRPJMi1v0wCspwJ5FiSuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LquV1qWW3hL0xN65nxlYxMaojq4F0MRxnV/79nlccQk9sLd9JicjpEOV8sRQeIbGP
	 5E5QtNxRri22W2jPZR5ObxMgig3jyFo74pwGWBqvy5RWQD3AA3owag01RUr9153HDS
	 gDGLg+R5glZ2ghLl6mQ7fyQc5pUYioga55prehc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0678/1067] HID: core: Fix OOB read in hid_get_report for numbered reports
Date: Tue, 21 Jul 2026 17:21:19 +0200
Message-ID: <20260721152439.764067097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 2191205ce5b0bf..7270561cce1cc1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2001,6 +2001,13 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
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



