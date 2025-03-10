Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71841374EA;
	Mon, 10 Mar 2025 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630824; cv=none; b=rbABlsCzu2GATaHVAVBp/Ry5IHg0m8DIpuuz53c5IrIqgSK64jYVSX0tXKbUW1dtkpQ0RkKoZHTMlAnzyyYtwNaxSWf0OgnjexNymsdDodUFU8Ake7mJxvHKSXw+xBNuuokXBYxiol4j2GTruihKXdK9kGJFa+pGa6tC7fw4ijU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630824; c=relaxed/simple;
	bh=ifx+nlXgfJg5Fwrqh34+TZlwtzARB2BNF9LWZJ8Fre4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3b5Tygo6ZLVuFBlAWY/Vui+vQPFI06E0h/YLsJ3ypgsbcTuHY0vXKbXmWG24+ieWqf2wGIwyNogFYm+Zn5jvrwztZ2KjY3jlr/IVs9y9Ia/ahJ6PU8SiypnX2M3UWwwi+OEB9IvN4vMc/49ZJTlR9i+0ufCI45+8lGm/3wd9qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8rP0T1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8rP0T1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF25AC4CEE5;
	Mon, 10 Mar 2025 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630824;
	bh=ifx+nlXgfJg5Fwrqh34+TZlwtzARB2BNF9LWZJ8Fre4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8rP0T1SJ4hrTTtxBEUi97M+s/0C8PdOjLIFIu31mXE/iCzfxKPAY3+xTXnr0hxwC
	 25GLesvB5tPbhCV4ZFZN7K3/G9HMUl8DBpFXyZL8qNdgMeN7r/D/SNElRb8btKb6p7
	 7vOsYxMC5VfCYlueH6y2pwmglwr0a8kA+ZV3HxxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 547/620] rapidio: fix an API misues when rio_add_net() fails
Date: Mon, 10 Mar 2025 18:06:33 +0100
Message-ID: <20250310170607.136244943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit b2ef51c74b0171fde7eb69b6152d3d2f743ef269 upstream.

rio_add_net() calls device_register() and fails when device_register()
fails.  Thus, put_device() should be used rather than kfree().  Add
"mport->net = NULL;" to avoid a use after free issue.

Link: https://lkml.kernel.org/r/20250227073409.3696854-1-haoxiang_li2024@163.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1739,7 +1739,8 @@ static int rio_mport_add_riodev(struct m
 		err = rio_add_net(net);
 		if (err) {
 			rmcd_debug(RDEV, "failed to register net, err=%d", err);
-			kfree(net);
+			put_device(&net->dev);
+			mport->net = NULL;
 			goto cleanup;
 		}
 	}


