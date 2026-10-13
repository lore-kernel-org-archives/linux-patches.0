Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCEA4FD7A7;
	Tue, 13 Oct 2026 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894778; cv=none; b=LvlJVfH6HyWbhlR4QDUpnwjk/n2P7O0QLT3xNUYLJZNhd3B0bb4pLQjqpFV36j2VedZBfj3ayx6fbUDbnUVEpF6SN0Uw4nJBxdIP0E4wK8dg4keb+3utX/naAoliiaEbYioq0s7FOgbBrpE1CYdqQYOOsettuWUiU3f010jIh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894778; c=relaxed/simple;
	bh=smkk2OrGXJMv86PuZtPIh6QdJ9Umu3YrtuprKfcyeVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5dBU3tpek1LIS9HsYA9okhOMqZZ9h6BhD2tkatOIXle2NbbF5N3Yf/Lsg9+RFH5Cz3hSuXInacW+qOs2dswqGNLTdh9Ss6IgkLOxciGFTRYiqv444zyVbPqQJSO+OwYo/Ibb98ryXZXYMjTV/Akeb5DXZHvU9X/iQEZxM040gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+cmlj6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+cmlj6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102F61F000FF;
	Tue, 13 Oct 2026 12:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894777;
	bh=pFIkrUyeO+hRM6wKyx48AbOjLdbL4XakpSD6NXJ+hzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+cmlj6nlSRxG0OqlNCbZJCg9VYzP0gWjzoRpoRyrG6PQxZA9ijBbkON0ecIdS83H
	 pmFSdj4iVstLyTn1Mxc+VZ1/hDOVtjDWDMSZ0EhHCtNXX/LtQDfXYxXsaaEQe6mbeM
	 dNpv7nrnwDkzkLuJcHdL2odaH5anoG+N6d6HoOro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/497] wifi: wfx: validate MIB read length before copying to caller
Date: Tue, 13 Oct 2026 13:33:41 +0200
Message-ID: <20261013112909.169297214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit ce67ebe9d8629776ce38e6995ae72fb903c828db ]

wfx_hif_read_mib() copies reply->length bytes from the firmware
response into the caller-provided buffer without checking that
reply->length does not exceed val_len. A firmware response with
a length field larger than expected overruns the caller buffer and
reads past the end of the reply allocation.

Replace the dead -ENOMEM check with an active validation that
reply->length fits within val_len before the memcpy.

Fixes: f95a29d40782 ("staging: wfx: add HIF commands helpers")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/hif_tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wireless/silabs/wfx/hif_tx.c
index 9f403d275cb13..9efb108bd877d 100644
--- a/drivers/net/wireless/silabs/wfx/hif_tx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
@@ -207,9 +207,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val, si
 		dev_warn(wdev->dev, "%s: confirmation mismatch request\n", __func__);
 		ret = -EIO;
 	}
-	if (ret == -ENOMEM)
+	if (!ret && le16_to_cpu(reply->length) > val_len) {
 		dev_err(wdev->dev, "buffer is too small to receive %s (%zu < %d)\n",
 			wfx_get_mib_name(mib_id), val_len, le16_to_cpu(reply->length));
+		ret = -EIO;
+	}
 	if (!ret)
 		memcpy(val, &reply->mib_data, le16_to_cpu(reply->length));
 	else
-- 
2.53.0



