Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E2A2BE039;
	Wed, 17 Sep 2025 12:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113487; cv=none; b=kxX9cuU4CYOKINv0dAsy24OBaVeBxzSxQ7fSPwzXiXqBR0YFjjQM7mju8Va7inDfd1r9zHu3bI43V8U9wwXzxMItJ1hI7cbVia+0mV1hAO1W5vS4rMXloVoHj3Cb1rIJ3ZSV/29D+eOwPtvGNNhznw1pSZc8+Oo/ifPsrz+6nyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113487; c=relaxed/simple;
	bh=Ny/E/coMCV/HawkHkmld9MCmY3sUqzEH0lViyoz/9oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC6xqXvoxviuZiuFwpCXI967joYlpVmnm6mUl7aMa04V5+dSSHS0G0kGth3HArK4X3XLOayhyxpIO+FkDVtgm8aKQdkvo/i1he+q2dnH/PwwxApc2xHkenXO5n2gtx5Enzp/DK1o0PR9jIVfY5oQzFT83mXEsbqr4f5356vuDM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cus8a4YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cus8a4YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A25CC4CEF0;
	Wed, 17 Sep 2025 12:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113487;
	bh=Ny/E/coMCV/HawkHkmld9MCmY3sUqzEH0lViyoz/9oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cus8a4YVsNYUH8OV7lPjfbic+kAXUG/mvUx6pzpqaGEGEruKM5ZxrE8NA482cjdPS
	 OPaAXaBRucda9jagYQnJtDBuSxV1/jb7cDPziOy8F9agqiZMUVik713bD6yMneohtz
	 W+RGS8iizdjEXp2SiobM9OYwtihpHCIbBuSD2b+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 101/140] igb: fix link test skipping when interface is admin down
Date: Wed, 17 Sep 2025 14:34:33 +0200
Message-ID: <20250917123346.770386518@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit d709f178abca22a4d3642513df29afe4323a594b ]

The igb driver incorrectly skips the link test when the network
interface is admin down (if_running == false), causing the test to
always report PASS regardless of the actual physical link state.

This behavior is inconsistent with other drivers (e.g. i40e, ice, ixgbe,
etc.) which correctly test the physical link state regardless of admin
state.
Remove the if_running check to ensure link test always reflects the
physical link state.

Fixes: 8d420a1b3ea6 ("igb: correct link test not being run when link is down")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index ca6ccbc139548..6412c84e2d17d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2081,11 +2081,8 @@ static void igb_diag_test(struct net_device *netdev,
 	} else {
 		dev_info(&adapter->pdev->dev, "online testing starting\n");
 
-		/* PHY is powered down when interface is down */
-		if (if_running && igb_link_test(adapter, &data[TEST_LINK]))
+		if (igb_link_test(adapter, &data[TEST_LINK]))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
-		else
-			data[TEST_LINK] = 0;
 
 		/* Online tests aren't run; pass by default */
 		data[TEST_REG] = 0;
-- 
2.51.0



