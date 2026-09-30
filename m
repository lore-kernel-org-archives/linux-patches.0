Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4EA51FCA9;
	Wed, 30 Sep 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790905; cv=none; b=Kfay/OD5e73QPi9679pN/4K8XXwhV5X1LeYqSUmuAZJFopmm1aaBVeYelWZSCtCGE3SxYZbH9bXALQCpCjO9WCQPqUGV+Wym/u6vASJCr68dJXMz47T0XslASnm7MTMDvGzgbYrh9BlKP/HY+NoHBxmXeYhsvqAsbjtGaH3+tRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790905; c=relaxed/simple;
	bh=rLVbCR8wtOBgjfRYflbBitmnm8CjDN6xgMalR/wt7x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfUXhAubWJpDzAElsnIViSBrTl1WjP3cfICLGYh962qXyuCEdXqhTeNAdY3Wb17TRBv21Ja+IWzKu82NfgYKTuFLqn1wHRMHC9pWGT5niZJZlXa+wu87VFFgy5oE3BDRYARiLaBXkyPoUBJoKO4hh9JIRsg1OEFeDSGl7UkZaYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEYprScn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEYprScn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4CA1F000FF;
	Wed, 30 Sep 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790903;
	bh=boxOFu7icq/QV2F+KLxu72vZ9gA9hfsffeD9aB8jFB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEYprScno8EawEch7BhyW4m9t8jBIEsbzAZmODvxqVMPiqI9tvy+MPOSmdoeBtx4L
	 UXrskghlli6NxMzrJgZTMB0/RTQv4MfMYjz/ipNzrkVZhmRNTagSnH0VAZ48ADqe5W
	 T+Ydr2kBV/mXLGsf60kJROnfNzu4f5bf6/6vc1YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/752] dpaa2-switch: fix handling of NAPI on the remove path
Date: Wed, 30 Sep 2026 17:19:44 +0200
Message-ID: <20260930152400.639887470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit e23d7c8c1d4ba435c457d7ffb2669175ec819b07 ]

All the NAPI instances for a DPSW device are attached to the first
switch port's net_device but shared by all ports. The NAPI instances get
disabled only once the last port goes down.

This causes an issue on the .remove() path where each port is
unregistered and freed one at a time, causing the NAPI instances to be
deleted even though they are not disabled.

In order to avoid this, split up the unregister_netdev() calls from the
free_netdev() so that we make sure all ports go down before we attempt
a deletion of NAPI instances. Also, make the netif_napi_del() explicit
as it is on the .probe() path.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260528173452.1953102-6-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c   | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 811b9e4eef372..d29286ecfe2fb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3273,7 +3273,6 @@ static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 
 static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
-	struct ethsw_port_priv *port_priv;
 	struct ethsw_core *ethsw;
 	struct device *dev;
 	int i;
@@ -3285,11 +3284,17 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
-		port_priv = ethsw->ports[i];
-		unregister_netdev(port_priv->netdev);
+	/* Unregister all the netdevs so that they are brought down and the
+	 * shared NAPI instances gets disabled.
+	 */
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
+		unregister_netdev(ethsw->ports[i]->netdev);
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		netif_napi_del(&ethsw->fq[i].napi);
+
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
 		dpaa2_switch_remove_port(ethsw, i);
-	}
 
 	kfree(ethsw->fdbs);
 	kfree(ethsw->filter_blocks);
-- 
2.53.0



