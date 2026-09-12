Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCF437F75B;
	Sat, 12 Sep 2026 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240739; cv=none; b=QNWCVyzFxBniw5n/FkGtcbbNgh3OG5yAfyql6nfe0LivQzfW339qAx1chxmK3Q9EyEt7oQiF/2DRUOdysWAc5w+n1EyYHC9VrbSNu6J4w716RhJudHit7iQLnYrHp036aN29uUsXTVUc6RLWPd0f+mBupb7yd315vPTLN1vESzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240739; c=relaxed/simple;
	bh=P5GAq8qwFCAS0uC756CjgtmhmnGx2Aa3MTZq/DNq5Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEecnKFOxbGcvgdq+otNcYzRnsOQrdLdk4i/wLd5Zcn2yjI9QENDmxdq2Il+xqt9nXhE2QFrW8e4xrS7y1jZpuQgneOjamvj/sxyFIOsJ38BddFCY5qJg/FOxNlpjuPtPBlnAPdJ31BNz4w4es+CXUWwJ/LJA/+PCBxjpFBMGBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJu2nJRS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJu2nJRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C751F000FF;
	Sat, 12 Sep 2026 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240737;
	bh=9mEFPJJukLE5EEzK5QeRI2HDUDr1siShmsJ8slsuuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJu2nJRShWq47TWoGVdfn5tqC4x8USsGZcOxeK7y+K9POL9QUrIoUag2jHyiqgplm
	 b9VqkY9IZLd+hYV5Q4jSvQTVY9lLsZq8V7P8LMWHaStEAiJ+fHARco6rkzH/0vm0gT
	 R6A4BIjJFdujlWHU8CKNO1ivTQRo2NQ7IKAa5Fd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 929/935] HID: fix an error code in hid_check_device_match()
Date: Sat, 12 Sep 2026 09:05:59 +0200
Message-ID: <20260912065548.129620269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 89e756e3cc8d9c1ebc0f2b2f6912227073d93118 ]

The hid_check_device_match() returns true if we find a match and false
if we don't.  But here it returns -ENODEV which becomes true instead
of false.

Fixes: 207733f92661 ("HID: split apart hid_device_probe to make logic more apparent")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 07b4bda8e2c9c..783f55a259cd8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2322,7 +2322,7 @@ static bool hid_check_device_match(struct hid_device *hdev,
 {
 	*id = hid_match_device(hdev, hdrv);
 	if (!*id)
-		return -ENODEV;
+		return false;
 
 	if (hdrv->match)
 		return hdrv->match(hdev, hid_ignore_special_drivers);
-- 
2.53.0



