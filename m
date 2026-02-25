Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCBC21D596;
	Wed, 25 Feb 2026 01:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982900; cv=none; b=K//nACPKsWt8hH0ZQF5TY6Nizbtcc0WSzzOfhMdhydqE+yLXOLrC3UYg0eSsDYXCtn4xyD1+9BdS/3sBAo7HYt5bxzLk0cAX/jfsp4EAGXguRTV4EEDxiJjOcqWX8ZRmA9N9Knpuxrp/IOEDWMTOMHvwYHZbSDcb2rxrcKFtmSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982900; c=relaxed/simple;
	bh=xBh2HZiUWuHGCLXiqY/Dq/RuF3ertNRVsFDEcc5VQYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqvQq/g22sAA4izPh77HJ9eea5fkj4z4kcx+kGZKIEFF2TA1ZLm37nU9s0nwXqFLskU0xwQGykKYdDepTAthNpJg6HzmCsIRHWlf4d+tbMJu8pDJ5TZZxF+7+YLQTdJcFx/85En0eMRbzkze1Ru5PtENKW7/R0l7LYqoUKIuA1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjwobDym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjwobDym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11CDC116D0;
	Wed, 25 Feb 2026 01:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982900;
	bh=xBh2HZiUWuHGCLXiqY/Dq/RuF3ertNRVsFDEcc5VQYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjwobDymjlj/o641GXc9aOcWdIE35wDPkx7DbUB/j5d9bt27CGGn0gtKjCEa5WMCa
	 p1gsZpImNQBHav7NePJ9TxIy/ulHMJBfqXFbFiHdyxR8bhUkgTLLQGWO4iBSK744GX
	 F6DW16CVQOYhUf2bgGWDRwnRQIy3pxfeoHU95PDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 066/781] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Tue, 24 Feb 2026 17:12:55 -0800
Message-ID: <20260225012401.323144332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit f65c75b0b9b5a390bc3beadcde0a6fbc3ad118f7 ]

`css_alloc_subchannel()` calls `device_initialize()` before setting up
the DMA masks. If `dma_set_coherent_mask()` or `dma_set_mask()` fails,
the error path frees the subchannel structure directly, bypassing
the device model reference counting.

Once `device_initialize()` has been called, the embedded struct device
must be released via `put_device()`, allowing the release callback to
free the container structure.

Fix the error path by dropping the initial device reference with
`put_device()` instead of calling `kfree()` directly.

This ensures correct device lifetime handling and avoids potential
use-after-free or double-free issues.

Fixes: e5dcf0025d7af ("s390/css: move subchannel lock allocation")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 4c85df7a548ef..ac24e019020e8 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -235,7 +235,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	return sch;
 
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0



