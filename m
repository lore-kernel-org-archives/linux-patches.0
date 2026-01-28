Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC8430E849;
	Wed, 28 Jan 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615868; cv=none; b=tGZ5mjIVwPoKZN9Y270UHehfI6HbmneVRwKWkWIm0D8y0L6naQrzegggVe21ebrHg8j9L4wBe/ExObfLLPzq3ZBWyCtPb5v8weEz6UdwXfetfQF+E6lZJP4ny3fkq9eVQE+Z9Csyl3EJQQDqW2T7JW7ZwsYjcW6hIfVw/MIyguE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615868; c=relaxed/simple;
	bh=B+OdNnadeCrojyxNHC3Da95ZmfZf57NH00DbGaB51Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0KwHwQNrfjJFhMA220JYyn3FEhlPgDFUL/pMGDXRfaq+SCqlWzw5hsR95cke1fsVC+aTl4+EO5drKHs/ezw9O1pltQsn7iQUivX0of/QkM4h6tu53KmqRmqJqSnJYGWRuZafjynhkdm57uVafnmKAX9IIk1qBDasquI7vzKv5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCa6tawE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCa6tawE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D04C4CEF1;
	Wed, 28 Jan 2026 15:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615868;
	bh=B+OdNnadeCrojyxNHC3Da95ZmfZf57NH00DbGaB51Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCa6tawElgOQSIhUgTCb6XTKI6M8vzVuKhx33tyONLLQQIbuhiI9DSn4N7e7oG1oS
	 xcW2yMWB9VIawd03kYmsJ8EXGPtvTEEoH9MPbVY5VHXmYsYoEhUU4A32HvWh/hLvlv
	 ZcYGF6AWcITsQ8Vyh+VIUuGKTat+aTOkRvpOT4nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 105/227] ice: add missing ice_deinit_hw() in devlink reinit path
Date: Wed, 28 Jan 2026 16:22:30 +0100
Message-ID: <20260128145348.245206488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 42fb5f3deb582cb96440e4683745017dbabb83d6 ]

devlink-reload results in ice_init_hw failed error, and then removing
the ice driver causes a NULL pointer dereference.

[  +0.102213] ice 0000:ca:00.0: ice_init_hw failed: -16
...
[  +0.000001] Call Trace:
[  +0.000003]  <TASK>
[  +0.000006]  ice_unload+0x8f/0x100 [ice]
[  +0.000081]  ice_remove+0xba/0x300 [ice]

Commit 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on
error paths") removed ice_deinit_hw() from ice_deinit_dev(). As a result
ice_devlink_reinit_down() no longer calls ice_deinit_hw(), but
ice_devlink_reinit_up() still calls ice_init_hw(). Since the control
queues are not uninitialized, ice_init_hw() fails with -EBUSY.

Add ice_deinit_hw() to ice_devlink_reinit_down() to correspond with
ice_init_hw() in ice_devlink_reinit_up().

Fixes: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/devlink/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink.c b/drivers/net/ethernet/intel/ice/devlink/devlink.c
index 938914abbe066..ac071c5b4ce38 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -460,6 +460,7 @@ static void ice_devlink_reinit_down(struct ice_pf *pf)
 	ice_vsi_decfg(ice_get_main_vsi(pf));
 	rtnl_unlock();
 	ice_deinit_pf(pf);
+	ice_deinit_hw(&pf->hw);
 	ice_deinit_dev(pf);
 }
 
-- 
2.51.0



