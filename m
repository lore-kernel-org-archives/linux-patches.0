Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A31D46EC9A;
	Tue, 21 Jul 2026 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658136; cv=none; b=jduQfCF3JoasbP2nYyVyxxhTUOz+rqc7QEu/CSalH5dasVfIt2me5hO93bDIU9XxI6Oq5+B5Dq+ts4yP3+BcCqHIu9Z0+nE3UQo5UiJaRk+2BOnDjhka4R/YrMOyixpgubjFMkgUPNrbVJnJ9sMKVt5igjk8MSKc19ngQbyjrHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658136; c=relaxed/simple;
	bh=RoHsd0PYb01OUTU3O2C50bWL5aAumltOj6A0QLAPzRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8TB0WgOQYz8/xvDtuvUXvzoXbm2Vo0gtmaJjtCyc2tnUV3QiJupMldhEQ/xdazxFEFA2Av7mOBN1nV/YbLx6bYmK5rx4B3O191+9GITby4A7OxghinwJwnHdV3LVIMevx2G054J2C6F6J1tPoroV3wKOojUU2rQhmuO6pwEwY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlDOG4Ed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlDOG4Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA631F000E9;
	Tue, 21 Jul 2026 18:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658135;
	bh=3IdJyO8A+pu8nmVaBb4y18zHRZtcdtKG/LvBDklC388=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlDOG4EdK+k+nyWDc7KBqG2OKr0cveLOs2QgQGpwAYr/Cs7eWVK+Htjc8pUv/GEL/
	 wV2eJnuV40f5KEOTRDGSV/QpMTH6aZpQCIS1bl4TLTwm4oXZ431MiTb5Du9nV/ob1o
	 7nNSSwftzqIMEAgc8K9ksF6UBF5y8Zp9Q0h2+pvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1030/1611] HID: core: Fix OOB read in hid_get_report for numbered reports
Date: Tue, 21 Jul 2026 17:19:06 +0200
Message-ID: <20260721152538.567272794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 6a1600af30e20b..4df51bbd0d54ca 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2041,6 +2041,13 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
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



