Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B655D3A1B6;
	Mon, 14 Oct 2024 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919902; cv=none; b=Ew6j/8AiSLjmUb0wZCukT3BWASxO3sPl2190XRPUkfCiO3oPHxxNv2qlsC3/QwQlH1yv/Kx5rW9/MEd1u9ZnmEzUWZrnRLQLmZ75MgMnsuVlI6JWjXR0EiJWoZr4ZjO/vBUYj3BSbKDLK9IDlwHo7mF+MNHhVmyt7dkUwmQOrZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919902; c=relaxed/simple;
	bh=a5p7A8cHH4hiYSPILJjwBYPu7WhCpgFF+zDnDNrmr3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpP6jT7ETUcfn3AENzQ9R0KbP3N3ANbyRrdQYq60aaWsQ0RMFmnQSd0VEegBM1NqPJXkSZ0wpEw1rd67A+UWNJ6Eele8P1QB74KEFQ4RVMm0cF5v7+oxwbnOgLChm8aXOSnDD2IamVjP//GB+HEzevJmQw4u45B4EpGaU3YZ6Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElgowFa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElgowFa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B673C4CEC3;
	Mon, 14 Oct 2024 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919902;
	bh=a5p7A8cHH4hiYSPILJjwBYPu7WhCpgFF+zDnDNrmr3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElgowFa4oOmnuAJOdETRy3PB/7La9mQJuDAl+1lcvuUduAok06U71HtK6oXOm5NPK
	 q8sCw0eqlHdNPPnhWp1DHNBEuIrsf9UftdVR/XnJm1VM2IMNZrG3mfeD2/k760bNMT
	 7X4TgtGOxnabVVjrd4tOUBHOXL3c2AN7D68GYQE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 741/798] net: ethernet: adi: adin1110: Fix some error handling path in adin1110_read_fifo()
Date: Mon, 14 Oct 2024 16:21:35 +0200
Message-ID: <20241014141247.181048226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 83211ae1640516accae645de82f5a0a142676897 ]

If 'frame_size' is too small or if 'round_len' is an error code, it is
likely that an error code should be returned to the caller.

Actually, 'ret' is likely to be 0, so if one of these sanity checks fails,
'success' is returned.

Return -EINVAL instead.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/8ff73b40f50d8fa994a454911b66adebce8da266.1727981562.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 7474afc0e8e73..5e17d107f3623 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -318,11 +318,11 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 	 * from the  ADIN1110 frame header.
 	 */
 	if (frame_size < ADIN1110_FRAME_HEADER_LEN + ADIN1110_FEC_LEN)
-		return ret;
+		return -EINVAL;
 
 	round_len = adin1110_round_len(frame_size);
 	if (round_len < 0)
-		return ret;
+		return -EINVAL;
 
 	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
 	memset(priv->data, 0, ADIN1110_RD_HEADER_LEN);
-- 
2.43.0



