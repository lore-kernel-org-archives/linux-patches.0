Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CB41F26E3;
	Tue, 12 Nov 2024 10:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406967; cv=none; b=QZz4xAdiClIa6zlg2K0TzHa5bkkSHk2RUomKs6cxxGpo9KnRYvTsaVx0B3v72FgRDNB4YVYOe3yIE1stQq+VaX/DtgwbwH6BSYzLHs5UB2iv9MSnyba+4BuNor0SWQHylWBmLqBKiMJjVJ/4lnYHOCNuX9qq0knK7EVWJ98/ZTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406967; c=relaxed/simple;
	bh=57femVrZ83SA65T1WnLOjKWW2/rcWUSd4W2061L8Cvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmI3xkRx8SMskcPfTmO4rP2qLOPEOPtUDthqWVgaowGQGIE1KvbOYlkwZeRTDGhJO26KSdLeSERiBJ7jlktl86FQWcqfl7gZLDPDQQNX0uwXUUz8/Uyi+86+c5sNAOjgg2rgJa97I1VREylK5LeWEUo7R2ov/3h6DGUvWfgOni8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkB3B4q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkB3B4q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28246C4CECD;
	Tue, 12 Nov 2024 10:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731406966;
	bh=57femVrZ83SA65T1WnLOjKWW2/rcWUSd4W2061L8Cvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkB3B4q9A/u1s1tBeN+1HegABOHXytoGF5V3v5SPCViu7x2mb/sVwV0uA3C3X6xpm
	 WOUCca0v3T9tjhzk9ffexprz36vPBFQ23RzaKzbGdbewdRmMtDKD878ji58VAH4xQ6
	 5yOLBLLPezOt9Dv8hhRPXX41dNPDACv659EoGHTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/76] HID: core: zero-initialize the report buffer
Date: Tue, 12 Nov 2024 11:20:36 +0100
Message-ID: <20241112101840.212437609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 177f25d1292c7e16e1199b39c85480f7f8815552 ]

Since the report buffer is used by all kinds of drivers in various ways, let's
zero-initialize it during allocation to make sure that it can't be ever used
to leak kernel memory via specially-crafted report.

Fixes: 27ce405039bf ("HID: fix data access in implement()")
Reported-by: Benoît Sevens <bsevens@google.com>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 15f4a80477974..07c2e5e38fcba 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1664,7 +1664,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 
 	u32 len = hid_report_len(report) + 7;
 
-	return kmalloc(len, flags);
+	return kzalloc(len, flags);
 }
 EXPORT_SYMBOL_GPL(hid_alloc_report_buf);
 
-- 
2.43.0



