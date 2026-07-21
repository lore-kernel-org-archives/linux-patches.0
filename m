Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA2471251;
	Tue, 21 Jul 2026 20:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667110; cv=none; b=j3uCZPPO7Oq+rxD4I8MEpWQHMyBOmfZ2QwVCJ8nHJpDdNH8UZyve0yEHm1ie38Mbwk3gM6tFMcYo6GoHbraqEauYfqg/fDu+icZ0nfXeAphSSUGAn1lBNx6FbKozAqRpOnK3g/W8EKocaYjh3vrCvsQnPASdGViodhy+u6mNLJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667110; c=relaxed/simple;
	bh=Fa8lX19wtGHhAUhaGc6LdNw7azBs4DBYfeaSzo31h2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6okRxWU6t28QUKdIe3uoaTlpaPRHTHE727rIth/X+Ac8WGhm3rfSOgwkkrR5TKanqjhqykhKvEPuHSdpn+yonLrTpRKa2qCYOYIFJTLqLwKJwGWf/XONrH9Br0OAcVtTtTos/R1xefsrkbBFQGkIf6mwxQ2Ykg9SNK8L6pgNhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdNHRUEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdNHRUEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F1F1F000E9;
	Tue, 21 Jul 2026 20:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667109;
	bh=M0S02W+w4YE+8UyMN/GzdD+mxQN6aLJVlgUiVEKwWVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdNHRUELE0tBtHAHwinYduIaA1hkmcpwOjYFNeS5nMnoUt0Nl4JiRb/XJJC83+vOj
	 Zqp0fFJ51DwQBR041TJWkhpoxJ48YQMC9JaXP8UHiTP6LGYow5vxbvD3u3rIvNJEOT
	 P3jfqCm91NbN4srDbqbpByLyhlRLElDAe2FpSX+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0938/1266] leds: uleds: Fix potential buffer overread
Date: Tue, 21 Jul 2026 17:22:55 +0200
Message-ID: <20260721152502.824490894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


