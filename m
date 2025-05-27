Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6201EA91;
	Tue, 27 May 2025 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364526; cv=none; b=ubx0hciW2X3PhtEVs+PDpTbdLc1s+CoRhE9arsri/Z+L77uttB5rUlZKdZnScnEY/xZrzzNDybUJrCm/KxrvWnj8Nos06Gw4om2cr027kWsvKXKCTQZwcCxglIsdsw30kG2DpVRf1xqY/1oi1UtUSRzOXzWREmiumI7WZkhuLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364526; c=relaxed/simple;
	bh=ga4BbDvBcL+ZFH7VtU9ntDvgBJocZ+Poke1WRx/8LNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLs1ZJcWyT/uHdbv/C23W1nJLxjd0xNbD8GISuE/RMwgoRcnfDsmszP3qaZPzVo2VrYrWfMuZ6TyKbNKAA25O/SJKf8ob8gTURu7Zv9ef0lKPC8a1iByMtt/jcsF7HhbpdokRC0qA53N2+VHnhpzR0TW5RN+y589CSWjUGFH2k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFrQ6vwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFrQ6vwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943DEC4CEE9;
	Tue, 27 May 2025 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364525;
	bh=ga4BbDvBcL+ZFH7VtU9ntDvgBJocZ+Poke1WRx/8LNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFrQ6vwAuKzH7knBqf+JJdnSZ8oSyuVincoQY+qI0/lgVEPcGDqMGpBdkZflYXe1D
	 5ZTnh6Twb+b2pcJz8O6Rtl29kLnm1x0wBiQRhghZBLnq28Vk97lBpNN+Nj6VCdWxwI
	 Lvx3AB2pIM6G3Pc20CddA4ibOufe97/Jztciq+Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hsu <Daniel-Hsu@quantatw.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/626] mctp: Fix incorrect tx flow invalidation condition in mctp-i2c
Date: Tue, 27 May 2025 18:19:30 +0200
Message-ID: <20250527162448.178621249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hsu <d486250@gmail.com>

[ Upstream commit 70facbf978ac90c6da17a3de2a8dd111b06f1bac ]

Previously, the condition for invalidating the tx flow in
mctp_i2c_invalidate_tx_flow() checked if `rc` was nonzero.
However, this could incorrectly trigger the invalidation
even when `rc > 0` was returned as a success status.

This patch updates the condition to explicitly check for `rc < 0`,
ensuring that only error cases trigger the invalidation.

Signed-off-by: Daniel Hsu <Daniel-Hsu@quantatw.com>
Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 6622de48fc9e7..503a9174321c6 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -538,7 +538,7 @@ static void mctp_i2c_xmit(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 		rc = __i2c_transfer(midev->adapter, &msg, 1);
 
 		/* on tx errors, the flow can no longer be considered valid */
-		if (rc)
+		if (rc < 0)
 			mctp_i2c_invalidate_tx_flow(midev, skb);
 
 		break;
-- 
2.39.5



