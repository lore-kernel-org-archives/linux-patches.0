Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33C23A562;
	Sat, 12 Sep 2026 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232324; cv=none; b=D8VY7jyzaOb1i3WygJEWObcMIN7QhFg18ToD7tzcL6zo+q6nDgcgnweR2f/UX8zVL060Lc7iD5QDgFgMYK8TNomEz/YUBzJ6D3MRo3DY2ThBbm4fKOBLK41jrIlFg5CJwp9jR9nkiqoD6JMOrNsiENM+Q7GWWeQ0mTfXplO02EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232324; c=relaxed/simple;
	bh=Y9D4j2f8xFFKKqnd820Hz/QMMIWkLdDbswqQBikr1Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxCxcOr4fu7dYxAPRfvOHHthHBzLXElmSoDbRERzl7yAqgJDuIegRJMGZ1Ib3h9J5abrJIXS0Qfi4lw0FdBZCF6f8z7B3KKe02ZzvNdTh8QnRc76/OYRHvt9U0ZXJobwdcNpSlCiG8vmtpHIVNF1xslHIfPV7mfozRR2IsEv4YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXTJUgh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXTJUgh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F25D1F000FF;
	Sat, 12 Sep 2026 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232323;
	bh=EkmWShMrnENBI/1JcIs1feNfnq/pBBr8SsZINiB702c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXTJUgh9xKpbR4vTmQSGFyQeJKe4lg0bregazf05bhadrKwc98OJRwZg0BcQZf3S7
	 fdGIl+CWkUSdpmz1RWu9oH2imxYDKpe9iUYSqO2FT/FhWgWZoDTtvGwf97jVVDQPyg
	 tnAA9aUG3+7i7R/UlzDswHjv1GZEJAYBlKYYtqCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1178/1191] HID: fix an error code in hid_check_device_match()
Date: Sat, 12 Sep 2026 09:05:06 +0200
Message-ID: <20260912065614.597066502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d02a9b1b1467a..61dde8e3fbb25 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2645,7 +2645,7 @@ static bool hid_check_device_match(struct hid_device *hdev,
 {
 	*id = hid_match_device(hdev, hdrv);
 	if (!*id)
-		return -ENODEV;
+		return false;
 
 	if (hdrv->match)
 		return hdrv->match(hdev, hid_ignore_special_drivers);
-- 
2.53.0



