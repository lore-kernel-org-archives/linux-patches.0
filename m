Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B029A1;
	Tue, 17 Feb 2026 20:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361228; cv=none; b=qFaC9jPrNLJx2P77pe+Jzt5w9mmEjy5Ye9Z3An7b0y+xQpSXKn1mjMD9V4w2IwYhNPAaOxbyuAaDe6+TuE1QpabpN9DUM6zYfWxyRjKQHhtu6ijtsJqLNiYPL+fbMi3w6BAqFa87Qut7aZm4mEJuTIi996pnegdNpovEJZNkxwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361228; c=relaxed/simple;
	bh=iRZEWnK/2nuJOegaqUKmDweo2w9uvex1ld/dCYQf/7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5bWDinB/Coh99pXXZq4zB4jXD3mejYe5rr+abyVFFyyYRCIHAzbKlv8mZOLY4iLIEr0iBvxWmogHS7cCkPfxC4Pnp1PN9P5MUd2LBU6/cd/OMNtEb8aeJo+P84tMeTCH5BbRHOqr4K4tJQNWsjaDeYTpyMnbt6lRmLBRxZB8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L38S8XlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L38S8XlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC136C4CEF7;
	Tue, 17 Feb 2026 20:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361228;
	bh=iRZEWnK/2nuJOegaqUKmDweo2w9uvex1ld/dCYQf/7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L38S8XlA060M8rD0YqJXKIYcTTng+5xFCVeA4QndzfVKrstysyhF+XK78gMAmQBg1
	 5BAogJ7bZkkKMPNwK1OFBQQKmdO5jdOnLYnuomsN4lBYc3WWXv6JHZmoMeNdcxEYLs
	 ZVEoxjq8UejTskhESq+lK58DwhRskGok+pyEUUig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/64] gpiolib: acpi: Fix gpio count with string references
Date: Tue, 17 Feb 2026 21:31:35 +0100
Message-ID: <20260217200008.971042069@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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
index 11338f47d884d..48c9935bedffb 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1383,6 +1383,7 @@ static int acpi_gpio_package_count(const union acpi_object *obj)
 	while (element < end) {
 		switch (element->type) {
 		case ACPI_TYPE_LOCAL_REFERENCE:
+		case ACPI_TYPE_STRING:
 			element += 3;
 			fallthrough;
 		case ACPI_TYPE_INTEGER:
-- 
2.51.0



