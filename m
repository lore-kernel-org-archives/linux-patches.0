Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E431C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C546C433C1;
	Wed, 23 Nov 2022 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196422;
	bh=GBvxC92X5aZMOeIL3/LdoqGdqXcHCSF6AmwTzSf1DqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/Zz9SvZVwlAawB1hZ7vyrN2awI1Y2YTgLY68FbJgisaFhFU7cfe/0fD6WiJ7tNu3
	 QY5YQ1ZUE1I+cktBQ2OU2OXqXHDOTPc030YJA7S3Ynt9ebdjiegdqCEYx959/IVR0J
	 qrczvySUPDD/3MRIV8YErY6uQl/8OUVDIy7i9Gjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jelle van der Waa <jvanderwaa@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/314] platform/x86: thinkpad_acpi: Fix reporting a non present second fan on some models
Date: Wed, 23 Nov 2022 09:47:51 +0100
Message-Id: <20221123084626.685018340@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jelle van der Waa <jvanderwaa@redhat.com>

[ Upstream commit a10d50983f7befe85acf95ea7dbf6ba9187c2d70 ]

thinkpad_acpi was reporting 2 fans on a ThinkPad T14s gen 1, even though
the laptop has only 1 fan.

The second, not present fan always reads 65535 (-1 in 16 bit signed),
ignore fans which report 65535 to avoid reporting the non present fan.

Signed-off-by: Jelle van der Waa <jvanderwaa@redhat.com>
Link: https://lore.kernel.org/r/20221019194751.5392-1-jvanderwaa@redhat.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2dbb9fc011a7..353507d18e11 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -263,6 +263,8 @@ enum tpacpi_hkey_event_t {
 #define TPACPI_DBG_BRGHT	0x0020
 #define TPACPI_DBG_MIXER	0x0040
 
+#define FAN_NOT_PRESENT		65535
+
 #define strlencmp(a, b) (strncmp((a), (b), strlen(b)))
 
 
@@ -8876,7 +8878,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 			/* Try and probe the 2nd fan */
 			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
-			if (res >= 0) {
+			if (res >= 0 && speed != FAN_NOT_PRESENT) {
 				/* It responded - so let's assume it's there */
 				tp_features.second_fan = 1;
 				tp_features.second_fan_ctl = 1;
-- 
2.35.1



