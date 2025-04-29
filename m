Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576423E32B;
	Tue, 29 Apr 2025 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949781; cv=none; b=DgZJTMOsFxlVDlfmtzH66SFZ7JgUp9/ZBAI7wd/YJZ0kJ0NrXFB0ZDLRqnzU6smlSBaVHqTh+Bkvg9rcCWBigKfUnmKjsepE9F9Cf51LcVSodrJnmQzPJgzW2IhIWFYUyXrUqTCwQDdIan5KU0jS6V8lmt/T2CKPhx5NygNnqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949781; c=relaxed/simple;
	bh=EAuDTulO5sKl+OpTKbRvinuUz+eYwbrbwQrCpWQ5TIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxLfPRo4+4MeOhlipZioMkkcC55H2oPszlV0hxmRb31ZffTCvxM7zMYXEV6eIBJcemVxdgvl3WQGg71ill9Atqt+MdoryzFeoZWG8+ECARWERyJ1K2kXZAzm8+uU1SU5wI+WVobdj3SOu/88qmjiAAjCNaOMJoAS0zv4r225jQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCSrqJbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCSrqJbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A2DC4CEE9;
	Tue, 29 Apr 2025 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949780;
	bh=EAuDTulO5sKl+OpTKbRvinuUz+eYwbrbwQrCpWQ5TIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCSrqJbrOm5jIzo09MmGhtRiBoREh6ZnWC8Q1jloQJrxmETtvoY0GJNIOqO6Vb3aK
	 sbnsq8T5vjnOd22XTOiW3Qr7GTdce/XLJfn1CvocrTXdJrsu6Lsfpy2s5VFpnv7zWJ
	 mM0KZXU+rTJ5MNQh/kwSOh5lM5Q4Ax4ka69GVOVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/167] net: dsa: mt7530: sync driver-specific behavior of MT7531 variants
Date: Tue, 29 Apr 2025 18:42:42 +0200
Message-ID: <20250429161053.950437783@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1aba0cf38630f..308e56a73df01 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2558,6 +2558,9 @@ mt7531_setup_common(struct dsa_switch *ds)
 	struct mt7530_priv *priv = ds->priv;
 	int ret, i;
 
+	ds->assisted_learning_on_cpu_port = true;
+	ds->mtu_enforcement_ingress = true;
+
 	mt753x_trap_frames(priv);
 
 	/* Enable and reset MIB counters */
@@ -2701,9 +2704,6 @@ mt7531_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ds->assisted_learning_on_cpu_port = true;
-	ds->mtu_enforcement_ingress = true;
-
 	return 0;
 }
 
-- 
2.39.5



