Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958644ABBC4;
	Thu, 17 Sep 2026 18:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670477; cv=none; b=Gi+TI55IVTGIyGBDH/0Bd+RH353IuKeS2oL2BiBXBQSKCClTOEasCFiocY5BbeRDRhEIVgP+ADLvJf72saVwJP570x8AAjFvquhbDFsDyQUAUeDMK5YEOT5Dbgyn4z8xxAZ/V1Molj3KY3rkFgOO2nkPA99TmZutCFZ7s9NiUvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670477; c=relaxed/simple;
	bh=o0eybQrCs4QLn2cOnRUwE7T/fPR1CpKagi2if97eWtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chywvPthGFJwR1fTJwemccO7rpkHgmnqxJrYp1LQM3qjJTamb96krDriIoidaCKPPbJ41tEkPCfqP1jcoICjhK8ERpho4K1iea4IZJ+iuHErWHSTH+yjssJxp5TkZmIhqUZsjycSdtY5WUU6Dj2NVSVeTqdxicFDBWXSqIa4m7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITb3v3ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITb3v3ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A111F000FF;
	Thu, 17 Sep 2026 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670475;
	bh=5z9/OJtnGHHMSvjv4aFieMYR/AfjGUXZXm/5wmOzvF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITb3v3aidEEorlrcj+v1zz5i9fKcwzr/Dw5yEEr5BGWkyWpqgo6kVoh/kdAK/O8WF
	 5ma5fK+kUOlguc3D/Zx3oGU5Rwp3ioC8OVS/PQE0F/cVdXTZpk71LnU1m2UwXAc2Cr
	 1WbGyhNXc8N6jLCWYF5N4SxK0FE/f0zKNbx2BU+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0672/1102] eth: nfp: drop the replaced rule from the list when reprogramming fails
Date: Thu, 17 Sep 2026 16:10:15 +0100
Message-ID: <20260917151557.097186284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 108bb2142e3a12c9ad625ad662973127a113ddc6 ]

nfp_net_fs_add() replaces an existing rule by deleting it from the
hardware, decrementing nn->fs.count and programming the new one.  If
nfp_net_fs_add_hw() fails the old entry stays on nn->fs.list - only the
success path reaches list_replace() - so the list is one longer than
nn->fs.count, and it advertises a rule whose hardware entry has already
been torn down.

nn->fs.count is what ETHTOOL_GRXCLSRLCNT reports, so userspace then sizes
its buffer one entry short of what the GRXCLSRLALL walk wants to write.
That used to overwrite one u32 past the allocation; since the walk is
bounded it is a permanent -EMSGSIZE instead, as nothing ever resyncs the
counter.

Fixes: 9eb03bb1c035 ("nfp: add ethtool flow steering callbacks")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index d6e1998e55367..2e8343e647546 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1699,8 +1699,14 @@ static int nfp_net_fs_add(struct nfp_net *nn, struct ethtool_rxnfc *cmd)
 
 			nn->fs.count--;
 			err = nfp_net_fs_add_hw(nn, new);
-			if (err)
+			if (err) {
+				/* mbox broken, adding the old rule back will
+				 * likely also fail.
+				 */
+				list_del(&entry->node);
+				kfree(entry);
 				goto err;
+			}
 
 			nn->fs.count++;
 			list_replace(&entry->node, &new->node);
-- 
2.53.0



