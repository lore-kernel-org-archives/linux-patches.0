Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317F53E9C3D;
	Wed, 20 May 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298868; cv=none; b=uRkQlW4AZNbaMe4/PeIh9mDCumC8C3gXOeaRRCVHKpviu5cDPSZCJRqkAQnIvwL5ibdW3sEnpqszib7r2hfIbXaBYea5w+89xG2gCaOWBUEOaJ2x7TiuatinI+6srDxx9VWDPVblRV3YyeEcZpnwk0JDzgeeJEL5fPRee4sK30c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298868; c=relaxed/simple;
	bh=owq5UvBM1ShicPa2/29/FMs/NTB8LS4RO3fIBRIkn+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oD36rDhE22YE2883a8T++FJO89MpNq8f/EAgtOtdDJQN28qC6tZDMBVpF2s8kruC850w+rKcqpGuVJrUE8ipBxy/UtF0Ha/Cl6694saRherxFDGZGci/55GP3vECN+YyXr2P4jbQhN/nExG1AGUkA1San+Vv4SwclqI7rPvn9L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfOYYNED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfOYYNED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EAA1F00893;
	Wed, 20 May 2026 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298867;
	bh=WhkoSjLr6c/8Sl9i+hpXPb4FX4loWAb+Oqy//ZdFtDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfOYYNEDWfmi1mHvZODawo20O2sbYCPiXi///jukLvUOs61koqNJGnOU7NrE7s3d9
	 EvqpJbzSy1Y071V2GP837izJupVh2rliNYx0RnBYIQ8ftkNKs4yU3TgrH3xt9OR1Uw
	 SMeCpgguTUfXUm3h6BEg1ecLnGrmVaOeFsODB/7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 532/957] usb: typec: Fix error pointer dereference
Date: Wed, 20 May 2026 18:16:55 +0200
Message-ID: <20260520162146.070386365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit f2529d08fcb429ea01bb87c326342f41483f8b2f ]

The variable tps->partner is checked for an error pointer and then if it
is, it sends an error message but does not return and then immediately
dereferenced a few lines below:

tps->partner = typec_register_partner(tps->port, &desc);
if (IS_ERR(tps->partner))
	dev_warn(tps->dev, "%s: failed to register partnet\n", __func__);

if (desc.identity) {
	typec_partner_set_identity(tps->partner);
	cd321x->cur_partner_identity = st.partner_identity;
}

Add early return and fix spelling mistake in error message.

Detected by Smatch:
drivers/usb/typec/tipd/core.c:827 cd321x_update_work() error:
'tps->partner' dereferencing possible ERR_PTR()

Fixes: 82432bbfb9e83 ("usb: typec: tipd: Handle mode transitions for CD321x")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260218214621.38154-1-ethantidmore06@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 2b1049c9a6f3c..01c657bc84e68 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -814,8 +814,10 @@ static void cd321x_update_work(struct work_struct *work)
 			desc.identity = &st.partner_identity;
 
 		tps->partner = typec_register_partner(tps->port, &desc);
-		if (IS_ERR(tps->partner))
-			dev_warn(tps->dev, "%s: failed to register partnet\n", __func__);
+		if (IS_ERR(tps->partner)) {
+			dev_warn(tps->dev, "%s: failed to register partner\n", __func__);
+			return;
+		}
 
 		if (desc.identity) {
 			typec_partner_set_identity(tps->partner);
-- 
2.53.0



