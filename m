Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB4330B00;
	Fri, 17 Oct 2025 15:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716043; cv=none; b=B/ZwRVRGrgZ/sEa2jokrf4ZCEpV/9KlzfTThBCowN1VvIVts+ugdF3mQAPv1CpNNWtsxD3gO5Ox50UhCwEF3/+o6Hm3ga5SvvYFFAic+qQTl+TeXw3x6Gw3rPzwDYLK+a3yTmlN2xQTbsSugCHgWHE/jUNEDEcq7uKcR4yUCCms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716043; c=relaxed/simple;
	bh=h1lK8tOEGtxRnQ+iqg23CK/rU8PxEWc3Hvnq08gWsx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G74LW8gqm69s98/RvzcxW7A5KvvCRyzCAXF0gPBv78zio1vQRWryh9hf2UYHIgFFiBRx46/35as0rpSLaE1dcSgxe/uT4nuGexqQHyN8Za/pmfzUQIDiPDQiYubvCJkttTA/0h7OuOwgeBSQUom437huD+d+FH+JLUqb7Zuc6F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvCX7tK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvCX7tK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEF2C4CEE7;
	Fri, 17 Oct 2025 15:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716043;
	bh=h1lK8tOEGtxRnQ+iqg23CK/rU8PxEWc3Hvnq08gWsx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvCX7tK7zKu0fh8oO9jJAHpVhma2UjlUcBWFQcxiBjOBi0cmFGYCkByjZyQ5nFaAH
	 jCpuZEfQhj2O1TBDm5K8dHudd4W1hDeYC0NqcDFndg/3bHTHK4I9uw6Peg6PZ7gga6
	 guBLN9JnQnU94BXy5j7vuk7fZ3uPiAqF416oaPc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/276] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Fri, 17 Oct 2025 16:52:27 +0200
Message-ID: <20251017145144.460768352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
index 37a5914f79871..b2641009519b5 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1925,7 +1925,7 @@ max3421_probe(struct spi_device *spi)
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



