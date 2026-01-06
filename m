Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F232FFDF9;
	Tue,  6 Jan 2026 17:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721958; cv=none; b=qVAwbeFsX92tF0vtWMx07+dbigWxBDAURHoq3Vjos9OUo2TYEMCD2WvSbThVH3nHZfMWEx3OZDmJGAcgIpWGHGYqijNNwnXyveY9f1fdJ0AMIvw2TsI/MuXZX2e3dQpLaydu2bbIW1uEdqnI74HtbzEeAI5FbklVlo92SRaVEDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721958; c=relaxed/simple;
	bh=q32HfF9zjL1Y9pvzqPyxFPTIeWtEZ/tejMc4MvWFDpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9Q1znrPF4zA/3HzUhMuZvcvgjQI5XWn08CkTS/vxJ5oRZ7g0f6HSrFB+XkGXFTpwdVqHyT6QLnq6OErfOxrNGTcgjxwz6XXLTYA6aXv+4BpKkXqa1V0tslPDn7NW1YXzaUsJctAtqyCDSEsOILGqcyu08IkRDEyQnFb2/aw4MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzQLzeQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzQLzeQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157D1C116C6;
	Tue,  6 Jan 2026 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721958;
	bh=q32HfF9zjL1Y9pvzqPyxFPTIeWtEZ/tejMc4MvWFDpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzQLzeQFQSQH38PzwrNbmfphuWn9NYnU3Y1sWlbhPaZp6dMvaTzxKltfDRYuVKnlc
	 wWM39FjZHqOs8XKeo8xnpAgafb5vO8bGX4pHMQ29J0N/z5RQUkKWcEr7isDnJJwbw6
	 8OeiVpgyu1COtonxE4gh30YpuliHIZHrINmrvtAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 121/312] hwmon: (dell-smm) Fix off-by-one error in dell_smm_is_visible()
Date: Tue,  6 Jan 2026 18:03:15 +0100
Message-ID: <20260106170552.223383572@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit fae00a7186cecf90a57757a63b97a0cbcf384fe9 upstream.

The documentation states that on machines supporting only global
fan mode control, the pwmX_enable attributes should only be created
for the first fan channel (pwm1_enable, aka channel 0).

Fix the off-by-one error caused by the fact that fan channels have
a zero-based index.

Cc: stable@vger.kernel.org
Fixes: 1c1658058c99 ("hwmon: (dell-smm) Add support for automatic fan mode")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20251203202109.331528-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/dell-smm-hwmon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -864,9 +864,9 @@ static umode_t dell_smm_is_visible(const
 			if (auto_fan) {
 				/*
 				 * The setting affects all fans, so only create a
-				 * single attribute.
+				 * single attribute for the first fan channel.
 				 */
-				if (channel != 1)
+				if (channel != 0)
 					return 0;
 
 				/*


