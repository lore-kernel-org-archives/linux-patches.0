Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8C749D58C;
	Thu, 17 Sep 2026 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665706; cv=none; b=q1JtZM0Fx2diS8/P+vEKyJggi/D4tbNAxHxwLuGv4zHlsr/p5k9y14pUvquLFsf5O8ui8yakhKPvZWxi3Kntwh6e2VPwaj5EpJaIK0GGDQCAV8PH+/RY7hoJqe1niIw4kj2yCxknjtCxmmxpTRfz3xV/H4+VvjuLqoGb4WOhPFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665706; c=relaxed/simple;
	bh=58Pxqf6TD7In/cNttfxogHm88IPoUnhYPXnBMm6hceY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIrnCXRcRB1iVmah7Zuv6q/A/xiSuxBtqyPUifkIUTGtK19wLdSytNiExig0PC9R8dlaihPaLCMC1bWkJHQ6V+H9Q0LBWvwe8bKVMesm3lxzRhiGUojjNHrE+wZUG9RC4p5mr3AM3ewC0+Qz6vNhwyvfGKrHIy0+yZO14OZxpBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5hZCrD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5hZCrD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C1B1F000FF;
	Thu, 17 Sep 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665704;
	bh=0peRlPws8nUJtaHo3bzRy58Qb7o+Bi3A8BxbGXP2xSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5hZCrD/qjfHlFwP5W21/FnUbltmiCLPpkMFc3EiyxDDCFGvYSOFAaI0KMTl5JMTn
	 hRfgZEJBrXFLv19oDTqE9l9YZNt7Jl/4V5U9MmeKPRz18qpIqcHVpbUF1LmbPGX5+O
	 X1eRXupZZrvp+YQOcJyFlFcuV96vRUJijb0vb3XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0793/1250] net: dsa: mv88e6xxx: bound the policy rule dump by the callers buffer size
Date: Thu, 17 Sep 2026 16:09:48 +0100
Message-ID: <20260917151613.390665016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b1fffc273112e7284c5b705e186b43b5770cd3d5 ]

mv88e6xxx_get_rxnfc() uses rxnfc->rule_cnt as the write index while
dumping the policy IDR, clobbering the input value before it has been
looked at.  That input is the number of entries the caller had room for.
ETHTOOL_GRXCLSRLALL requires no CAP_NET_ADMIN and the ioctl sizes the
buffer from the rule_cnt userspace passes in, so once an admin has
installed policy rules any user can ask for fewer slots than there are
rules and run off the end of the allocation.  A rule_cnt of 0 leaves the
buffer pointer NULL and the walk dereferences it.

Count into a local so the caller's limit survives the walk, and stop with
-EMSGSIZE once it is reached.

Fixes: da7dc8755304 ("net: dsa: mv88e6xxx: add RXNFC support")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7e294f2104b86..e9270c266884c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2439,6 +2439,7 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 	struct ethtool_rx_flow_spec *fs = &rxnfc->fs;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_policy *policy;
+	u32 cnt = 0;
 	int err;
 	int id;
 
@@ -2464,11 +2465,18 @@ static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
 		break;
 	case ETHTOOL_GRXCLSRLALL:
 		rxnfc->data = 0;
-		rxnfc->rule_cnt = 0;
-		idr_for_each_entry(&chip->policies, policy, id)
-			if (policy->port == port)
-				rule_locs[rxnfc->rule_cnt++] = id;
 		err = 0;
+		idr_for_each_entry(&chip->policies, policy, id) {
+			if (policy->port != port)
+				continue;
+			if (cnt == rxnfc->rule_cnt) {
+				err = -EMSGSIZE;
+				break;
+			}
+			rule_locs[cnt++] = id;
+		}
+		if (!err)
+			rxnfc->rule_cnt = cnt;
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.53.0



