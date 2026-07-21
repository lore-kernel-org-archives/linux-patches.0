Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA1471264;
	Tue, 21 Jul 2026 18:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660214; cv=none; b=SJLAm8+LoTLvjjf4EjRl8NQZ+Af8Nb0OTxblRujrQEGXPQ9Hkqefgw2iRagd4Vx/t5K4Rs1Ndas57SL4Itd79RdEe2BX3ltt8vnEjgXfIfmm5wNtHwBwxjpBbvaZZoQTF8BCOOgvYxZemfSR7dEoF34/bf09vbxqS1W2xiLG5+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660214; c=relaxed/simple;
	bh=ncNL4AKxqsmssO2K8m05HMC5BLFRMvYtPz71dei4pkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwl7IU2Y6XQDy7ntzaMOjNZUqwItIryUwvqE6Dyr9aTKFIGHOAUygbYjYVh7h03jSBeIXKZdkY82UIRgMpT3z2BcaOciOvYtPC3Ps9mfDdINkHbR46hwpYHyv1K58xeTn8LRDskv6za3lskjTKpdTjJl+3iBJX/O6Fo9SQyCWt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsU2TRmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsU2TRmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB631F00A3A;
	Tue, 21 Jul 2026 18:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660213;
	bh=Q84ivI8JvqEGpKJvSIEyo+xaKdye/9YsgGn0A0tfgko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsU2TRmjUnRt8M20uUQUkTLeNeR7AVmB/cckAp0xUnpXzDf6d0kCJZ54UDRPdZa9E
	 DcD6RRviDw3PDIwQPRGVmrIAtyLUEEkytCVWIfcTr+HEQVhgGiGwr9WHaWtLNa3p9e
	 QnYjbmSFknK/wdUQUYJ3oSCFpQyMPSbfs91mTVIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0895/2077] hpet: Check ACPI_COMPANION() against NULL at probe time
Date: Tue, 21 Jul 2026 17:09:28 +0200
Message-ID: <20260721152613.927528676@linuxfoundation.org>
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

[ Upstream commit fa5e2952341b792b72d5410dbfcd0b2ac8046d2a ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
hpet driver.

Fixes: 71f0a267346b ("hpet: Convert ACPI driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4750803.LvFx2qVVIh@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hpet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 46c84e5df00fd5..285c6037417ab2 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -976,10 +976,14 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 
 static int hpet_acpi_probe(struct platform_device *pdev)
 {
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+	struct acpi_device *device;
 	acpi_status result;
 	struct hpet_data data;
 
+	device = ACPI_COMPANION(&pdev->dev);
+	if (!device)
+		return -ENODEV;
+
 	memset(&data, 0, sizeof(data));
 
 	result =
-- 
2.53.0



