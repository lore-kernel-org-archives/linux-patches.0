Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472533593B;
	Wed, 17 Sep 2025 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113961; cv=none; b=g0I+qRJPoY6a7eqZPGOPTRXBeIjBaQK+2QZV7M9iPJCP+2Auiq8BR+s8CH+IU5c3yGHDNHfkXAyJlB19epvQg9UiBLYTmMcRj3L5cEy1CDqeif+khtJY7XRJJn2P3j4iNVXmV2/qjkYGCyILbFvy5iyU6i1WroIgbuJbEzVZUEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113961; c=relaxed/simple;
	bh=pYcr2H2/a6QthGHLgGzll/XLsE1RZLLuBSwsIPyUzBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0/c4rV1Es1lLOyfeTZFqpanUa1R23CNDvj8wQnaWATSIxqU7pDT6XZpo+fV4lJ+3uR9Y9yXOYHz/J5PNQ4+tf1qNrOJ4Yb79wFbrnf/oBUcrP+WK3xD5GAYRlfJrxRYl6DAKeyABsKENsJRj/NlpILrPAoWRvlRzhMmtzGOFec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfXMxLnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfXMxLnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07009C4CEF0;
	Wed, 17 Sep 2025 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113960;
	bh=pYcr2H2/a6QthGHLgGzll/XLsE1RZLLuBSwsIPyUzBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfXMxLnQSiWy3CxTuT4TzOWj1Oea1SKB8s7Ukv3fPKVbpMH9vTEjHfy11t4IKjZ59
	 qlB3zIsTY5ZxhugLkn46LVKWJRGnXCg/QDX0VAahgm1QIWIj8jg4PGNrOXZHMEiU3o
	 uIPxCKswmfRt8JbCePE36JtaYVYRW7BVURF7nSXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.6 072/101] igb: fix link test skipping when interface is admin down
Date: Wed, 17 Sep 2025 14:34:55 +0200
Message-ID: <20250917123338.579728527@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 92b2be06a6e93..f11cba65e5d85 100644
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



