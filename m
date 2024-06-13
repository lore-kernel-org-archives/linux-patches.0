Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FDF142E8E;
	Thu, 13 Jun 2024 11:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278853; cv=none; b=mY9+BQ9zT3r3KodXuXkbRepOBWMMbnAzFdtmEUel7HelTI6oCIR6lxgTy0NJ5bjVTCKuxWeOLC+1LgSaytDqvNRnR+MvNA/TeHv5zTIEiM1s/Fr3tv1QwjdtrOgow30V1oye6o+66pgem/dvZ8cxA0aHhG6iIgJTZ+ULPpCSt7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278853; c=relaxed/simple;
	bh=qxBOAhKZDcaiXuvFhgd+HBMo30x5HTK+jkoaXziy/jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE1kUdinbYm/XSGFR58WiHqNIKILcyiCyCEu78MeUIdRngMi2KModZGVazs5/k0HVJWpGSAU6f60C9SCWySU00BbkEWSQMuUUUKJv7fnhWYL+AcDC27tB50DdQUkNxAHsk3vn8sAnhXjTttIXEiP+gQFwZIM/ZYIVKFj04kFOLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iksX82/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iksX82/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A3BC2BBFC;
	Thu, 13 Jun 2024 11:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278852;
	bh=qxBOAhKZDcaiXuvFhgd+HBMo30x5HTK+jkoaXziy/jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iksX82/xKYU+K7t1++qyzvXq++xTcdKYTT58+N92+Rjgjsd5EebspFCr+Pa2k90uI
	 Pj5Rv+hyznd+jUFJelCcNg4tJy8d1peMA1jJwxz3z22Y86hADRzTjQB4JWzG1JxkWW
	 l2u0JU+eAUu7509a9MZQI7htTey1KuRsWjR3fqfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/213] firmware: dmi-id: add a release callback function
Date: Thu, 13 Jun 2024 13:32:20 +0200
Message-ID: <20240613113231.557119178@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 624a11cb07e23..3ddff56fec995 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -161,9 +161,14 @@ static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
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



