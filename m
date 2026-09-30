Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBD64E50DA;
	Wed, 30 Sep 2026 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782587; cv=none; b=NGjF1PrhyjRx14xnwgzSiD0kA5SJlexhi47CdP+DdbvtHUoYlE6QmJbg25LIfeXQD5ItTXZvkl0KMB2xWvJzZqvnO8sxfKWwZUYYTQocE3HOq4x1ZAn0edQXALxhijuaNYtnVLLGPyYGS+r8pTTsaxkcucD0Q6s1JLeTb+09Z2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782587; c=relaxed/simple;
	bh=6mDwKMUDzQMfo/7CyiaNk/x+jNwlVTHJ2CTOea9ZyKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRvUqweG63vx1yM1tIse+yVrz+8rHcQ0E5IGoyeTWAFu58k/QHborEALW8Pu7fV3zEjoFHUdJf+s2/w613ojms0//wYqBMMfadECwfQpc8g8aK5KyASvqmF8gJYEOLLU4x+zc6GO6ccjQ6LdfU1mFG0sGd2D0ZTLFo9vPtu7AiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCE9+hze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCE9+hze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92541F00893;
	Wed, 30 Sep 2026 15:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782581;
	bh=erZpBsZ8ax/eRKL5gJbfWF13aHtmG5yboGN+Bzonl5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCE9+hzen+LcWCtFVPivT5IbCwcCnX1NZtwhpYHvwkNiI4hDzPrzhv4D2kUjqMz5L
	 hiQvXRZfQIraOL2Io1jrzryvqhCLFlmuhHDJAM6J5ons5rn8wTGp6qehCcnl4KcwVl
	 Brja/E8AT4ZyHaaaFe1+XNbdCq5w+x11ZJbdfW1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/595] net: dsa: sja1105: flower: reject cross-chip redirect
Date: Wed, 30 Sep 2026 17:19:49 +0200
Message-ID: <20260930152349.803003808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit cfa5274a5dc2a23b957da5dc806d2ac0c7a66af0 ]

dsa_port_from_netdev() may return a valid port from a different switch
chip. Programming another chip's port index into the local hardware
causes redirection to the wrong port, or an out-of-bounds access if the
index exceeds the local chip's port count.

Apply a minimal fix that adds a check to catch this case and adjusts the
extack message. When cls->common.skip_sw is not set, the operation could
instead redirect to the upstream port and let the software or upstream
switch(es) handle the forward, but that is not addressed here.

Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260530003940.2000994-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 12e76020bea37..6cbe4ee310eac 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -345,9 +345,9 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			struct dsa_port *to_dp;
 
 			to_dp = dsa_port_from_netdev(act->dev);
-			if (IS_ERR(to_dp)) {
+			if (IS_ERR(to_dp) || to_dp->ds != ds) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Destination not a switch port");
+						   "Destination not a local switch port");
 				return -EOPNOTSUPP;
 			}
 
-- 
2.53.0



