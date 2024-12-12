Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89614A82;
	Thu, 12 Dec 2024 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018665; cv=none; b=b+Q/PHjdwvMiKuQm3pXWlbb9w7PfXuq59V9v0PoK/jE4ndTV2FPUp7NHWRnMu2RH8MEnv3j6tYxaFL2BT/9p4vsmA8DiKyXu6+XOyMjrHQI2AnarOU6rwazxPZ7HwaiCrTYiLoyoLAdsr2gaH0WJA5dNQPmDUyAEoJfhgCnAjn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018665; c=relaxed/simple;
	bh=B9K9czin3yTghEPq5HfqE3OET+Ukr0gh6qu1csw7ezU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+JqsMk+LIJ5jfJrA9imXSXjtwciWmpJNNh1I2pn6XBHk5haT0dxkIzkYO52TcX/ayb49gzojDp/hFzePCntPp9KKaciUKRFaXDjhQ0nvh83LAKwclHswf60sCfmETB6+BuNUWHYvfN2hL7oPaRCo6GjVrTHJ7e0aKXyKitAyNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deZSEWS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deZSEWS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE90C4CECE;
	Thu, 12 Dec 2024 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018665;
	bh=B9K9czin3yTghEPq5HfqE3OET+Ukr0gh6qu1csw7ezU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deZSEWS7+cJERd/C7d0NsI8zHTnxacfa1UdI9dPvRvNTL9gF2jNZo9nnP9kbUWBMd
	 2GQTt3ufDAxXgo7lUn3/uhrCqmzehtzMNGRPeliSGQqsT2pZxZ3RVQdyRal4xzm8PP
	 zcC82rX1Fhq2dbzb6nxZsGr0Kr67gNWA4CcDxsWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Larabel <Michael@phoronix.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 353/356] platform/x86: asus-wmi: Fix thermal profile initialization
Date: Thu, 12 Dec 2024 16:01:12 +0100
Message-ID: <20241212144258.518356625@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

commit b012170fed282151f7ba8988a347670c299f5ab3 upstream.

When support for vivobook fan profiles was added, the initial
call to throttle_thermal_policy_set_default() was removed, which
however is necessary for full initialization.

Fix this by calling throttle_thermal_policy_set_default() again
when setting up the platform profile.

Fixes: bcbfcebda2cb ("platform/x86: asus-wmi: add support for vivobook fan profiles")
Reported-by: Michael Larabel <Michael@phoronix.com>
Closes: https://www.phoronix.com/review/lunar-lake-xe2/5
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20241025191514.15032-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-wmi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3569,6 +3569,16 @@ static int platform_profile_setup(struct
 	if (!asus->throttle_thermal_policy_dev)
 		return 0;
 
+	/*
+	 * We need to set the default thermal profile during probe or otherwise
+	 * the system will often remain in silent mode, causing low performance.
+	 */
+	err = throttle_thermal_policy_set_default(asus);
+	if (err < 0) {
+		pr_warn("Failed to set default thermal profile\n");
+		return err;
+	}
+
 	dev_info(dev, "Using throttle_thermal_policy for platform_profile support\n");
 
 	asus->platform_profile_handler.profile_get = asus_wmi_platform_profile_get;


