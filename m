Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CA471264;
	Tue, 21 Jul 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659238; cv=none; b=ZlIzQK3WNKQXA3eidcNDc091XYmMwAp27y0QdqjSIbFVkZeeM3F/2nexhZs7DlQ8bTVOrgiwDyZNU+em+qcnM8YTuWpt9v/HaOHzZLH60v9LDTgZmaupi1lXRwEQQOwEY0dIp67iukoBK4dfS0uJu1dVc2pboGi0EQ3YGmZkiSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659238; c=relaxed/simple;
	bh=HztoFw50FK1okKDpjkqzp3dn/1j4FjAvR0WPoasUtwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNI1/X2FAiRN8UW+wahWq9arIFVVry2KpxGrtaR1z7TTvXQzof1iAMhdocjiS/eboNGy0qL6QvrPozwXM7onQPnnbGguTa9V9J2lKZcTdpfU2xOaSKaIbyf1TihwQzRFAJPm5HnMTi+OvoW3M5y2T3jh7N0j4z2nbLcvUzy6JYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJPArbfS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJPArbfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D31F000E9;
	Tue, 21 Jul 2026 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659237;
	bh=Pn3SZeTwR9B5eTU1TYd3CHdWZUq40yJNEULGFBgSDxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJPArbfSsSsNcvdZbOsrdT7E6q+ljPRSkXSl8+4auLHFGK+a0Lh3WSNwxdsBIuUdT
	 k8bCaxhvMiGkLwdnjv5clsQaZFJ1Rl0mGKmXRE45ulWD5f9FiaBiVycN1N19df/F6g
	 h8dgQ1zUbqlnXX6fcYsh6yUUB4GCADzAUTYWksIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1446/1611] hwmon: (asus_atk0110) Check package count before accessing element
Date: Tue, 21 Jul 2026 17:26:02 +0200
Message-ID: <20260721152547.975189860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit e2735b39f044bad7bf2017aef248935525bc0b97 upstream.

atk_ec_present() walks the management group package returned by the GGRP
ACPI method and, for each sub-package, reads its first element:

	id = &obj->package.elements[0];
	if (id->type != ACPI_TYPE_INTEGER)

without checking that the sub-package is non-empty.  ACPICA allocates the
element array with exactly package.count entries, so for a sub-package
with a zero count this reads past the allocation.

The sibling function atk_debugfs_ggrp_open() performs the same access but
skips empty packages with a package.count check first.  Add the same
check to atk_ec_present() so a malformed firmware package cannot trigger
an out-of-bounds read.

Fixes: 9e6eba610c2e ("hwmon: (asus_atk0110) Enable the EC")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://lore.kernel.org/r/20260619122746.721981-1-sammiee5311@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/asus_atk0110.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -1037,6 +1037,9 @@ static int atk_ec_present(struct atk_dat
 		if (obj->type != ACPI_TYPE_PACKAGE)
 			continue;
 
+		if (!obj->package.count)
+			continue;
+
 		id = &obj->package.elements[0];
 		if (id->type != ACPI_TYPE_INTEGER)
 			continue;


