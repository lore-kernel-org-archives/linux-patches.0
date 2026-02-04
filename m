Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8160B35029F;
	Wed,  4 Feb 2026 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217151; cv=none; b=TETDrZpaudxxKHQadg/dasa+ENoAXKXEBJT1SWso6VxEhKPN8UvuwxdsJTM+Sb8VUPw0asYn7/+VW9KkLG3p223Y70I9aD4swjrURFkLT1kCapeytMX4JOjT3lQyYoe7eE/oIuqK7frZRUEBLzwkvTqRs7I5wzUp5svLlWOzNUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217151; c=relaxed/simple;
	bh=Ab/ipPPR0/WSKS6m7KKETOPMl2d7bTLkZlmvZM/ODfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntuoiHoeDgvMVIkWzqg1x1spRB9+ZfLBVcrKPqo1GsPM+5RpF+PzGtrNZy+ZAKPwivkuqaTpzB8ql2sPS8J1rRqQmxWRwWnG+Bhy3ty0OSEu6euxnJx09yZda9ykrXbhEX9cA/rH7DtjncL9yL6+AqiGNAeS6EnKrT2gkHJOovw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0HgGyWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0HgGyWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB298C4CEF7;
	Wed,  4 Feb 2026 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217151;
	bh=Ab/ipPPR0/WSKS6m7KKETOPMl2d7bTLkZlmvZM/ODfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0HgGyWi2jWYHU+mt25rRT2cDl5sHw8jZ2tS7+cZrBnq4hvsou/ZZ/b1RS0g6vNbN
	 L6EJw1iKtSBxAvpF3eztG24idZ//K59/m+opOX9MsuEQX1gMZF1/X1Oo2etWroUlHM
	 SyqUmgCGDlrRGApTQTpVtPVxlG65rlEHSxLbpb4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/206] rocker: fix memory leak in rocker_world_port_post_fini()
Date: Wed,  4 Feb 2026 15:39:30 +0100
Message-ID: <20260204143903.211948729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 8d7ba71e46216b8657a82ca2ec118bc93812a4d0 ]

In rocker_world_port_pre_init(), rocker_port->wpriv is allocated with
kzalloc(wops->port_priv_size, GFP_KERNEL). However, in
rocker_world_port_post_fini(), the memory is only freed when
wops->port_post_fini callback is set:

    if (!wops->port_post_fini)
        return;
    wops->port_post_fini(rocker_port);
    kfree(rocker_port->wpriv);

Since rocker_ofdpa_ops does not implement port_post_fini callback
(it is NULL), the wpriv memory allocated for each port is never freed
when ports are removed. This leads to a memory leak of
sizeof(struct ofdpa_port) bytes per port on every device removal.

Fix this by always calling kfree(rocker_port->wpriv) regardless of
whether the port_post_fini callback exists.

Fixes: e420114eef4a ("rocker: introduce worlds infrastructure")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260123211030.2109-2-qikeyu2017@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index e1509becb7536..a7495a46d0943 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1525,9 +1525,8 @@ static void rocker_world_port_post_fini(struct rocker_port *rocker_port)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
-	if (!wops->port_post_fini)
-		return;
-	wops->port_post_fini(rocker_port);
+	if (wops->port_post_fini)
+		wops->port_post_fini(rocker_port);
 	kfree(rocker_port->wpriv);
 }
 
-- 
2.51.0



