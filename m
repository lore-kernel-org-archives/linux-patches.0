Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC247581D;
	Tue, 10 Sep 2024 10:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964338; cv=none; b=Tc8Suv5WJNzTOsDsvOHgiedDEn6MnHXJOb3Wcd0ckcFuIIGaWUAYcUkXmGTGa7sDomZj2GJGZQHCLBHY52+ecPH2u8JIJkbxfWt/qegbNSfB/4r/cmEGY1NZVi2Z4bm2T8kjK0Jzr3yh1jHOkzPT2Og0qzaLbnCREVd0jdVMg8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964338; c=relaxed/simple;
	bh=dehxKEjuFZGAZDeWeqAZvu4TSCe/fxvO60R0+u5T3Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ghNOZf3q8IwYhc8H5p96Dpx7g1ZXi2dsXiJ/r3KdXiftObQ1nm3ROmy+NfTuxZgdOuwllzTVTjAYRhK+yi5ZQm/mWUtIQWXFfRVTEbkjHIzHx305APWQea1IG9UgWqbbz06BsPvi+bKnoI0IE4hipo+CsyLiRsHXl5k9jmtwPA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I53HlgQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I53HlgQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949E4C4CEC6;
	Tue, 10 Sep 2024 10:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964338;
	bh=dehxKEjuFZGAZDeWeqAZvu4TSCe/fxvO60R0+u5T3Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I53HlgQAuyaEBDPg8dQEATA3GsFRhM356lki7R+QyjlNfm0/n7pVRdNR6aV9tzULl
	 oyDsuRWkhnA4nS8J0eynMVglOM3ICidC3ViFSht3LSxsPDrphDSa42nAnHYUVvfahS
	 5DJhkYoy1mCs6o8iQ+qgqwyvaSHRX8tPxpPzqP90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/269] hwmon: (hp-wmi-sensors) Check if WMI event data exists
Date: Tue, 10 Sep 2024 11:31:48 +0200
Message-ID: <20240910092612.488468032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit a54da9df75cd1b4b5028f6c60f9a211532680585 ]

The BIOS can choose to return no event data in response to a
WMI event, so the ACPI object passed to the WMI notify handler
can be NULL.

Check for such a situation and ignore the event in such a case.

Fixes: 23902f98f8d4 ("hwmon: add HP WMI Sensors driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Message-ID: <20240901031055.3030-2-W_Armin@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hp-wmi-sensors.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/hp-wmi-sensors.c b/drivers/hwmon/hp-wmi-sensors.c
index b5325d0e72b9..dfa1d6926dea 100644
--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -1637,6 +1637,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		goto out_unlock;
 
 	wobj = out.pointer;
+	if (!wobj)
+		goto out_unlock;
 
 	err = populate_event_from_wobj(dev, &event, wobj);
 	if (err) {
-- 
2.43.0



