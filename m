Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A101FCCEA;
	Wed,  5 Feb 2025 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767317; cv=none; b=lS/dWRQVO+pMiZB4twwFruzsj9vA6QuuXNFQLUZ6c47GAtFU0wSKK++w9gWBL8EY+ni3jub++ue1RjZ2ivaMuw/yjkJWsOrknQzjWDF/eN3xe/9jS+i0CslsMXllZ2erTlGddx5V5Wkre6ynwWiDmol3Q6QdgUtkaCH4beCVjN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767317; c=relaxed/simple;
	bh=TbMUCxTID7qo0UZ9hktS/x6g0XfWS/1xVtJb86Qggt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3vDn6DqzrQC4SgKpPB31LnBrw6PreqlMVu3KRkAPxYwxGLAxjMRj6NomOi2d+Gc6IXUNO06vzpinWVTm8nB61CxGjeBJymmr8LGxkpVLcLJTbQO7ARyohf7Wua7OwQiJEvFMRYLQq1F4PwWSHYqOsyC2LpmhVaLE/DIHhtnEgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNK+JgXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNK+JgXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9016EC4CED1;
	Wed,  5 Feb 2025 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767316;
	bh=TbMUCxTID7qo0UZ9hktS/x6g0XfWS/1xVtJb86Qggt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNK+JgXFyruTbY7AQJx74+ecXv5wYi7fLamxItcBeinhQ1vPPW5QrixDfUNYEFboa
	 rWgEPCiPiQVDHug/Yy9pfdVq+pPrFECFzBQZqbo11+ynKd2R/HkB8vslqU9vYE3CTB
	 ++/r+ogI7lipL97GSWrnapbS++JeUiubCBKf9DhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/590] firewire: test: Fix potential null dereference in firewire kunit test
Date: Wed,  5 Feb 2025 14:43:13 +0100
Message-ID: <20250205134512.025094995@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



