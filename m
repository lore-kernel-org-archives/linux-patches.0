Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE74C2750ED;
	Thu, 15 Jan 2026 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497140; cv=none; b=ccqQOVgJjStuYTe5tjHFBa9JWjUG8jd5D2DIoLrML4yOje2EK88Zxhw7//Z/RiBygJoPp/SCCd13mpwRP3b0tlvjNTGv6FN95jTEjz5PbOjOZyva03jvFJc+YO6pMG5g5Y4ZCgL3W/wF+FITtJ7waXMMjQC3yGq6DJ/UhrGwP3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497140; c=relaxed/simple;
	bh=7u1Ds5CxPNNcPFaqSvocMOgnA1Oc0YLkLU1U4dg0vwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJjgF9uUQ4u/3vXZtSHtB2umn8tSVf4/utvRqLxcCt3y+GhHf15AA3+IsoYcorXvBQDux3DDaRsiIOi0mz8AZNV1KDiEbJfL7TQzHJ06VyJPOz9C2clRuWlrf+SIEZvk1m7Dj2qrbvV/rhRZDULUuhVF5wtGZ47rD74zZfnnlBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCYTi0i9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCYTi0i9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C79EC116D0;
	Thu, 15 Jan 2026 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497140;
	bh=7u1Ds5CxPNNcPFaqSvocMOgnA1Oc0YLkLU1U4dg0vwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCYTi0i9PgWmfDd1wXenR+Grc5NBxIXoCyTLW+4Z2XKBvwjEo16Rj51LSjoTQHB6Y
	 WBRaZOuHr/MmocuEKMAEbU3SXv9FtuJOb4obmjV0sWoXpe7apBC3pLhAXVVHNOqhYJ
	 vXqYY//XAK7Iy49zXP7nRgwq4qCqcpSPk5n3OBjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/72] net: usb: pegasus: fix memory leak in update_eth_regs_async()
Date: Thu, 15 Jan 2026 17:48:59 +0100
Message-ID: <20260115164145.272691555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Petko Manolov <petkan@nucleusys.com>

[ Upstream commit afa27621a28af317523e0836dad430bec551eb54 ]

When asynchronously writing to the device registers and if usb_submit_urb()
fail, the code fail to release allocated to this point resources.

Fixes: 323b34963d11 ("drivers: net: usb: pegasus: fix control urb submission")
Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Link: https://patch.msgid.link/20260106084821.3746677-1-petko.manolov@konsulko.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 81ca64debc5b9..c514483134f05 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -168,6 +168,8 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 			netif_device_detach(pegasus->net);
 		netif_err(pegasus, drv, pegasus->net,
 			  "%s returned %d\n", __func__, ret);
+		usb_free_urb(async_urb);
+		kfree(req);
 	}
 	return ret;
 }
-- 
2.51.0



