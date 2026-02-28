Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08E534250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301906; cv=none; b=oCljX4GRiqFu8cBCu9tZpGa/wQaxPllRKpRI8Q5l+ocrPUWm95Gc/ew0TfvGQmbYR5BF1AQDz1i7/b/63Gj8+xGXm+7kD18p+eFF0foDgQDXxp+xtJ6xoptsPuCHhKTNy0LBIlsjbN7CCqJe8m3gBDuDDIpqm3TJ7No0J4cVG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301906; c=relaxed/simple;
	bh=rA0Rtym4m0uF0k2RaeFUg8ByPTHlR0yoC0GVNeiSlpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJ+TVgqzCTc38ZcPO3PE71vFcKN5G1s8+FyOYrtrTXrqOnZ/c6xf8hXnWkAhOZQD71KgrKZWWsmEUfT75uWrwPqU+HCozoza7l/hblHQ5ue+0KIJSg3ePSAayY+fIFmKFpI6oClNTyA6z3hd4fkuTiAvrFq/zJsPyhcY+uAhIqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flkVO+cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flkVO+cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B92FC19425;
	Sat, 28 Feb 2026 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301905;
	bh=rA0Rtym4m0uF0k2RaeFUg8ByPTHlR0yoC0GVNeiSlpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flkVO+cNW0tGAMEY7uNdYQtBU5cY+Yn3PNqkdDaw2c5K9XMzPBxAdHCf4M7uR93oI
	 RZgcQ+7YHXk+6QBIQrBL9k20HsfahmPHA5UIbtoINe8+EbMsLR6LVkUbd9p0ijr4Q6
	 Hkql9cALVur+zwEESQfLw03ortMPgVcetwnFcl7jck6fz70HNLSiqV3QhAOhJ97xTE
	 Ykzl+n+DMdtQDOX5UdG9w66EvU1AIf3gKCw5oiwWKhVa8vm56DPWpYV7nCGtGUQav7
	 84HXEka/rfmt7gfTZYDX227LiY+Av+kbn/tnf5kgh21rw/EQA5mjVNTQG6QyXnTZ6h
	 96UTRldPbstvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/385] mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure
Date: Sat, 28 Feb 2026 12:59:18 -0500
Message-ID: <20260228180011.1568201-336-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

[ Upstream commit 4feb753ba6e5e5bbaba868b841a2db41c21e56fa ]

The wm5102_clear_write_sequencer() helper may return an error
and just return, bypassing the cleanup sequence and causing
regulators to remain enabled, leading to a resource leak.

Change the direct return to jump to the err_reset label to
properly free the resources.

Fixes: 1c1c6bba57f5 ("mfd: wm5102: Ensure we always boot the device fully")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251214145804.2037-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 85ff8717d8504..91975536d14d2 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1100,7 +1100,7 @@ int arizona_dev_init(struct arizona *arizona)
 		} else if (val & 0x01) {
 			ret = wm5102_clear_write_sequencer(arizona);
 			if (ret)
-				return ret;
+				goto err_reset;
 		}
 		break;
 	default:
-- 
2.51.0

