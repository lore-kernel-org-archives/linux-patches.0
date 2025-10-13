Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33A330ACE4;
	Mon, 13 Oct 2025 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367698; cv=none; b=avUCPP45LiPkY29MEZRmfkQ8D+QT9abunSEGycU3hxGgInp2tPrf7T8+vAlxmwfaZwCR5CnHQS29YxDCrnkLoz4CVGiL8yuTZvUfUfAsiSWPz1szNM3ix9BIjPbjx1Wt3zm8XYykvpJRGP3WoB6zgqdgbwLN3xoQI6Pr1IntvNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367698; c=relaxed/simple;
	bh=J8K9gQqmwLjtFRHdyXvigUQq0QmohOozQ/c5GSt8pDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI5apRLoiodcstq2TLU+dGw92Hye+3+m5u2A5nG9bCq6xKEwzrG1RHYjEHNioKpzbZQgC4oV7BLzlCHmrmAPpeejfrf+F8wWG6yrMIfVMYLNoTfBfePAfafMBl3rcVMl64GnAs+daoUTLcJONrljhr5EWMkiCw76I1NkUAI5+uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IN4u0vuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IN4u0vuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C183C116D0;
	Mon, 13 Oct 2025 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367698;
	bh=J8K9gQqmwLjtFRHdyXvigUQq0QmohOozQ/c5GSt8pDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IN4u0vuT2gvmNMXU+ttWBcuw6JmAFqJzGtIMUNl16bcF6e+iA03sI5JBd/k0uFBNc
	 qUqxLQW6NR+TOkYNqAVlymPEE6tt7/4tOK3+ZOen5m1icRFdwm4GeK2Q8Ygt79YF2Z
	 A8vhVgHNJFnh/mn4rLeod8XBlZ9t1iWKiOBerlmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/196] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Mon, 13 Oct 2025 16:44:19 +0200
Message-ID: <20251013144317.653925544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index cc1f579f02de1..2d792ab271e2a 100644
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



