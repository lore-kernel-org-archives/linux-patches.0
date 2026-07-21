Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206BF2DF3EA;
	Tue, 21 Jul 2026 18:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660217; cv=none; b=TYcJ4hlRpRlH/+bsGiXwt/QquLCocJYbBz5GxUZAye1MskJMDg7T2A2J/JWLeAnwV77YhDwQ0YQisbBROQfLssYBGVVR7xfLdnDSSizUVc+Bd3t4c3kKMxHZzUJk+FXxy4H8u3gWLjBYCve7EqSrlzpv3t7rTPmqCacWP7pT7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660217; c=relaxed/simple;
	bh=gSZz4E849DAuFaEg1RKjh6SWpbzAn9TgiuNCDWd1QeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2iYxDwW2cHI5D3ilAnwj8URMNU3OpcVRSDkogeCAnlAO24mC8VHYn3+ylKOcCGP19btfCZXEbHkSmve7bW/bONdynRuttaS4GsL2zPfzkhHXEjiySzDtZ+cp3GXh/JyCBs60axUMH5jUGUlryomtoDi+AFwz2B81hhrKPvj4TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZk4F7iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZk4F7iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862561F000E9;
	Tue, 21 Jul 2026 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660216;
	bh=kn+FqFj6X0EAK0QeSBmsAM08wjAQtwsT0rWiCjINDG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZk4F7iWTNFIly/KXTIYdKlAE+60s+Xec0v0Ozxxmrx9fH/SO8FzyZPIc1Rb3TD8K
	 OOiagX7STDiv7tsdHrefZBcjNiEWoXJgY/KhQKStQQ1BmhHbAyFnV1pfm/vr5hDat7
	 UpspIfn7s6brREMT1nx/6RiMdjTmR6FEcV202zWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0896/2077] sonypi: Check ACPI_COMPANION() against NULL at probe time
Date: Tue, 21 Jul 2026 17:09:29 +0200
Message-ID: <20260721152613.952822786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 950f35211b85db26fc1aae67bf1e14ccef393a0a ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
sonypi driver.

Fixes: 7e488b0af021 ("sonypi: Convert ACPI driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5087721.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/sonypi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index ccda997a9098a3..24c1b26f34d6b1 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1117,7 +1117,11 @@ static int sonypi_disable(void)
 #ifdef CONFIG_ACPI
 static int sonypi_acpi_probe(struct platform_device *pdev)
 {
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+	struct acpi_device *device;
+
+	device = ACPI_COMPANION(&pdev->dev);
+	if (!device)
+		return -ENODEV;
 
 	sonypi_acpi_device = device;
 	strcpy(acpi_device_name(device), "Sony laptop hotkeys");
-- 
2.53.0



