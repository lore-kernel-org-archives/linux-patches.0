Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BAF46EF72;
	Tue, 21 Jul 2026 22:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672334; cv=none; b=Y68p6EKrmBIbzcoOA7GSJRleKwWwOx/DQayNfxZlWDp7JZiP0tFvUwHxsWHmclGiO7Uz6nbQP34eg+akRrBRPFozpqoIcMfnr1rDz6VldHuLe8kPqL0YTb/y/YvKY2+ZgQIvvPsucmIEDWUEspXUs03oVVSQD0kh/GLxMFqbi/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672334; c=relaxed/simple;
	bh=tw1An1bCqGdCGuWQhz4jwxaKEiPE+F1VhXiR0ghBYII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOCWTcfG7IljKhT7iE3LpwbJzMHB1EMiG2G5ncRHkU+AhTm/18iV9g1q58n8B5k2zvHjsQKXdilEketwDckSt4Q5HoDQglh9xsA1LRoJGQjIBN6s9xUuviI8A94/BAmiITXtZQhFEJkpf6s3l8ux/LVqD6BSFzEE2+KDffUlwaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BekFLhax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BekFLhax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992971F000E9;
	Tue, 21 Jul 2026 22:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672333;
	bh=u72Y+c0dgkUZe5WzDaCSSx2OSmEMtnGmmx8zX6aNQ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BekFLhaxcUfn4KB/pJq5JSKlLNoYE3JPQhPLLkZ6EJKtXCVp426DFdbH5JiJ3kF+O
	 bWptQRe9APWChG/u00nBQOY7vyG/RMYP16BNJVs/p2fZ1GPrJFt/dAh/pL1srnN0u4
	 iEoSoQ4S/ner/1tBHcFoJR82f2PYUxu54pXTWBUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 583/843] leds: uleds: Fix potential buffer overread
Date: Tue, 21 Jul 2026 17:23:38 +0200
Message-ID: <20260721152419.163517268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


