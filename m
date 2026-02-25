Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BF0311963;
	Wed, 25 Feb 2026 06:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002695; cv=none; b=Ss4UWumfySkZPWK7/Imjnvvs5exN4hNSY1F2fftTfmGFk6rB1VWCxWI7WYSI/tPTYBqKcmPc4Fp3g9KkM+oj7z1Bab114DsAUG7sRlrjvGRT8STBKzzAFYa7O3P8OSNqBw+AfdKxaKg6Jm7xfc64KCH4wgol6FIKZqGil26uuzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002695; c=relaxed/simple;
	bh=TfmgVgiYhF0Wjp52ZvgjUvhQSNASnyecE7m0dVklqkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGa1mZ6JAHYe+cBf8Jn85nfmB5KvtaHSSyEVre8DyMPYXc7HPR77srPQi47Scug18QqUf7YML9Mi/1YtlbOruG9obtnyC4sjYg/7k2ScHkS2qDv5FOGNUH5r2rWLfjSuIQHX+Af9hq8jODbpswJyTomEcuGNh13L2P43EyaPWTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddWdhGWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddWdhGWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8958C116D0;
	Wed, 25 Feb 2026 06:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002694;
	bh=TfmgVgiYhF0Wjp52ZvgjUvhQSNASnyecE7m0dVklqkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddWdhGWtVTKCarmz1WG71eRqPu6boWRRFuVE2wPXjzkoEGgxpHzEpxCzRInW2KLD6
	 dTpykCtyfnH9a5XJUWUV8nY0k2bGXRy54N11572YjWTO+Kw/l1TEukcjK9okuiufpT
	 icX/oR3/wUHGBeTc1N2LW3qPo6DF3lcAtx9ti3SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Li <unsw.weili@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 490/641] pinctrl: single: fix refcount leak in pcs_add_gpio_func()
Date: Tue, 24 Feb 2026 17:23:36 -0800
Message-ID: <20260225012400.390193990@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Wei Li <unsw.weili@gmail.com>

[ Upstream commit 353353309b0f7afa407df29e455f9d15b5acc296 ]

of_parse_phandle_with_args() returns a device_node pointer with refcount
incremented in gpiospec.np. The loop iterates through all phandles but
never releases the reference, causing a refcount leak on each iteration.

Add of_node_put() calls to release the reference after extracting the
needed arguments and on the error path when devm_kzalloc() fails.

This bug was detected by our static analysis tool and verified by my
code review.

Fixes: a1a277eb76b3 ("pinctrl: single: create new gpio function range")
Signed-off-by: Wei Li <unsw.weili@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 998f23d6c3179..d85e6c1f63218 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1359,6 +1359,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		}
 		range = devm_kzalloc(pcs->dev, sizeof(*range), GFP_KERNEL);
 		if (!range) {
+			of_node_put(gpiospec.np);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1368,6 +1369,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 		mutex_lock(&pcs->mutex);
 		list_add_tail(&range->node, &pcs->gpiofuncs);
 		mutex_unlock(&pcs->mutex);
+		of_node_put(gpiospec.np);
 	}
 	return ret;
 }
-- 
2.51.0



