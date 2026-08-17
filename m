Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A452EFD9B;
	Mon, 17 Aug 2026 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979085; cv=none; b=f9Auchj1xPmSTfpl9It4S7kQrOuez/cKxMg4xB1l4wbxYw4nmhtordB9w/ehZszgvKBYyt2LI+rFy7BR+5Hv6ztGoTF+hqUps+F3dh/0Kh+Kj+zpFMG3Oq8stUDGTg6KOBjJkshIgzXJ8OdvvbIcLxQ6gc58wLGlzNjJQl9GrAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979085; c=relaxed/simple;
	bh=bSAfwi3Ii88+QN0VzLL7astuC3ddPurNyimh5IbDjQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQoSU9jxvEcx+ebHCYARhn4tjG01IgurXCV2CZSdBuUMyXlcY6KRBwx+wJDn7cWWgX8RQ69LUMWDlzNgyd342me6qTKw9RuUB5WNu0ravoYnN7NM3ZqWcBvKFHM8txYsR2NeVOKarNl2zcQhofAlSjxM8IWK+N7wm/aSCCs8j00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AproMNim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AproMNim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87381F000E9;
	Mon, 17 Aug 2026 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979084;
	bh=eT1+C2RA5436exS+CS/qFncV67skZ2H/tXk56htyrGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AproMNim34LYzXhyjTv05Jb0OMhG/zJ3EqwA12k3pjhRLwZJMn0slH5A0rOLf+upp
	 U/j/GFf7eQ7F2osIBNez3KvcHe93veRzYvEoR+cUf0F8UK4uccil4m+jPrJ1fezhAA
	 UlVr3S5ypv/1HQBYsaRiHRyTpwx0U3dDLKWwKyVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/609] hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop
Date: Mon, 17 Aug 2026 15:26:38 +0200
Message-ID: <20260817132547.123506102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 59d104b54b0b42e30fd2a68d24ee5c49dcc54d1e ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 53e68c20aeb1e ("hwmon: add driver for NZXT RGB&Fan Controller/Smart Device v2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index a8e72d8fd06050..02816538d18eb4 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -768,7 +768,7 @@ static int nzxt_smart2_hid_probe(struct hid_device *hdev,
 
 out_hw_close:
 	hid_hw_close(hdev);
-
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



