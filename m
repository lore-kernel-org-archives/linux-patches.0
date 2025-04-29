Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFAD221570;
	Tue, 29 Apr 2025 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947801; cv=none; b=PFeVoByckrIsRgwQBv/bAKL/mwCvsye9DyYwJpWAN4F+49k9z/X3rGuVto5QxkTBj4TBXTj5jRt3ayS6Sc3MSQYccLXiSAabo5hzwJlmwCHxG8Zdf4GLQQXnBygeJYYSgUlzRMTxHPcj/t6okmlba/FI+u3zMAnZIEzCfFjPO2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947801; c=relaxed/simple;
	bh=vYnH6LW6pFc54DzDzQpiPwBS37JJZs9zHMb8p5A+bNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV+nQi+ModjexI5ilcd7AXeY4CTUdBD4ng7XBMRpNkUP5KP6gOl0TdWBYwAwiNnt5mIJDpKiS5p6BwWC7SJLZHG8yERrch12Zl1fyaSNybfRKHFfJ1Yi2nseoAzAMKf36AUCaNcYsKQtKZ3YMS7/WdSFSpIsfPbM1vsCaytHuiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cssjk4sT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cssjk4sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C75C4CEE9;
	Tue, 29 Apr 2025 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947801;
	bh=vYnH6LW6pFc54DzDzQpiPwBS37JJZs9zHMb8p5A+bNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cssjk4sTi0aR32to8gORIF+Us9sp8Oz+gNOXBOK3yK6BNeQ5jU4OdUBoHXtLowV7s
	 taD78NVi+WUIK54wQucqDqvkIxvxPypCm8DJrJpqa14tPUUdsv5nUWKXFQkVirW6RS
	 g9ZYtpUndil63cs3feyjjj2FZEqlJ2CnRh8QvsAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/280] net: dsa: mt7530: sync driver-specific behavior of MT7531 variants
Date: Tue, 29 Apr 2025 18:40:18 +0200
Message-ID: <20250429161118.258758807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 497041d763016c2e8314d2f6a329a9b77c3797ca ]

MT7531 standalone and MMIO variants found in MT7988 and EN7581 share
most basic properties. Despite that, assisted_learning_on_cpu_port and
mtu_enforcement_ingress were only applied for MT7531 but not for MT7988
or EN7581, causing the expected issues on MMIO devices.

Apply both settings equally also for MT7988 and EN7581 by moving both
assignments form mt7531_setup() to mt7531_setup_common().

This fixes unwanted flooding of packets due to unknown unicast
during DA lookup, as well as issues with heterogenous MTU settings.

Fixes: 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from mt7531_setup")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://patch.msgid.link/89ed7ec6d4fa0395ac53ad2809742bb1ce61ed12.1745290867.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index abc979fbb45d1..93bf085a61d39 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2540,6 +2540,9 @@ mt7531_setup_common(struct dsa_switch *ds)
 	struct mt7530_priv *priv = ds->priv;
 	int ret, i;
 
+	ds->assisted_learning_on_cpu_port = true;
+	ds->mtu_enforcement_ingress = true;
+
 	mt753x_trap_frames(priv);
 
 	/* Enable and reset MIB counters */
@@ -2687,9 +2690,6 @@ mt7531_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ds->assisted_learning_on_cpu_port = true;
-	ds->mtu_enforcement_ingress = true;
-
 	return 0;
 }
 
-- 
2.39.5



