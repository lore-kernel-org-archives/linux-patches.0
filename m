Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38E39B97E;
	Tue, 21 Jul 2026 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670054; cv=none; b=bLHHLreVJdSTEeSsyp9bNbP8EkBL2WVKmb3AAwFkiNfS2Jo4ZX79vK/T3wufDCZnKSHpCcHcNcKPKZnN9qJJd+KSblmo47TG9GfY+3BoytEILGzhHBBTLUuFY4MwV55RYczoc3Z2i/REL95uKHK9lWb3I4ZQ+6W5UoGjxBnkUTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670054; c=relaxed/simple;
	bh=+au4wdYwwojVWhlSJvRkn4u7zQl6SIv0doXp8vJpPkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+8Pcnt2Z3DHq7yeyhfh0OlozkiYN/QusZdlSnOmEfFOWW2JzmdnTnqMckOG1K5Sfm2E9htWgh7jS/yeUrXKcRMniMPSsOCw5/5Q8NIebqWe+utv3j4CKbPbVhAANUFovt5oo/vHToVbig97RF61PRLOadWFnEkMB59pV0a+gps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0Jw1i7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0Jw1i7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506BE1F000E9;
	Tue, 21 Jul 2026 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670052;
	bh=XXmIrgVbW6zpFcH+6Vq6WecGnLScbFyvjAMow4C/wTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0Jw1i7+ItJZhH2Xv/wIzQDYlOv4sKZ2wOOBSvuXyAdnePLHIK8OlBEVpgfmd6sOi
	 ilMu0aVDjbLSibVGIRy2A4v04gJaah3w8jgCzcczTV1Eymna10xfZ2gWqsdoCi11mz
	 toAFD7fQAXE/3EyUHJHX2cPFDx5M8ijzJXmdCnXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 0785/1067] power: supply: cpcap-battery: Fix missing nvmem_device_put() causing reference leak
Date: Tue, 21 Jul 2026 17:23:06 +0200
Message-ID: <20260721152442.129559104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit a2c14ff63e0e02e3c832385e523e9cc81301171c upstream.

In cpcap_battery_detect_battery_type(), the reference to an nvmem
device obtained via nvmem_device_find() is not released with
nvmem_device_put() on the success or read-failure paths, causing a
permanent reference leak. The driver’s retry logic on subsequent
battery property reads can compound this leak, preventing the nvmem
device from ever being freed.

Found by code review.

Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Cc: stable@vger.kernel.org
Fixes: fd46821e85de ("power: supply: cpcap-battery: Add battery type auto detection for mapphone devices")
Link: https://patch.msgid.link/20260424011013.879639-1-make24@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cpcap-battery.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -415,10 +415,13 @@ static void cpcap_battery_detect_battery
 	if (IS_ERR_OR_NULL(nvmem)) {
 		ddata->check_nvmem = true;
 		dev_info_once(ddata->dev, "Can not find battery nvmem device. Assuming generic lipo battery\n");
-	} else if (nvmem_device_read(nvmem, 2, 1, &battery_id) < 0) {
-		battery_id = 0;
-		ddata->check_nvmem = true;
-		dev_warn(ddata->dev, "Can not read battery nvmem device. Assuming generic lipo battery\n");
+	} else {
+		if (nvmem_device_read(nvmem, 2, 1, &battery_id) < 0) {
+			battery_id = 0;
+			ddata->check_nvmem = true;
+			dev_warn(ddata->dev, "Can not read battery nvmem device. Assuming generic lipo battery\n");
+		}
+		nvmem_device_put(nvmem);
 	}
 
 	switch (battery_id) {


