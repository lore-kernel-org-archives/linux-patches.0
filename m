Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CA4435EC8;
	Mon, 17 Aug 2026 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980549; cv=none; b=jnG4r8sWF/kumfU8vVlJVM7plFtyK1akA9vPTKt+DN2HTFSOQTV7gz43Hw7zLAiLu987vF2xyMps0D1FuFda+0ncpyOnwyTDK3gsuYk3a3bixc6T9V0gDUruKPajUd4DlFfEIkHrLpcjDMBO4AfDgAeEZ8WKkOsJcNFQlTSl/HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980549; c=relaxed/simple;
	bh=hXKpGanbPNroxCXscRTj1ECvKVjR7rj4RHrZ70WpBSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyhO3HjMubtbAg5ydigbKIQ17R40ofUi3BRtXgt3AUxUcl3vWp4VFn8L9cccuDk8lFTlDByDHQj/0kCFK5JEBFA7moGdMo7WNQecJ9hnHO4WR7QGERETfhAphNHKruiBXSxiTsJHS8avTkoK1yMY5JXhvsZbQ0iCeOvz0cI7HWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNpp85zC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNpp85zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F711F000E9;
	Mon, 17 Aug 2026 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980547;
	bh=zWySJcztoce8Pd/ZyhgbNsEQjy7B68R4MIttrQd1WUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNpp85zC8egY6INE6e2po3tK3QoT8ah1O2Nc9DGAvyxGBRg3cgIb2leNoIb9qXkYY
	 4HIyKZzpV4x75pZSurOmKL2j6aZDhnP3uIbfdzjNA1UjMmrejm/SbRwvfC/J7t6HSM
	 9A5EaOP9Nr5XFlZmNWCxAVBmJykeagx0oBfInt3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	Ahmad Khalifa <ahmad@khalifa.ws>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 609/609] hwmon: (nct6775) Fix non-existent ALARM warning
Date: Mon, 17 Aug 2026 15:35:05 +0200
Message-ID: <20260817132604.003670041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Ahmad Khalifa <ahmad@khalifa.ws>

commit 2dd1d862817b850787f4755c05d55e5aeb76dd08 upstream.

Skip non-existent ALARM attribute to avoid a shift-out-of-bounds
dmesg warning.

Reported-by: Doug Smythies <dsmythies@telus.net>
Closes: https://lore.kernel.org/linux-hwmon/ZQVzdlHgWdFhOVyQ@debian.me/T/#mc69b690660eb50734a6b07506d74a119e0266f1b
Fixes: b7f1f7b2523a ("hwmon: (nct6775) Additional TEMP registers for nct6799")
Signed-off-by: Ahmad Khalifa <ahmad@khalifa.ws>
Link: https://lore.kernel.org/r/20230918184722.2033225-1-ahmad@khalifa.ws
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -1911,6 +1911,10 @@ static umode_t nct6775_in_is_visible(str
 	struct device *dev = kobj_to_dev(kobj);
 	struct nct6775_data *data = dev_get_drvdata(dev);
 	int in = index / 5;	/* voltage index */
+	int nr = index % 5;	/* attribute index */
+
+	if (nr == 1 && data->ALARM_BITS[in] == -1)
+		return 0;
 
 	if (!(data->have_in & BIT(in)))
 		return 0;


