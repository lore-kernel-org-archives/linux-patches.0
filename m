Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4163A2D8376;
	Tue, 21 Jul 2026 20:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666336; cv=none; b=o/6iTx7iSjJ3p2aLftCDuy/KqYakhBhTGnrHZ3vCWeH6lNDkiU7CFit4SCfL+qNe28ZvkacHN3CYVhlayGqTpt+/5njnI9r6Xj1m+uOShwFA4s0oqb3gyywhUTJPT72uk2C6G/N4x/9M7rgM+CHRMqznQKCSX8EBKjVzCBEZsCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666336; c=relaxed/simple;
	bh=lm64J2OEjAyOK0bG2c6jCZ2lJr/1h9KnRD7DtSPlDD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLOyF4JG8s39kYA//E7UjISxiPrMkVjpSH9qXtYrXctes/a764uD5kfI+G/+peFwE/fCa+ZibokYau67tFf108qsbD6Ums67ahpWGrhOwKGkRS+H27WiC4wnAGo1neTHQYuT7QcYOP0pKNnlw+Mreb/H/dA59yuIZ0AHqp6EY3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTmCr74k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTmCr74k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D381F000E9;
	Tue, 21 Jul 2026 20:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666335;
	bh=jAD+fzSOjDIVwEc5bS9WNGm9BkMaE6pZxZzpyW25fDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTmCr74kFa5gncu9dM+Tg0WlaIy1k6Y6EB99yVIKAl02R+6UvFvJYh+HSs1OPm57X
	 RYJtjrnxUdv0RMw+VLjvFXfVFxhAN/Zj6Fwn8MXTJL3ylmc5C/w3DADv/DKTQ8jncg
	 QOtGtJvV2kNA83ksEM358BE0LckmXrdStE6O81kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0601/1266] mfd: cs42l43: Sanity check firmware size
Date: Tue, 21 Jul 2026 17:17:18 +0200
Message-ID: <20260721152455.312851737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1cea3f8f467d43..c1f7b2cdb45b67 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -666,7 +666,7 @@ static void cs42l43_mcu_load_firmware(const struct firmware *firmware, void *con
 	unsigned int loadaddr, val;
 	int ret;
 
-	if (!firmware) {
+	if (!firmware || firmware->size < sizeof(*hdr)) {
 		dev_err(cs42l43->dev, "Failed to load firmware\n");
 		cs42l43->firmware_error = -ENODEV;
 		goto err;
-- 
2.53.0



