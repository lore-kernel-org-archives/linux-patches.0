Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C781A618E;
	Tue, 30 Jul 2024 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356865; cv=none; b=oL6qJcRLTf/6IwKxCQPKO0CHM6YYf2kIORW4da2jd34Ln4USRgNyPRm/9OyNlVgzSOxeeUONxPnNLTtkE/ak406LHPKb3MgTSNXVhmJuoG9fuWYE+CbadoWuvhG/FEUKrIKQmTKjM9anDpCzrq9RBwMmcCtMjQVDkJfhhwCaKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356865; c=relaxed/simple;
	bh=ixfi1qG4oQyq07OTPjjm2Oc6CG8iVuwzqVJwP68Gn/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqkGbX82zyBVHy6yOAOr8K/GGM0DEK/qQIcnw+d8NnTSFI4c2jfHOYkg4Hln8r6NP/BQA91PBpv9XF7PjGVl8rcWbQnl1dKMjh88vpCyOz3U6FotVa903cr85OIBzOEMiik2iz8umCJSiKaRceTdPfrWDUQ3hMhw+RtCCBwzq78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKWWi51I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKWWi51I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68493C32782;
	Tue, 30 Jul 2024 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356864;
	bh=ixfi1qG4oQyq07OTPjjm2Oc6CG8iVuwzqVJwP68Gn/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKWWi51IlLrbmN/O3M88YKyzIfcNJBFtGYIYkLb41uCW9e4h480HQY61GFzeKp+IP
	 y2CgRrIQkVjMLD6AxNBYwqr5VaXP4WkmwDTZv3wK0f43zuP5NzHOM8kCY5aFaUlgm7
	 ha3XYoG/ZMPboSBzsqQKlPRhDHTsmnBZlPdubu9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/440] net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports
Date: Tue, 30 Jul 2024 17:47:49 +0200
Message-ID: <20240730151625.072298318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 4938550a67c02..d94b46316a117 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3606,7 +3606,8 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
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



