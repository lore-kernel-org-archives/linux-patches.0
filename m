Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CACB22E3E6;
	Thu, 17 Apr 2025 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913511; cv=none; b=W07y6isY/g7uTSheCpnIKRHBVToMlaLVZ5+9dxdGNoN94Crk52uhSY4YwC+6RKIn1APTwe5BI1cA0MKHMhlT2O4UwLah3SVm62NfKPb3l3tWJgbbDLGK4FyHO21xgSnAZRlaDyWnrnbNK3QAMdGRxK8D0hv7WDQI+2+95g8d1rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913511; c=relaxed/simple;
	bh=n/Pj6BqKqC9H26N+N3NM69au0AaGZULHQQCG0ixqbAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8ksgoPSJyw3Ey6W2IZNnYDSHdAJu774EcXj+f8+DXRx8idG8kG6bzpZQfFuRrN0bnXiZdlQ/1k5hMse8CQXDk0FC2ongqmJNXJIgWORtaSKrK4DqY/zN+x0SioN2+w7se1g7jI2/xBxLLpbgIo8ACrSNQcO6V1q1O8SucwpxOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjPQskeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjPQskeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FD0C4CEE4;
	Thu, 17 Apr 2025 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913510;
	bh=n/Pj6BqKqC9H26N+N3NM69au0AaGZULHQQCG0ixqbAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjPQskePuUxoG5BR632tCNTSaLr8z1nOkPvAfaX9E3DiWePJs5qJMiRY3ylIFr232
	 rXbC6waaaC5lyYaeSAVWChN0eGoZOrYWAwxJKhUkCYau0wLVjwxdY9EKqmqU3Svo3f
	 v5LNe46oeCMFjPQ9+0y01ryWgFwVK26elxnSe6Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 6.14 325/449] mfd: ene-kb3930: Fix a potential NULL pointer dereference
Date: Thu, 17 Apr 2025 19:50:13 +0200
Message-ID: <20250417175131.210408350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit 4cdf1d2a816a93fa02f7b6b5492dc7f55af2a199 upstream.

The off_gpios could be NULL. Add missing check in the kb3930_probe().
This is similar to the issue fixed in commit b1ba8bcb2d1f
("backlight: hx8357: Fix potential NULL pointer dereference").

This was detected by our static analysis tool.

Cc: stable@vger.kernel.org
Fixes: ede6b2d1dfc0 ("mfd: ene-kb3930: Add driver for ENE KB3930 Embedded Controller")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250224233736.1919739-1-chenyuan0y@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/ene-kb3930.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ene-kb3930.c
+++ b/drivers/mfd/ene-kb3930.c
@@ -162,7 +162,7 @@ static int kb3930_probe(struct i2c_clien
 			devm_gpiod_get_array_optional(dev, "off", GPIOD_IN);
 		if (IS_ERR(ddata->off_gpios))
 			return PTR_ERR(ddata->off_gpios);
-		if (ddata->off_gpios->ndescs < 2) {
+		if (ddata->off_gpios && ddata->off_gpios->ndescs < 2) {
 			dev_err(dev, "invalid off-gpios property\n");
 			return -EINVAL;
 		}


