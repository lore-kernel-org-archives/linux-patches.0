Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5DA187332;
	Mon, 12 Aug 2024 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479871; cv=none; b=qZsNvUsqw+cwAAFgp0nQl/+DBGFF5cI8phTWdNYPezrgPrQzdsjJbOdwcO6I17HpuNPIy6qPT8N6T/bRpZQt1j1I0GcHYh2KW+vS4kLOfvAaMm0UxBLlo5Ukbh0iFrYF+snkkDPcFDdd5RGLnQixQL6XppILmsc9SThYyRw2Ryk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479871; c=relaxed/simple;
	bh=mqN4kM0c3+G9R3nqMQFv0HrO+KneNe60TV4NuGgFvTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqW8HlpFGQtMknMj8WnkY0lCjoqVPKE8hYKCkvtSQ8BOphZQDqJ4npSUSnmFPFVCs+upQSuAepgymznx+r/zSwttxNy7IxAlNejGGbadHDqdBq86+hflOD1YJWDwhyu+OQYR7jp2ksN8h9nIi3Tp3MtNdNpcQcplv4pYq0+7zQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6Eju8hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6Eju8hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A36FC32782;
	Mon, 12 Aug 2024 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479871;
	bh=mqN4kM0c3+G9R3nqMQFv0HrO+KneNe60TV4NuGgFvTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6Eju8hmKgkHbDw60lvE1cBip4BHmwA8qjUMYVfdrGI4ZZAZvczIELrip0z4QH4Mk
	 iE4Gw+hFx7hLVWipBtFjqJaFrLNtFnf3yLgz98RT5EUtPEqNqwGSmHh4OUcRKIWnrS
	 0aOvGPKj7btQHxShId/Kv/2XAJrOboHlBxiPYZE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.10 027/263] ice: Fix reset handler
Date: Mon, 12 Aug 2024 18:00:28 +0200
Message-ID: <20240812160147.580010387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 25a7123579ecac9a89a7e5b8d8a580bee4b68acd ]

Synchronize OICR IRQ when preparing for reset to avoid potential
race conditions between the reset procedure and OICR

Fixes: 4aad5335969f ("ice: add individual interrupt allocation")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9b075dd48889e..f16d13e9ff6e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -560,6 +560,8 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	if (test_bit(ICE_PREPARED_FOR_RESET, pf->state))
 		return;
 
+	synchronize_irq(pf->oicr_irq.virq);
+
 	ice_unplug_aux_dev(pf);
 
 	/* Notify VFs of impending reset */
-- 
2.43.0



