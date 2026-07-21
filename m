Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B8397E9A;
	Tue, 21 Jul 2026 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653672; cv=none; b=n9CBJ6mmgsfzLcAQFcRYPcTuV4QbY5QLRgBmcDM5YDjnly2oEiQQctRrKHm4RBGt/CN+JJgd126wX9VwuCr5WlmnYXKVTwf1F5ou5688Ox1MN2a/xaB+2f2d6IOcnDHemEh/yceJ1mgv0NmmJ3CxDlGfrsSzKBgVbY/U5jh8w7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653672; c=relaxed/simple;
	bh=AuwIwVh6gJtUdKAayfR9WUzD1nLkwWstTO0k9mQkKv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0CbqnS/7l1tItxiqOsie5m3+BoiaQJbXVNU0In8b32E2GRoyEsF6jr7GVgRIVzABe+54ZJqcOlpl/qyRLwkxKWYV9jsla60VysnTMWhSh/jA/PZ5wri/sPYMqFVn2ywLjbDplTbSyoI+VB3K5GCPW6U+HIBYahqB2eNasSABms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVBVUuCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVBVUuCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49F21F000E9;
	Tue, 21 Jul 2026 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653671;
	bh=oRUImTzQNtAHCHta7S8/PyEPVA1TyDtrz92SId9y+WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVBVUuCJTRDxSabYa9Jsa7Jp6pllMqvbOx8+Cca5ZPSbOa0FES9TP1kW/gn5LwOkx
	 tpRQqBrpXds/922JRtJdzw9T5wSCw4VfQ9nGjbSW0bqnzyyEctT1OPh7Sck+ALi+PI
	 gKfw892KIxltc1f+8EmsxeMBOQLAa8fawj9W0Zag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1414/2077] HID: core: Fix OOB read in hid_get_report for numbered reports
Date: Tue, 21 Jul 2026 17:18:07 +0200
Message-ID: <20260721152626.157539300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 41a79e43c82b32..cf123347a2af7b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2045,6 +2045,13 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
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



