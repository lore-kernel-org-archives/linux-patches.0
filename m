Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E448A3CB2F6;
	Sat, 17 Oct 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260109; cv=none; b=dVHMQY1a2N3ffQ87aNrzngJYW44bj1hkBPdbEj+unFCTqnoP1urbqzMXFe2mZO4Au+xOtbfrl6QGMkwXtFgcehVGA5mjXvI9QEmO8RUSsapQKgbq+J8lGgw9jjpzu+Mdy1eJLSkbSj7bFBKwxzO7oeeXRKtbzKseNxRhw6y3JPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260109; c=relaxed/simple;
	bh=SpS62p15BOYRzKLtogbnGEsfi7Zn1Yj87m/gBOnVBUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjBOrpoygq6ADw8MSjrUCihpo6O3EXl0rEaDQnaOmSR+Xo2p9aP5+p0HL7oeygHk5rxJTdh+64cgp6+V5xNGOwx/kFYW5UI7y2wZghGbIOLuuVO96QILYkr/PX5iW4XARFurvHao0STOSa0pVeA10HVN4em+JdwXCbx8Jmerw0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEqGoIaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEqGoIaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3318D1F000C4;
	Sat, 17 Oct 2026 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260107;
	bh=Y0UsbM4rB1g6StOLWCEGRNf5gm+dY5R+k5qpbs9W1bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEqGoIaDl7MEXLED3MhcOs565SWMgEXK16ogfKMVYMu1aC68oGyrIrNMbn9fa71ZB
	 GH2SLWBdDeChkNmkZVXsxU9j9/jC0eJqIlTSjN8Cdhw5Ky0Gqc+4Z+cCsvGcGHE/QM
	 oaqFIqEV8e0yKK1bMdyL7qpywbuhshGDHpXzrgn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1436/1674] HID: logitech-hidpp: Fix FF device cleanup on init failure
Date: Sat, 17 Oct 2026 18:01:48 +0200
Message-ID: <20261017160508.041763983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit dd5be4d9ce2dfc4d4a4527ef7d31d21a78e3cdac ]

hidpp_ff_init() creates the input force-feedback device with
input_ff_create(), then allocates the HID++ FF private data,
effect ID array, and workqueue.

If any of those allocations fail after input_ff_create() succeeds,
the function returns an error without destroying the FF device.
Add an unwind path that frees the private allocations made by
hidpp_ff_init() and calls input_ff_destroy() for failures after
input_ff_create() succeeds.

Fixes: ff21a635dd1a ("HID: logitech-hidpp: Force feedback support for the Logitech G920")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 2d902a328189e..88b4027236cdf 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2879,18 +2879,19 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 	 * ownership to FF core
 	 */
 	data = kmemdup(data, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		error = -ENOMEM;
+		goto err_destroy_ff;
+	}
 	data->effect_ids = kcalloc(num_slots, sizeof(int), GFP_KERNEL);
 	if (!data->effect_ids) {
-		kfree(data);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_data;
 	}
 	data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
 	if (!data->wq) {
-		kfree(data->effect_ids);
-		kfree(data);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_effect_ids;
 	}
 
 	data->hidpp = hidpp;
@@ -2920,6 +2921,14 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 		 version);
 
 	return 0;
+
+err_free_effect_ids:
+	kfree(data->effect_ids);
+err_free_data:
+	kfree(data);
+err_destroy_ff:
+	input_ff_destroy(dev);
+	return error;
 }
 
 /* ************************************************************************** */
-- 
2.53.0



