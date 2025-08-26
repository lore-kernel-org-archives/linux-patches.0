Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908B02135B8;
	Tue, 26 Aug 2025 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218702; cv=none; b=Gh1tA+E4hcneER0CmILW2I8o7EIZ0JCoWTO0BAw8wU4JWx51gh+EQYsNwj8ZHP+I9Tjwjpz4IcdVU7glaGgoSpxLwQ7xlANxeDt6Qm4RS7/4w3AQnJGEKla0I7jYT/u80B0Kvp/+TNZsbLjv575/jMYLVFity/Kh44rE15SIkGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218702; c=relaxed/simple;
	bh=LaZYdq5mvPVW+hpwd+iEFfX/bRrSeopbbWPZQj8KbbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRjC1DewoOarsmFq/50uSuBDh/mKQXrc3any/Wu9vlOUfLh82yoInXC8t18OS0FEbVsZFjG0dI1b4up6taTrXF9/H2+oA1bJeedlkbMVS9KfMOppZPAQPjRZe7R4D8yxOTI1oSjxsH6KiQmemkF1NgPp0A99Rx4MJD6HSNqTnFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU8QL85i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU8QL85i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A02C4CEF1;
	Tue, 26 Aug 2025 14:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218702;
	bh=LaZYdq5mvPVW+hpwd+iEFfX/bRrSeopbbWPZQj8KbbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iU8QL85i8/0ohVebqo2cWW0g9tkZXHj+JE17x+DtLUWqJ3RrCbZWqjzk1qHbS15+W
	 Ms/qy9JlyTqnF6Lcnyd+xWSopWgY3L1PCyUnPNQkfPozZgOBHI2D4mIVv2kODWXHrP
	 VUemAiYZ5NXNTDqGCLuDmHGuamuEWFPW+W8niwww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/403] can: kvaser_pciefd: Store device channel index
Date: Tue, 26 Aug 2025 13:07:06 +0200
Message-ID: <20250826110909.437338065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit d54b16b40ddadb7d0a77fff48af7b319a0cd6aae ]

Store device channel index in netdev.dev_port.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250725123230.8-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 560a0a5ba6f3..f269b5faa03a 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -953,6 +953,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->err_rep_cnt = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



