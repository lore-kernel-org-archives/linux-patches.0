Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9C01A01C0;
	Tue, 30 Jul 2024 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359424; cv=none; b=XB/CEOjyky57sQdi0kBm+87cD2yYZN3RoBcUniJ/WOwexLAeoJ/2ZPDJ+wvBNqP1cIjig/NOTymPE5Y75WZYMN+LU6afIXxnNcoaZhcZeCEhy8+4bV6fSRL7hFgPXErTWTqpNEsYIwkkFuBfVsoA9/1TfnmSlZ+1WEAFquA2rAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359424; c=relaxed/simple;
	bh=0IHRJ7MVnnZgCw9Tdjl3AJ2anIEal3qzzIs0BZljTLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqDXc/W5cjiXyABWCrm0RuaaWFehDqhQWf1bBMHMSSK+mD/Nc8NYhc2Big1h5G+alRCwe4j7E1xxEpPC+RVOpp/lprIvVGbIucLFsph71Q32vJ99J5qpqVMheFe5bBcnXYfRtadbNTPr6x//QnOaBuZSgkd3/NvV+QjUERQJrRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZMnkBjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZMnkBjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2357BC32782;
	Tue, 30 Jul 2024 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359424;
	bh=0IHRJ7MVnnZgCw9Tdjl3AJ2anIEal3qzzIs0BZljTLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZMnkBjyVKHQK9tvLxejxUHIUXvRBH+2QcUVZ9xIMg0NWYWLPz9isoMgKa8/kUM9w
	 CKWFdkbW9JnF2wzPybA1cjgG5iwZmCjrl8/ZrqUeMxt5tM7/mcSEom8MAwPDB1CN4Y
	 TYv8ioK0zkg4kwwpde6c9aK/dn3rHI9xzBq0GOlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Martin Willi <martin@strongswan.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 482/809] net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports
Date: Tue, 30 Jul 2024 17:45:58 +0200
Message-ID: <20240730151743.774604960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07c897b13de13..5b4e2ce5470d9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3626,7 +3626,8 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
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



