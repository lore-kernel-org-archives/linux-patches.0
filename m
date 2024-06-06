Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C544D196DA2;
	Thu,  6 Jun 2024 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682901; cv=none; b=ITvMs9DuaLbC3YQgiBMZKAYiAJjxx3Ys4Uvr2bjzvCw7rrpChnVvLppI7ocKb88xQoyPLFglMCh3AP3yCcsVFb8AjG/ekr0v9ru1hvnPkJe85ryKOt8p+R1ltFVUHhOhDG/1s2cSZXGQgu0ydLHiEkv8ntaYYdIaiNwWXwFCsps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682901; c=relaxed/simple;
	bh=NV9H+NQTIFbEcRVW4/75hCKJ1uUg1aFmAHc0EDupkJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR6oN1yilBaxPKR7fGWeP3NjlhW0VVQVLDf8IZVPFxRH0vprMwgHJ9XI8bPs/J262Tb/IY6HzK9g7KxvbA8YmSphhL06T9Pzd6LLwXQHjDAZd+ITUuc2VrBoU/V4c01VvBwUM+p+HegiCS4fx3+ctoqnshwH732ughq7A1+o0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlkliNdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlkliNdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C009C32781;
	Thu,  6 Jun 2024 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682901;
	bh=NV9H+NQTIFbEcRVW4/75hCKJ1uUg1aFmAHc0EDupkJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlkliNdVFOhLNOENZ3mBLyKJidfa2fJmCR7IQ9K/+sQCq4qjTr0g2eUonW7kCTCHu
	 aokp5VpvLl+RGNfTSdf1jBeImPLsKS2M99ALvF/qXdLdFRvZmDyd60q+X3wEyPL/NI
	 TLi74+xxv5p2e+xVfXNbWEvq8Iv9ywW7epK5SPOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 022/374] firmware: dmi-id: add a release callback function
Date: Thu,  6 Jun 2024 16:00:01 +0200
Message-ID: <20240606131652.533305270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5f3a3e913d28f..d19c78a78ae3a 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -169,9 +169,14 @@ static int dmi_dev_uevent(const struct device *dev, struct kobj_uevent_env *env)
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



