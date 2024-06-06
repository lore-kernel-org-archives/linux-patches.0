Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A271974EB;
	Thu,  6 Jun 2024 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683462; cv=none; b=TK+CnoNJGJGpe4jRxn2K2A5QxV2DBChDwNFfSVQKNiJC8c8FKM31+sC5xagXoFH2G6QNBLxt9QISwV0EgEQaG9U2nmhj9nolRewAS1NH1FKEOJpBbX/U9KjK/tqFiK6/B+ELd31XHR4V09s1NCEhV75P5iQheEV1HocccDJe9NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683462; c=relaxed/simple;
	bh=Nfx3rUFm+xBy9mP3yWtbEVdfRnqVETlaqNt2E32hICc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jx+MFL6TKdHrpcXi+keBYDQus5ONJi9aHy7qTRKr5I+ad3SOLv3j87TXKLHMbWqrNnScrDWYQEFmZo1vD09/a0qoLRmCmJyi9lR1foZHGe7xY/mUHfL51f9NgWsuVcKcsQ0ciQRWMXY3ccqD59BHMUkmkF9A1UazQtJKx+4pRD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoTy5vHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoTy5vHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89E1C2BD10;
	Thu,  6 Jun 2024 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683461;
	bh=Nfx3rUFm+xBy9mP3yWtbEVdfRnqVETlaqNt2E32hICc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoTy5vHeifUPXnrVZUQXgQ7N0Lok5MFbr2Ff04amIswaua7s00h84+gCAx+v0I2t4
	 /8niarIlurpsygKDQ13/N0UWjlHtFOmZ6MDDjXxB73tlEUiZyJ3tiyhLVHXngmCJ/k
	 bW19MKMTSy46WCwdvG2n7n30BZ9A2DPl8GaXufjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 406/744] firmware: dmi-id: add a release callback function
Date: Thu,  6 Jun 2024 16:01:18 +0200
Message-ID: <20240606131745.484694189@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



