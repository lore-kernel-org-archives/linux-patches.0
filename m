Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B35A1BBBC4;
	Mon, 14 Oct 2024 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917768; cv=none; b=PlKUUPnJ8ORxIAQOFn4mlX8F34QIg+vQn+H6tEjssAXRn2wf4OOZAEMqUMZzHlneiIltR+LDv4BI7tA+ooDVt+AQEOwlRq2j51cD3u5/GU47JaCcwouXk0MUfvvv/ZQwWTHFpJ9SD6O4PTnHLq0B7gBlQ0jKIf/ohKeUwz494QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917768; c=relaxed/simple;
	bh=HXvJiyYouBOhAR+fCJNi0JmWjAr5/1MQOjiqxsy36t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxRSmIN2LTesnBcIVoZdKxDHVDP8B5ARag2n99nzigtvCLmd80GzPLhOAdkUkvGV5+QrpzN2LTYw51jtaECJgmZLhhyWeAzHRECLQATU5UHQBDlwcL2YHzSEIz7E64CCRavPg/bZEGHuxf2XQzUBWu/t6vWNVtBSyCxpmBAwBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/W4Nwvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/W4Nwvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D24C4CEC3;
	Mon, 14 Oct 2024 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917767;
	bh=HXvJiyYouBOhAR+fCJNi0JmWjAr5/1MQOjiqxsy36t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/W4NwvfpMKlTWqm0amf0ExbpVFexJB7nkQ2ULbIa96kZY24THCWT4sROVyStkO4A
	 aaXM/mSg5LQJfnXHXy3KM2NuVd6lu6Y1YcMtPzKFogeJ8lofqEiERObm9TgUZH+umh
	 71iiftMnFnzHHF+8os6CQRsV3Krwoyi760UEDhHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/798] hwmon: (max16065) Fix overflows seen when writing limits
Date: Mon, 14 Oct 2024 16:10:41 +0200
Message-ID: <20241014141221.350505236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 744ec4477b11c42e2c8de9eb8364675ae7a0bd81 ]

Writing large limits resulted in overflows as reported by module tests.

in0_lcrit: Suspected overflow: [max=5538, read 0, written 2147483647]
in0_crit: Suspected overflow: [max=5538, read 0, written 2147483647]
in0_min: Suspected overflow: [max=5538, read 0, written 2147483647]

Fix the problem by clamping prior to multiplications and the use of
DIV_ROUND_CLOSEST, and by using consistent variable types.

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compatibles")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max16065.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index daa5d8af1e69d..0d938161595dd 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -114,9 +114,10 @@ static inline int LIMIT_TO_MV(int limit, int range)
 	return limit * range / 256;
 }
 
-static inline int MV_TO_LIMIT(int mv, int range)
+static inline int MV_TO_LIMIT(unsigned long mv, int range)
 {
-	return clamp_val(DIV_ROUND_CLOSEST(mv * 256, range), 0, 255);
+	mv = clamp_val(mv, 0, ULONG_MAX / 256);
+	return DIV_ROUND_CLOSEST(clamp_val(mv * 256, 0, range * 255), range);
 }
 
 static inline int ADC_TO_CURR(int adc, int gain)
-- 
2.43.0



