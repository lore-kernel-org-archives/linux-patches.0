Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A943B6E0;
	Tue, 21 Jul 2026 21:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669969; cv=none; b=upvoYrBXm6JD8H82DMhQMbOeCqhczM4vlokpfzy7MdIaH/XhfMRM8ip+mF8QSS279ZigizQqJmFbRsJ52Ft9ffpK3rtpGFENfoEPb6JOjaHqyFtqLA7qi1fjFlDRE0HH443/kOy7bX9IiJE5XL5FU82FL3QqHIrYI0eQGhwjvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669969; c=relaxed/simple;
	bh=wf4AHaMxU/7Pi3G497c5Dkxp8nJUjDFzRXsn/Sc4gqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug4MeQ/i6tfnPuLMVTW7lJWp84qzwyeAISMWo/A1nZa0XKBTUU8m/8ymWrgO/TymoK0ZsJEyLo2cudzLf98Y31qxfiCoeUocVpZ8dvOTNyWfu9F9yBC+hzMpK43ZXBa67f0Jcb8udMjk1RMF2mxZ2U2mA3fNLc5QCHflGRnSRio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARL/VUh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARL/VUh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AF21F000E9;
	Tue, 21 Jul 2026 21:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669968;
	bh=NdQs4YiLGVSXz0djoy+qcZzX3LgkSSpodUzLRsKq8rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARL/VUh8MCP8EP22Wyo84RYxqygbkA46BpuOc1vhF/Yaitjp41Aki9REk/+Wofo7j
	 XAHTxEuuOBhr33/5n/lmofnOPS8IJ8Tv29Y5zGNwWH1PNt8XGudEedhWq4Cr05Q+np
	 qsJA5e/mbrwoLDD9M8cmP7IS0gAu/TJN0aRY6BOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 0756/1067] leds: uleds: Fix potential buffer overread
Date: Tue, 21 Jul 2026 17:22:37 +0200
Message-ID: <20260721152441.484550568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


