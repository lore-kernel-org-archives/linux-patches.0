Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B8E3ACF0E;
	Mon, 23 Mar 2026 14:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275310; cv=none; b=k76/glXrb3RTA/yz68trk8hO+w/AE5qIIYZT7GIpi5Ousxekyf9SUzGsiS+maM0Ya5EAK9dSzFOIwShCxwWpFYGfBOeG83mE5wDsszjk9kLulwVn53fDo9whyHqugL8Mn4Y3Amw79M+4n8V8MdyMTPOfX/p/rgqhb/x+iWi3bDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275310; c=relaxed/simple;
	bh=NAw+BDBcc+G0MACJqPxTq+HoV7VkiIU2HtyZqQhEzg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc5P1crkK+WjsjPEejOscOLVWn+ktN+0GjnAvveHnK90r5eY0jTPE7veExAuR+m9cNcomg+nYsdHEeM67qepgUDHJ2QMDvUtZeGHtabnTS9PWpP+on/woaE1uovxl6aSMNzp35TjVj/f8dG+JpscR895OmZG/wqO00whz9OphiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5vIukTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5vIukTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DACC4CEF7;
	Mon, 23 Mar 2026 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275310;
	bh=NAw+BDBcc+G0MACJqPxTq+HoV7VkiIU2HtyZqQhEzg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5vIukTyaWZZgSGqBKrJnVRIMtGF+TEqC/iZ6ikBdqxer3boAF3NTtVJZJ3ra25zp
	 Nmnl+wj50KIou7wOi4D7FYTL/cB/eCwz0EpRmhR9wODj5r4QQqcoFQ0PQsacx6Aixv
	 4+rgi8V14XKwS4obpNPfOJBleFbJTg7JxTX/SEMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyue Wang <haiyuewa@163.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/460] mctp: i2c: fix skb memory leak in receive path
Date: Mon, 23 Mar 2026 14:40:45 +0100
Message-ID: <20260323134527.917088923@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Haiyue Wang <haiyuewa@163.com>

[ Upstream commit e3f5e0f22cfc2371e7471c9fd5b4da78f9df7c69 ]

When 'midev->allow_rx' is false, the newly allocated skb isn't consumed
by netif_rx(), it needs to free the skb directly.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Link: https://patch.msgid.link/20260305143240.97592-1-haiyuewa@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 617333343ca00..f8f83fe424e51 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -344,6 +344,7 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 	} else {
 		status = NET_RX_DROP;
 		spin_unlock_irqrestore(&midev->lock, flags);
+		kfree_skb(skb);
 	}
 
 	if (status == NET_RX_SUCCESS) {
-- 
2.51.0



