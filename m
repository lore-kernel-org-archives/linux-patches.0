Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BB9442B03;
	Mon, 17 Aug 2026 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975986; cv=none; b=ZmGHFFWgfSehNISA8pCHxeMkmrHAah8XiRw0/WYwqT+7QcvxhPUgNTqUqpFVWDrNiTFqkCVhNAZC/ih1s1hTD4vDvId18ZjikeFIjFAY/QlfBBKaTBPo+WvdRTnP/RqHW1pJtPDCRxa+Gm0VWYjwkfit7eeeumdmtXFtMSXY160=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975986; c=relaxed/simple;
	bh=eEkVLHrfZnJWeV7YlgDnaR9rc0gR8ZU3eukDASDHSyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eXJpmkcKgCoTeRiNv04KLLkZiyBjfT6CYqsURw0f+e81oMWQL914ib74D1lOmB9pvYsceSLUdYh3TQkWbsUOwPdfIJN/PSHT5zWfGrWtmZsf0N0tpasBgKhvcCztR1QR3hKkRztSrk6O9COpMeIfMrSRToZrqUdj/OjyCUmKBoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaYAt2tG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaYAt2tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76531F000E9;
	Mon, 17 Aug 2026 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975985;
	bh=KhxT7Clj5AWEhPfceh/X9V2CWdL5qXF/ohrs5ZQ56B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaYAt2tG0NMyUdb/bP9LWLgb33k/FIQ7ECLJNFL+1xV59nPxYPlH6bhJ1DG1vgE/D
	 xOOOiEJ5kTstVxPleu2WbJvsjDnoTK9T3tVFDfjlpvTqsOLrjYen92jAenxZL/sWFh
	 1yCy07P0PqRedWLHuMpSSfvg+jWIUrcdNXdcqzvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20Gerhart?= <gerhart@posteo.de>,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/389] hwmon: (nct6775-core) Prevent access to unsupported weight registers
Date: Mon, 17 Aug 2026 15:30:56 +0200
Message-ID: <20260817132547.681858478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d0b704e569ac3b8416d8e02270cdc9bf830ed395 ]

Sashiko reports:

During initialization of the nct6116 chip, the driver sets data->pwm_num
to 5. However, it assigns several NCT6106 register arrays (such as
NCT6106_REG_WEIGHT_DUTY_STEP, NCT6106_REG_WEIGHT_TEMP_SEL, and
NCT6106_REG_WEIGHT_TEMP_*) to data->REG_PWM and data->REG_WEIGHT_TEMP.
These arrays only contain 3 elements.

In nct6775_update_pwm(), the driver iterates up to data->pwm_num. If
data->has_pwm has bits 3 or 4 set (which is structurally possible for
nct6116), the loop attempts to read elements at index 3 and 4 from these
3-element arrays. This results in a global out-of-bounds read, which can
be caught by KASAN.

Furthermore, the driver uses these garbage out-of-bounds values as
hardware register addresses for subsequent read and write operations. This
leads to invalid hardware register access, potentially causing hardware
misconfiguration or system crashes.

The underlying problem is that the chip does support up to five fan
control channels, but only the first three support weight control.
Fix the problem by extending the affected weight register arrays with
zeroed fields. The driver uses zeroed register addresses to determine
if a register is supported or not, and skips accesses for unsupported
registers.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 29c7cb485b32 ("hwmon: (nct6775) Integrate new model nct6116")
Cc: Björn Gerhart <gerhart@posteo.de>
Cc: Florian Bezdeka <florian.bezdeka@siemens.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 71cfc1c5bd12e..5428b5b4043da 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -851,12 +851,12 @@ static const u16 NCT6106_REG_TOLERANCE_H[] = { 0x112, 0x122, 0x132 };
 
 static const u16 NCT6106_REG_TARGET[] = { 0x111, 0x121, 0x131 };
 
-static const u16 NCT6106_REG_WEIGHT_TEMP_SEL[] = { 0x168, 0x178, 0x188 };
-static const u16 NCT6106_REG_WEIGHT_TEMP_STEP[] = { 0x169, 0x179, 0x189 };
-static const u16 NCT6106_REG_WEIGHT_TEMP_STEP_TOL[] = { 0x16a, 0x17a, 0x18a };
-static const u16 NCT6106_REG_WEIGHT_DUTY_STEP[] = { 0x16b, 0x17b, 0x18b };
-static const u16 NCT6106_REG_WEIGHT_TEMP_BASE[] = { 0x16c, 0x17c, 0x18c };
-static const u16 NCT6106_REG_WEIGHT_DUTY_BASE[] = { 0x16d, 0x17d, 0x18d };
+static const u16 NCT6106_REG_WEIGHT_TEMP_SEL[] = { 0x168, 0x178, 0x188, 0, 0 };
+static const u16 NCT6106_REG_WEIGHT_TEMP_STEP[] = { 0x169, 0x179, 0x189, 0, 0 };
+static const u16 NCT6106_REG_WEIGHT_TEMP_STEP_TOL[] = { 0x16a, 0x17a, 0x18a, 0, 0 };
+static const u16 NCT6106_REG_WEIGHT_DUTY_STEP[] = { 0x16b, 0x17b, 0x18b, 0, 0 };
+static const u16 NCT6106_REG_WEIGHT_TEMP_BASE[] = { 0x16c, 0x17c, 0x18c, 0, 0 };
+static const u16 NCT6106_REG_WEIGHT_DUTY_BASE[] = { 0x16d, 0x17d, 0x18d, 0, 0 };
 
 static const u16 NCT6106_REG_AUTO_TEMP[] = { 0x160, 0x170, 0x180 };
 static const u16 NCT6106_REG_AUTO_PWM[] = { 0x164, 0x174, 0x184 };
-- 
2.53.0



