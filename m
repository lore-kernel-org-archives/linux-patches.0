Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358804EFFAD;
	Thu, 17 Sep 2026 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659763; cv=none; b=N5lazgejwDmxHu31LeCN1qgVtwqMaX5Cn7++/bcS/VqkFcpYP5hz5sLZcoWHPzhttaaZ7RPotFoxVZtyH24SPFrx6V0y8FVmS9BgOtCbT4JlPAmpIhpppvg2OUODYrS8w94v106CJc/S4wGSUXH67EHQelUkU4NG+IixHzsCxGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659763; c=relaxed/simple;
	bh=bckBc08MKuzR7jVfwkR1KYghvG0IWYtGHDLoyxFKkJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onjImu0AA5DBwcH1I3eLucd6/rYapzfyqY7YeN8tzgqIEbcaJilHH0YoqgG2VpcAtEtdLcOyMo1b96diaLBK7G2gNrDpoLKhKpLX6DTOyMr+/sk98XkeFKwNHDoYJj4FjdZk/erB35tlyAJPkYxbRhBdV8BY2y2BWHkPKcUvSe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkTZB1vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkTZB1vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBDA1F00893;
	Thu, 17 Sep 2026 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659752;
	bh=2WwkQ/hUKyknJ6vt4d/ZYQDzvyw6+QzFiL7E09hxFis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkTZB1vq4g2DI81HdjkSmDXr8T6Pue6POvi+dRF/GQHJffjBnB0xXN5Jf72C7JrrO
	 gw6sMwRj1M+0e0BqlcG4ndJEOUhKzyHi8mWehhNhAH+UCVWKYjaYhdKvz2lKLh6Hdr
	 ktPDCVUIEJydGDbaI1DgM8b8LCEHgtwH4K2V0LvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 361/733] net: macb: reject an unknown link speed in the taprio setup
Date: Thu, 17 Sep 2026 16:11:09 +0100
Message-ID: <20260917151400.600003150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit 2b6c0e25a3d713c4032e45f212bdd9e14c50f8a0 ]

speed is a u32, so SPEED_UNKNOWN arrives as 0xffffffff and passes the
"speed <= 0" check, which only ever catches zero. That is what an
autonegotiating link reports while it is down: the limit derived from
the speed collapses to a nanosecond at most and the first entry fails
with a misleading "exceeds hardware limit". Zero stays covered, it is
what an interface that was never opened reports, and
enst_max_hw_interval() divides by it. Say which case it was in the
error.

Fixes: 89934dbf169e ("net: macb: Add TAPRIO traffic scheduling support")
Assisted-by: LLM
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260903123652.23900-3-f@lex.la
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 09fd83782ae3f..55ed40a0a6062 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4360,8 +4360,8 @@ static int macb_taprio_setup_replace(struct net_device *netdev,
 	}
 
 	speed = kset.base.speed;
-	if (unlikely(speed <= 0)) {
-		netdev_err(netdev, "Invalid speed: %d\n", speed);
+	if (unlikely(speed == SPEED_UNKNOWN || !speed)) {
+		netdev_err(netdev, "Invalid speed %d, link-down?\n", speed);
 		return -EINVAL;
 	}
 
-- 
2.53.0



