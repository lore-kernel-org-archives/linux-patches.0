Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5E31DFE1;
	Thu, 13 Jun 2024 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282259; cv=none; b=MbpPn6XVgauj+06+MScYc+COOGZmkmrx7hO6erYhRmfXMuoxjKO053wq18mfP3DzRXNLmo+qbEsAwjMABgUZXDQVO9agvFv5zEhHhJ7ttLxCsbvDRJ8A4hYDqnHLn+WMrAvWT6A5A6sRscAjC5r7144+ArC2XBgXPABdsxndJVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282259; c=relaxed/simple;
	bh=aPAo7/7+Xf5W6dNWoaifJXihNksllSK/REEJXvC7s2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyyX+K0hl/h0gNZwauZIiwTfu6npdEJxlZKHCeHyu9ybpjqmjIfZX6qfGW0h2pFdEnTtm06H/hGYYxl0bcCXl6msJC8LJYl/+iKscCue2vIKR1GKRCLUWRpoRC38h50FhoVLhfkAQ411MXQAeXHTSDTAWlIEISUo2OGurs1d+ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6ZY8/It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6ZY8/It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9EBC2BBFC;
	Thu, 13 Jun 2024 12:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282258;
	bh=aPAo7/7+Xf5W6dNWoaifJXihNksllSK/REEJXvC7s2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6ZY8/It2YYGarx8/ABrNdJusQKoBQY/BSFwmg0JVqqlJkhD68r5Ml89ThMBLlTQg
	 bGdGbhTLGqKM+M/zn3j8M2oHBZKOtNyBNY9x/J3W6LHrRtVt3FIrYjpnhxjfGKfVkB
	 o8SkkFEPdSUWpdTZT0t72JMEgNSSTZj4d0bw8TuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/402] firmware: dmi-id: add a release callback function
Date: Thu, 13 Jun 2024 13:32:22 +0200
Message-ID: <20240613113309.364530618@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit cf770af5645a41a753c55a053fa1237105b0964a ]

dmi_class uses kfree() as the .release function, but that now causes
a warning with clang-16 as it violates control flow integrity (KCFI)
rules:

drivers/firmware/dmi-id.c:174:17: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
  174 |         .dev_release = (void(*)(struct device *)) kfree,

Add an explicit function to call kfree() instead.

Fixes: 4f5c791a850e ("DMI-based module autoloading")
Link: https://lore.kernel.org/lkml/20240213100238.456912-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi-id.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 940ddf916202a..77a8d43e65d3c 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -169,9 +169,14 @@ static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static void dmi_dev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
 static struct class dmi_class = {
 	.name = "dmi",
-	.dev_release = (void(*)(struct device *)) kfree,
+	.dev_release = dmi_dev_release,
 	.dev_uevent = dmi_dev_uevent,
 };
 
-- 
2.43.0



