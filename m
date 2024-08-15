Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0BC1A00D2;
	Thu, 15 Aug 2024 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729591; cv=none; b=bJw5+s8r2q/l3hN3bdLCwFZ9eAG/pkZs88juuwMlx5HuSfp7NYRyICtASwidUTVIb9XXUa9nQ1FOMdiDgrK3nqnidTosn8xciohTPcmXl9Nuck3BZW4JsIjRtwZZJyEy48kpO8NexgC2G7gazlYDDUy04AGq4qVTuj450OdIyRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729591; c=relaxed/simple;
	bh=B7DKa0WZ2k5e3H1KzDsQ98eFpPwjydiCTKTqddl5t2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDvqlBbuKCLE0631yu17DGkcsH6iOk25Mt4SD/zOUykPaBoFl6Whb3j+95VG+7DgNlzTgpspTLdMK3kaDT2CBiJEoAj+U1qM1hn3GGY6DGrWFC+ABnK8XozYGrdO2lYnZtNmBc3monprQiJXIRpklnU8z7A6QdJ7JzJwMWvEFRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPYC0A1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPYC0A1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33958C4AF13;
	Thu, 15 Aug 2024 13:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729591;
	bh=B7DKa0WZ2k5e3H1KzDsQ98eFpPwjydiCTKTqddl5t2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPYC0A1exSnM13OufUuPyjHSzZ8BNRBIlbhHJVxkZmUCMyZDSAgXAhwHs/7mYP4T8
	 4tb5rWk+9pZ8bAEmRZythQ4nbx6skPhyi2JRmDxTNaAc05BhTAObkGuoty2lRmRr8m
	 izoTzxT1B3Oi4biuzD0tcXI7ye7dTceTNAZUi0RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/484] net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports
Date: Thu, 15 Aug 2024 15:20:05 +0200
Message-ID: <20240815131947.095279299@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 66b6095c264e1b4e0a441c6329861806504e06c6 ]

Marvell chips not supporting per-port jumbo frame size configurations use
a chip-wide frame size configuration. In the commit referenced with the
Fixes tag, the setting is applied just for the last port changing its MTU.

While configuring CPU ports accounts for tagger overhead, user ports do
not. When setting the MTU for a user port, the chip-wide setting is
reduced to not include the tagger overhead, resulting in an potentially
insufficient maximum frame size for the CPU port. Specifically, sending
full-size frames from the CPU port on a MV88E6097 having a user port MTU
of 1500 bytes results in dropped frames.

As, by design, the CPU port MTU is adjusted for any user port change,
apply the chip-wide setting only for CPU ports.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Martin Willi <martin@strongswan.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7985a48e08306..2a55ecceab8c6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3104,7 +3104,8 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	mv88e6xxx_reg_lock(chip);
 	if (chip->info->ops->port_set_jumbo_size)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
-	else if (chip->info->ops->set_max_frame_size)
+	else if (chip->info->ops->set_max_frame_size &&
+		 dsa_is_cpu_port(ds, port))
 		ret = chip->info->ops->set_max_frame_size(chip, new_mtu);
 	mv88e6xxx_reg_unlock(chip);
 
-- 
2.43.0



