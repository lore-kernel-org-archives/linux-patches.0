Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9813783B5;
	Tue, 17 Feb 2026 20:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360805; cv=none; b=tS1C+K7jXEHYT6ccMDzDMDyR8oNdGYX9QFOXgqjDeB7zcuQ86nE63mf9S32KAXTIuwyhStidvXfRipRP1CYO7UPiAiJs/lNlEDGBoR/I5vbXBU+/u4CxvgUOQvxacQtFS+5dhKGgrRHXWVjtau8lU0jy2QpOqUjtDtiYv6+WHPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360805; c=relaxed/simple;
	bh=V4vP5lp6EmIChjwgDDZG0TmW30ilvthkOUMouLuejRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qspzGoj710/iFWd4G+nNdQSJZoxclKhZh30sgVbGq29NlHyvq4BKEKwmj1AZviWcPDy2wSYgOxm+y66/wpAdobtlLyTi6l0aTRM4vreWGa5OW1UkhQM9ejqvCZ+U7+aHP+zCnwBAYXNUh5ZPb7//wWcsFOCykCnRMUBCAeR5laE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSRWbbm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSRWbbm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07C8C4CEF7;
	Tue, 17 Feb 2026 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360804;
	bh=V4vP5lp6EmIChjwgDDZG0TmW30ilvthkOUMouLuejRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSRWbbm9KR236KZJgGuzSDsEYdCl+iAL4WGqGjO4w+V6M3ap8gPozJ2VAWoSPZlnu
	 6rt89rHsk70UNfUClxe6+Bt7jg8jSP9MLXr+Im11JAIs4K542se2NQ6kC5KTCoBkha
	 FKoVdkZWBeTWA6K3IH4tI+dedcc0sAe3mv3VOZwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 20/39] gpiolib: acpi: Fix gpio count with string references
Date: Tue, 17 Feb 2026 21:30:42 +0100
Message-ID: <20260217200004.994354546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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
index 69d4297ae5754..4d4757eac9e5f 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1417,6 +1417,7 @@ static int acpi_gpio_package_count(const union acpi_object *obj)
 	while (element < end) {
 		switch (element->type) {
 		case ACPI_TYPE_LOCAL_REFERENCE:
+		case ACPI_TYPE_STRING:
 			element += 3;
 			fallthrough;
 		case ACPI_TYPE_INTEGER:
-- 
2.51.0



