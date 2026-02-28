Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E4239B95C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302551; cv=none; b=eR7Ki8oOYUYpvSrasye/cqGaqg6L7KZuwIewHIJo0bzUBBvu9AWOzqZkyDrC5Lw78vYVL26AMFlVUBZQFcYLkBgXKlHvdBFVCXGWQXRIpKOLQEIsQLfWY53psIA/6lmAI5FgNnpQGtGR9NiTlZ4Quxvzg0QhGJVxyghieASxLPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302551; c=relaxed/simple;
	bh=ZHh/FGs0bMWT/D9+UJ1YLOJqnJ4U+hjV6iwmJXnS5ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbYnOlrYQtRxNbHVIKmuzz30BmtPMW8HlQPmpm8mBsYxFyfbMjbyyWUM+38pvIEhH0zH1IwyRqOrP/VpqN00a9Z5zd5Rp1EBON7Rxxy3HURa5crF6blxTz5XCM7BAPQ1zxIehoYC8t2FIRCD3E+nDMO2Jp37PCLM+i6XM4YUQjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLE5JkuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLE5JkuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7195AC19424;
	Sat, 28 Feb 2026 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302551;
	bh=ZHh/FGs0bMWT/D9+UJ1YLOJqnJ4U+hjV6iwmJXnS5ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLE5JkuQ3JecrUa2CmsUuygAibu0YgyBH1FiwtgliYe8Et+K1Tu9E4KRpiRT6f1/V
	 QqMBUJF8eAGpWa+VlELQMGzn8tiC5elK00KgzOWvbBl8LuCbA0QXslqLzPd5f3iOEG
	 PSvgQ9dMWSd7S8KEbhM0wVQGTifG+rgzFRdyw2SmQi9tdm9VRzYg01Y6fqthafFKZ8
	 pMFDoKbKRnEW+PS9QMgkZkBvE2DZq1l3rpZJXCseaDQOF+K5gcQgXn4EVg/6qcpbKn
	 uJrek9x42qAuSCFKIYz/jpHSdS8YnrC3ob7t8wkMinHdCQ44cv/SGNEBU15zizUT/G
	 OkkkcpVrm3dkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/164] HID: playstation: Add missing check for input_ff_create_memless
Date: Sat, 28 Feb 2026 13:13:13 -0500
Message-ID: <20260228181505.1600663-54-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit e6807641ac94e832988655a1c0e60ccc806b76dc ]

The ps_gamepad_create() function calls input_ff_create_memless()
without verifying its return value,  which can lead to incorrect
behavior or potential crashes when FF effects are triggered.

Add a check for the return value of input_ff_create_memless().

Fixes: 51151098d7ab ("HID: playstation: add DualSense classic rumble support.")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 69c16c9b8c5c9..5e4c329a43414 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -484,7 +484,9 @@ static struct input_dev *ps_gamepad_create(struct hid_device *hdev,
 #if IS_ENABLED(CONFIG_PLAYSTATION_FF)
 	if (play_effect) {
 		input_set_capability(gamepad, EV_FF, FF_RUMBLE);
-		input_ff_create_memless(gamepad, NULL, play_effect);
+		ret = input_ff_create_memless(gamepad, NULL, play_effect);
+		if (ret)
+			return ERR_PTR(ret);
 	}
 #endif
 
-- 
2.51.0

