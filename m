Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FF9377556;
	Tue, 17 Feb 2026 20:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360915; cv=none; b=HSv+itjZ9jFjSUkVoEGTPnw/MJ6I1hjJXZ+z4HH54XN+aeAAKyY00+fygQF/vGIp60Vqlypiy93s09jp/p7BN8e1Kg5n+1o7Zi/sD3HSZFkZuHVl4ZZt0f9883MSnMNCXpWGZIrLiiSv/FHfrIAWAsH+Lz3RUPwJeo/pGycm6Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360915; c=relaxed/simple;
	bh=cdaciZMdQzS2K+fJg9L+2ZQPTjsULQ4B4oAvF0v0wH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRSgcvrAPVLYJMs0GxEF93e7mmx7aKVwBMQ7KdfdJ26K5c2neow24cDyF9PBCn+Bfx6PPCG3Ua07uNTXAsEZx1XcmI6j8mP9TYMHWTffYU/1oQ2FI79id2q13DiRWaaNtSsuAdaJcMwlS5M/ewp3HvrdZ1Dcrw1O2+UL3KfGruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKz6Lvw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKz6Lvw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C12C4CEF7;
	Tue, 17 Feb 2026 20:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360915;
	bh=cdaciZMdQzS2K+fJg9L+2ZQPTjsULQ4B4oAvF0v0wH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKz6Lvw4S+VD/klJGfLbvUzpLHKq8wKo5JEPGZauYUukiLCuMUyXCtM8HkZPPaRoJ
	 SG8tQXTpWtERVZx+GbUk02YwvJvNeP3KvISK7KM1xno98wCtl4u2BubaFj2+atFz4K
	 AlVa0dnaG9eyoRScInX2UCwMYO8IhDWKs8TWin8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/24] gpiolib: acpi: Fix gpio count with string references
Date: Tue, 17 Feb 2026 21:31:26 +0100
Message-ID: <20260217200001.219740726@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit c62e0658d458d8f100445445c3ddb106f3824a45 ]

Since commit 9880702d123f2 ("ACPI: property: Support using strings in
reference properties") it is possible to use strings instead of local
references. This work fine with single GPIO but not with arrays as
acpi_gpio_package_count() didn't handle this case. Update it to handle
strings like local references to cover this case as well.

Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260129145944.3372777-1-alban.bedel@lht.dlh.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 12012e1645d7b..f03a7199fd58e 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1276,6 +1276,7 @@ static int acpi_gpio_package_count(const union acpi_object *obj)
 	while (element < end) {
 		switch (element->type) {
 		case ACPI_TYPE_LOCAL_REFERENCE:
+		case ACPI_TYPE_STRING:
 			element += 3;
 			fallthrough;
 		case ACPI_TYPE_INTEGER:
-- 
2.51.0



