Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC781519BF;
	Wed,  5 Feb 2025 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767947; cv=none; b=jGAhsxT+LPOlHTTO+8i56Q+sc56F6PcKzSKx7eJeME0As0cIXtth8n3Z41W8DYqs5+71XaxtljgfVG3lHGWLIJIBaPwjJvxsnMMS0LE5Ic9yLtM1FgcC8ILT5b6rnixHuKt9Upw2ZtuVrkzfbL4a63jKrDuyWpcEc+ie3ZhJrxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767947; c=relaxed/simple;
	bh=C2snTC4lQN5SSj1FJlC9sw9eY5O8TZuvAzJFj6nihvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx0hnLeWAaZO9AsP2ELXWXUG7rOcGU7GR0u4jVIeuZP8qu0IuHpgw5MNsikWGKFRu5fP4MgVNYey3jjG92zVrotwRf+9MOB1EYGqYalujui1zJAZX9o2MWMzPwms+D1CMvNi1nm/K+ZsDXFr2qOEbLvHaE9ATffwEAHvbmAMnx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1CoaBJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1CoaBJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECDBC4CEE2;
	Wed,  5 Feb 2025 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767947;
	bh=C2snTC4lQN5SSj1FJlC9sw9eY5O8TZuvAzJFj6nihvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1CoaBJShqPJkfj8CKiELoEIeWFBagrzphl82EL95/1hLJMaXnQPhnMdVquSgi5dy
	 ZfpBKhihdpnR0NzWdA4u2x+l7eEivTB/ho6a5H1ZHYmMh63OUIi19c9x+kMGZuu3wH
	 fREhqbk84AzaTcnIxYOZbcRkbVsH5Yb6oW294oJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 476/623] firewire: test: Fix potential null dereference in firewire kunit test
Date: Wed,  5 Feb 2025 14:43:38 +0100
Message-ID: <20250205134514.427771902@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 352fafe97784e81a10a7c74bd508f71a19b53c2a ]

kunit_kzalloc() may return a NULL pointer, dereferencing it without
NULL check may lead to NULL dereference.
Add a NULL check for test_state.

Fixes: 1c8506d62624 ("firewire: test: add test of device attributes for simple AV/C device")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20250110084237.8877-1-hanchunchao@inspur.com
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/device-attribute-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firewire/device-attribute-test.c b/drivers/firewire/device-attribute-test.c
index 2f123c6b0a165..97478a96d1c96 100644
--- a/drivers/firewire/device-attribute-test.c
+++ b/drivers/firewire/device-attribute-test.c
@@ -99,6 +99,7 @@ static void device_attr_simple_avc(struct kunit *test)
 	struct device *unit0_dev = (struct device *)&unit0.device;
 	static const int unit0_expected_ids[] = {0x00ffffff, 0x00ffffff, 0x0000a02d, 0x00010001};
 	char *buf = kunit_kzalloc(test, PAGE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
 	int ids[4] = {0, 0, 0, 0};
 
 	// Ensure associations for node and unit devices.
@@ -180,6 +181,7 @@ static void device_attr_legacy_avc(struct kunit *test)
 	struct device *unit0_dev = (struct device *)&unit0.device;
 	static const int unit0_expected_ids[] = {0x00012345, 0x00fedcba, 0x00abcdef, 0x00543210};
 	char *buf = kunit_kzalloc(test, PAGE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
 	int ids[4] = {0, 0, 0, 0};
 
 	// Ensure associations for node and unit devices.
-- 
2.39.5



