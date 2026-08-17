Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5327D43747E;
	Mon, 17 Aug 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974957; cv=none; b=Uk92+aAYMRgFDuhm5D4YxSoIjadN0gzD9HOeb1U5cpejcJFXuWzdeYzYoa9prUx3NSillUG8GSHLN3hlrwMmg39FQS3YLfYJiOSY19vAgUgd1tfkVNX4UG7AOkPMuUhCLKMWKSIV+7+eOT4j4je+WKjAfaD7KEeqkGVJ8ArLYRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974957; c=relaxed/simple;
	bh=+Q245xrGp1GxCa1STXENSgDZviRGc7Oh0B7cPmFrr/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeF5WQcjTL9ODz2AG1R7ytOrvEiFSYw8MLLgeqIFpgXxnGeOMKGiWuUNAs1lkuThgIuFiQCDJmrUJDpciJFK9VNC33lGAh2xq9JW4uEV3+fHHJ/foqDo6RD0piMs7kROgUmb/LQsqYQiS3ecW7vL0PFc6kL5Pyg9Kfo75YtGvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWVlG9Hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWVlG9Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDBF1F00A3A;
	Mon, 17 Aug 2026 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974952;
	bh=I23Kb+6Q0TfI7ELOCN160AY7b9q0mwWTNBJrJuWWDhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWVlG9HvssOwPSTOAlM48kaBwKsdWgLreXs4d09MCMoUB9BzYQUxQ3n8yy/8Hpcii
	 6h4ALA1sT7O20vu4RSJEUcT1aVyMBJCMvalZbLjeBztbAeyGzA0vOqebS9jqvReElf
	 ulNhz+9PSEzctJklgtW5A4dBFDPYYhepanrjBfqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/250] hwmon: (ltc4282) Fix parsing adi,current-limit-sense-microvolt
Date: Mon, 17 Aug 2026 15:31:10 +0200
Message-ID: <20260817132541.017788864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 335698fd7f60b6707b21fda725f97f35fa956b07 ]

ltc4282_parse_dt() evaluates the wrong variable when parsing the current
limit.

When the adi,current-limit-sense-microvolt property is parsed into
st->vsense_max, the subsequent switch statement evaluates the unrelated
val variable instead of st->vsense_max:

drivers/hwmon/ltc4282.c:ltc4282_parse_dt() {
    ...
        ret = device_property_read_u32(dev, "adi,current-limit-sense-microvolt",
                                       &st->vsense_max);
        if (!ret) {
                int reg_val;

                switch (val) {
                case 12500:
                        reg_val = 0;
                        break;
    ...
}

Because val holds a small integer representing vin_mode (from 0 to 3), it
never matches any of the valid current limit cases.

This causes it to always fall through to the default error case, return
-EINVAL, and aborts probe initialization for any device tree using this
property.

Validate st->vsense_max instead to fix the problem.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: cbc29538dbf7d ("hwmon: Add driver for LTC4282")
Cc: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index b45a6e128d32e..269f96738f5b3 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1427,7 +1427,7 @@ static int ltc4282_setup(struct ltc4282_state *st, struct device *dev)
 	if (!ret) {
 		int reg_val;
 
-		switch (val) {
+		switch (st->vsense_max) {
 		case 12500:
 			reg_val = 0;
 			break;
-- 
2.53.0



