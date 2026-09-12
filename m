Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218E9364049;
	Sat, 12 Sep 2026 08:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201621; cv=none; b=W6z4L+887RVNTdAJy88b3G4lZby+aEfB1r2ZyEnWEyT6U7NPaRzVb8GTVCGhvojaBeKZP9dZ333g/Q2DUhRRzgVnD/b53Rteo/YNGaP9D/mwVx6IAvQ7XMvZfPNcFZhJCE1f3eW+uVcyV0fe920WTYTd7v/JUH1nkREMOJyrlxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201621; c=relaxed/simple;
	bh=bzUdj5P9HY6byUnFjx/Ok55zNnToA/bajWCsRKX1bpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEOGGNGr7PsWQnVgslALDRKAp/nk2TFf4OKWaNOa+2X2Cw1wOEtodTS1g+dheSKLL5+VX6kpGngLrBQLXgYlPuerUhWyzJVoYA/sJWhb4hfw7wzG9lU84pu0dVzS6XJ5Ox2FmdNlau3eUrkl0T4uSbohLltX4nB1y7xBNKk4v5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZxRlYos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZxRlYos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242641F000FF;
	Sat, 12 Sep 2026 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201620;
	bh=ZCdyzt7sthFJtTgvv8GoJAnFCDBQ/+mstTHEh6M1gwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZxRlYosHC4ATn8fjwurtlcAzqXrrOwPDBb8wFp4RbVb4P8rmZYwhAk3udVBHeem6
	 DXgy+6J2/z+g9iQA52TV2Ra1iVJY+8506GouIOcGv7DT2q50byaHUWRClPPt/fRZtA
	 pqFwA64ZFtawyfxqP3HSs/IlcSEeKMzlRA5mPfhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1006/1815] HID: logitech-hidpp: Fix FF device cleanup on init failure
Date: Sat, 12 Sep 2026 08:45:56 +0200
Message-ID: <20260912065712.622975258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 90b0184df777f..fb2062233df22 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2861,18 +2861,19 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 	 * ownership to FF core
 	 */
 	data = kmemdup(data, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		error = -ENOMEM;
+		goto err_destroy_ff;
+	}
 	data->effect_ids = kzalloc_objs(int, num_slots);
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
@@ -2902,6 +2903,14 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
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



