Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA8253954;
	Mon, 13 Oct 2025 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368251; cv=none; b=sqj7zfbI4rXuCA8lpB6yG/4gnfu0TJQr7L4lrJNI2yK2KBWZkCFVNlVbFCsNRjdBYos1X9rZ5X4ovNenX5hC1sq/LW153iGoLJSEtiQaGWQkYrTdL4PVcFC+7py7XKeuCGw8zi/nfW500PPmgT9A2UnGZMTge6xQzAFlfbZHd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368251; c=relaxed/simple;
	bh=WA4DTqZnawzJ8LdiHabiwiMKrg3OOZOWUCfiN9lXsiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi1K8rDz2JOg0t79LWqqdPeYadFMZNV6A5jREbnDW8NMgB2Da6WeeMTyXfjsWc+EKNXKDg1N0z4R+YlFWrUkolNBXEKMmY6cyXVoIjIZ2VC08qWkTsxurAUeWGtwmpH9CyeLZ2nwMrj0oeXQnhYf2ANGUbqSZZY+L+VUmxuZHVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCpSVq2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCpSVq2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E28C4CEE7;
	Mon, 13 Oct 2025 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368251;
	bh=WA4DTqZnawzJ8LdiHabiwiMKrg3OOZOWUCfiN9lXsiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCpSVq2PMkxLu7TKG2xkZPV3G10ndlEII5g9A4ZZ5H+BA9Osv9gF8zUOfgy0i4f7P
	 WjygEFHiLBQ8uy0Bzr4nFBCF1fK1s2j08Q0H1XqaOKQhzDEyD3feTYbiwkAX/lYy+j
	 tYjilt1rmeKenXq58wCEFlrPQSKj+tYzepJHXGjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/262] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Mon, 13 Oct 2025 16:43:58 +0200
Message-ID: <20251013144329.585536267@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 186e8f2bdba551f3ae23396caccd452d985c23e3 ]

The kthread_run() function returns error pointers so the
max3421_hcd->spi_thread pointer can be either error pointers or NULL.
Check for both before dereferencing it.

Fixes: 05dfa5c9bc37 ("usb: host: max3421-hcd: fix "spi_rd8" uses dynamic stack allocation warning")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJTMVAPtRe5H6jug@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index dcf31a592f5d1..4b5f03f683f77 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1916,7 +1916,7 @@ max3421_probe(struct spi_device *spi)
 	if (hcd) {
 		kfree(max3421_hcd->tx);
 		kfree(max3421_hcd->rx);
-		if (max3421_hcd->spi_thread)
+		if (!IS_ERR_OR_NULL(max3421_hcd->spi_thread))
 			kthread_stop(max3421_hcd->spi_thread);
 		usb_put_hcd(hcd);
 	}
-- 
2.51.0



