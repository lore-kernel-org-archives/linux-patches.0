Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155D7443A8E;
	Tue, 21 Jul 2026 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672641; cv=none; b=Rfu6wneUYHg4/kK49tBrsBgR+Zfu7EdsQ5Da70V41CtAlbBetNH8TqhuEoi/T3HI0P7jFqR8/233w6MUT+2c3yIPQL4wQjlSqH5Iapa40sdKfMWm/8G8xQ0gCS3/HnPjsnYaOAXyxBdzEQaCiJGhiWyof9M6ySmXUxK0/nyRQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672641; c=relaxed/simple;
	bh=TFtmXJ+HsyI6JIonV/wAk5ltZnHhU8xa2ZA7fKZaaKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+BOhyIQ4JZzX7O2YSqYKeMvI7A+IbacSzGjpFPZqX+4pZtDRF8TG2YWokG5XmpDWH6nic6+KQpRFrIZ+d3Xp5J3xZJ3VRn8pLnAa24XiBK0SH2I81U1tJjrRDkRLQ0jo3M+vW13bEV4F+5jrlf416KGoKABzPYdMQ4Ag6BBPkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTFwf+TF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTFwf+TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753E61F000E9;
	Tue, 21 Jul 2026 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672640;
	bh=ogtj0Oq+3M1PZZntr2IiIhQzrRe5AKMMBDBk5HcmS1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTFwf+TFJ1MwiHMOIj5tRXihzzcldaZ2hkRl2uFS87h2GBOMeTxZfrvyGyohcFFZc
	 O0bibKx/yOP7Pzv8awY6RgdCBQZ7qHPx0BWXOhPB0GYDf31ItPK7HQO61/daELPJWn
	 h0C0zqJdIhNH7e05vcnLX6TXTzNCczdD+rqpxg64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 701/843] hwmon: (asus_atk0110) Check package count before accessing element
Date: Tue, 21 Jul 2026 17:25:36 +0200
Message-ID: <20260721152421.818775647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


