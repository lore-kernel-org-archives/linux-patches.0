Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5253644B3;
	Tue, 21 Jul 2026 19:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663717; cv=none; b=XLYgYgWNsVipwzno2JE0E1snvWFFbpuAyhznDNKD9az0sGHgQAcdr0618ydsB++khlknzeRS9e/WVsUTm5lZm6FpESHYq9s+IkTeZOMs3uKAU0LkH0XUlGVoDgQGPvgyG0LWPFiAVsInmRVQF13Bllocpn7TXLxF3xeadZDkLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663717; c=relaxed/simple;
	bh=XXWSqPryXfYum76f9Byj62yzD0FVmUxORFYqR8QqjpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miFB07oriSgtDqR11gbY+vl0oePP3ATYR7igdzO6EuOlF2xPhNJOSv4S0caIGG2ZISFsZtATLa/uG8zrzEoaGpwcMRYo9LA+Xgf0yfAJ95IW1ruyGz8gWrbZTFsrpVedBfPtel7dDsk3alRYpsp3iKVeQTdzfwAOCeHHnErKPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu4GKYId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu4GKYId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B931F000E9;
	Tue, 21 Jul 2026 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663716;
	bh=HOvKc7ZeWWgD+y0g9+yl+7Q39BwYbEtfEOHyqm+Ivyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu4GKYId3KbBiNr+TpUgI//r/3Vab3kvyaJJE6MPfRjXdqoffjWTlEaRiroy8WP/I
	 /vVAGGeONKnWSwrqhylroamBpTiDeJ19iGRW21G78JgOk3G+ilcmMoTtMPpq+hFMro
	 04hgCxIVbv5S8O1Djn7TLd4nFyWK0VaOMLMGHzKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 0874/1276] leds: uleds: Fix potential buffer overread
Date: Tue, 21 Jul 2026 17:21:57 +0200
Message-ID: <20260721152505.611766847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit c19fe864f667afc49d1391d764e20b66555bcf7a upstream.

The name string supplied by userspace is not guaranteed to be
null-terminated, so using strchr() on it might result in a buffer
overread. The same thing will happen when said string is used by
the LED class device.

Fix this by using strnchr() instead and explicitly check that
the name string is properly null-terminated.

Cc: stable@vger.kernel.org
Fixes: e381322b0190 ("leds: Introduce userspace LED class driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260524235553.189134-1-W_Armin@gmx.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/uleds.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/leds/uleds.c
+++ b/drivers/leds/uleds.c
@@ -102,7 +102,8 @@ static ssize_t uleds_write(struct file *
 
 	name = udev->user_dev.name;
 	if (!name[0] || !strcmp(name, ".") || !strcmp(name, "..") ||
-	    strchr(name, '/')) {
+	    strnchr(name, sizeof(udev->user_dev.name), '/') ||
+	    !strnchr(name, sizeof(udev->user_dev.name), '\0')) {
 		ret = -EINVAL;
 		goto out;
 	}


