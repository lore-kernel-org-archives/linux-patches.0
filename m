Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811D3EDE57;
	Tue, 21 Jul 2026 19:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662329; cv=none; b=qHu05eGA8Vri3WUBTA8aIhFCBckwqlxHyPFVZ8/CCBtXcSLmyVAN3RgZslP0o5X5D8JQizT3WI/oFuBqfaGHhjlwc/NbjM5WTQga+EsQ4gzY4zoeaEVbVMdfJlhFha/Unz1b95QZjpwwGyg6K319bBxIjmZs8IhX5YQW4rHqo7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662329; c=relaxed/simple;
	bh=wBcS1BOTX06HZQ1YT2Mutzup8qHJiJqUP/OPidQW0Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWbXO6Up5TVF+HF55P+TDQdDCrCXEKV/z6LsL8zdz9kgyDTLOLNK9Bfi0q0TolrFE5UiTBxC5ILcS5sDMg17lV/VZWM94gJVC4fU25kCkbuV3Leoww5tVYrOMwRotI1ffRpfmzUyvH/qHI3N5ItGpEaTX3kUme5c/6SebG6wSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZwt9W5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZwt9W5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8321F000E9;
	Tue, 21 Jul 2026 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662328;
	bh=6u7uo13aZKu2wuMGbF4g9cwqyPvXwie0bJ/5Nz5jb5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZwt9W5tgg8LeTfbpuW1Ovv17FuAC0JvmV7zrXXaLI9wC/Ny/VGXI56RweVn7n0wI
	 Irkmd5dfQ3a6wjUruizTMHltDX8oXpm8CJYNVu1J4n5f7aFACqsyO+kQ9XnNE93ZQN
	 vU5AxD7LqfLXoCmzbHa39K5N9Eg7RWJ6YRD8A3fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0402/1276] mfd: cs42l43: Sanity check firmware size
Date: Tue, 21 Jul 2026 17:14:05 +0200
Message-ID: <20260721152455.096551903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit b6ef1a74b3ec254f87a6a3c554fe8f8083ebd37c ]

Currently the code checks if a firmware was received, however it does
not verify that the firmware size is larger than the firmware header. As
the firmware pointer is dereferenced as a pointer to the header
structure this could lead to an out of bounds memory access. Add the
missing check.

Fixes: ace6d1448138 ("mfd: cs42l43: Add support for cs42l43 core driver")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260508134804.1787461-1-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index ae8fd37afb7548..a3e4a61cf2c1f6 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -675,7 +675,7 @@ static void cs42l43_mcu_load_firmware(const struct firmware *firmware, void *con
 	unsigned int loadaddr, val;
 	int ret;
 
-	if (!firmware) {
+	if (!firmware || firmware->size < sizeof(*hdr)) {
 		dev_err(cs42l43->dev, "Failed to load firmware\n");
 		cs42l43->firmware_error = -ENODEV;
 		goto err;
-- 
2.53.0



