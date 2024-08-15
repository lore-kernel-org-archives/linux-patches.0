Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2265B1DFFB;
	Thu, 15 Aug 2024 14:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732227; cv=none; b=A4XihtzNwaZwnXif9Fu5R7txtwSHVcdUD6e5PqluAGwsoekAFu//IaOZA5x7ZBbS3+2QgshrvV/cgRsVQ7/Ljmfv6VVLN4H3ClGbE+cAWVS3uvEWDKWz14j9rmd5cQXvigt8ORE5taztMifwQxMeCdedBJAytskqmQNJ07Oja6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732227; c=relaxed/simple;
	bh=RLzzB7ShZEKRUeCh9DaoVxphfcYkBgRyqe5Unr6b1Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McF5ewIdBfpKdBwt17E1XQ/Hpd9HnPUz9Kjkajm/79m7a0npB3UAxx6XZk2Q3VgiGKnHuYCiJN6GzC0UKXc0aXBnoJ1O85lnEdKrAhGFAMQVVI4pJRubNJurMjQ3tUnydHTCEaEu2+oJ5oxzTHq6vDTMNcqLhMXH/UCIW1cXPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3jLG+Pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3jLG+Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2E3C32786;
	Thu, 15 Aug 2024 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732227;
	bh=RLzzB7ShZEKRUeCh9DaoVxphfcYkBgRyqe5Unr6b1Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3jLG+PziU90mFoWw8j1E4yA79mkEwyUozNL3rDvKsfyqs5TwElNdbJI7Xtm1kWym
	 ohKlPsXl/rHE2O9sNXhqJmJiWxAbhvn3B6eHN0M8X2RlqHbE2MniZiCfMEBRARrMCC
	 i3UchF9h/KmfZv+7LB2L9VBUhfhhIVvY3/uJSWI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/352] net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports
Date: Thu, 15 Aug 2024 15:22:58 +0200
Message-ID: <20240815131923.585140801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6a1ae774cfe99..c7f93329ae753 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2774,7 +2774,8 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
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



