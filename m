Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698B4BA96;
	Mon,  8 Jan 2024 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efBpmpcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D663C433CB;
	Mon,  8 Jan 2024 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726719;
	bh=h2nLD/H2GpBMuXlgQJ6GuMV1b8dl8jQIMEBH+gu9S1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efBpmpcW+tMGaigIHzWVT6FRG6488AFU048esW/kVuu35Pnf+M8E+oAm84MQ0i9Jm
	 RVLMNw+yDNQW51OmR8jDCkEQvwEf3NcgG1cASrYC8L0ZpPPSriSsc31lMHTyIxicI0
	 HHu/5OeOR5Ie2emqeK4cYPcml5YuglYKuVybUqNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Ngai-Mint Kwan <ngai-mint.kwan@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 027/124] ice: Shut down VSI with "link-down-on-close" enabled
Date: Mon,  8 Jan 2024 16:07:33 +0100
Message-ID: <20240108150604.218679438@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ngai-Mint Kwan <ngai-mint.kwan@intel.com>

[ Upstream commit 6d05ff55ef4f4954d28551236239f297bd52ea48 ]

Disabling netdev with ethtool private flag "link-down-on-close" enabled
can cause NULL pointer dereference bug. Shut down VSI regardless of
"link-down-on-close" state.

Fixes: 8ac7132704f3 ("ice: Fix interface being down after reset with link-down-on-close flag on")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Ngai-Mint Kwan <ngai-mint.kwan@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 66f4c54d8aa5a..d8d2aa4c0216a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9179,6 +9179,8 @@ int ice_stop(struct net_device *netdev)
 			else
 				netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
 					   vsi->vsi_num, link_err);
+
+			ice_vsi_close(vsi);
 			return -EIO;
 		}
 	}
-- 
2.43.0



