Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E01A3CAE7F;
	Tue, 21 Jul 2026 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674042; cv=none; b=VajMgiVnpWy/XNl2wnmrDfFhbM5nv4G1fZMB+KxCUmaksGtxpxaDinCEZTJY141E84Yfg4nV2Artg4or81z8WBbhTltc9Bp3cXPjvtNVdvWHAXBAEFz6fFsQoToHCVn7N7ZSz2NkjCaUzjLkTpoQMCjObW0HoSjSegLWdqe/338=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674042; c=relaxed/simple;
	bh=2I1PXucVHLPmdhXOwQin1vQ1mw9lYs7dSigHeNFg0fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN6NHl9w7lnQ7vK4R6F3JRChTZ8uclWTK0tmT88X7ujCA+RIlCDfCPwhLAdb3ZXMFHGByboHptuilWfhCtVXK7U2pLhjL0IvxrQ2S8Ew3VtUJhcaXboLkm6Sm+9MM/LH01jhsYBQyeblJBNToE9nWZnJyzSGoNHsXrAiFrU/JX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WI6ufbQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WI6ufbQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737451F00A3A;
	Tue, 21 Jul 2026 22:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674041;
	bh=gW3WQynEnGRntxcTWgIkUBIgmp0m6tTaC113ax/SwaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WI6ufbQX3huEbMGaMUCwDyLt0oxh4FaGzKGLMszEr3XFLYkEX4felzDRTXPNdxtVR
	 pfpva7eyCYM9KlwgNYe6Bocmztz5XfebSl9l8S6zscWIz8cFNkDyhN7jBBkzOyvcsB
	 gsfo5Fepl6g8hlgenVR6v3GzUrOGOPO89wJxXDR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/699] HID: core: Fix OOB read in hid_get_report for numbered reports
Date: Tue, 21 Jul 2026 17:22:29 +0200
Message-ID: <20260721152404.489634027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 918c66d5bc93f6..5acb893ecff683 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1788,6 +1788,13 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data,
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



