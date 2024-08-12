Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA3130E27;
	Mon, 12 Aug 2024 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479208; cv=none; b=JXIrFPCehbC76mdmSlbwpSUKYXmIh5r5Swnvz3bjvDliviIqzUbXaopKoXTBrGGoZBEzP/AhK26SSCTM8B+FN9wOzcb6g5WtsZ+tC/2qbA1J3WRgtMKuXGb1BIHGkvm97pljWlcJrsHoqo42YjaJlDapNSVGRNRLie3utEz4M8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479208; c=relaxed/simple;
	bh=jqcJftunb+hTU0mZbKhPqg7arw4E8VFlEHPXHqnLnik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7S9X1j++XGfj8uGe01nqkzgNxGNqh3S0KkXRbrF0CLDt2Dw5ua3e/AumL3XY32tGWW3G2Jjxyzv0fURntj+wYZPQeiGEAyiGkK+QO1vjIAY/AHXmRIfT+bqDOc12Y1F8v+erf/eiK+CUhjjtnykz6NVRM7X4uYU2kJwEQghrGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+icZjQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+icZjQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A2EC32782;
	Mon, 12 Aug 2024 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479208;
	bh=jqcJftunb+hTU0mZbKhPqg7arw4E8VFlEHPXHqnLnik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+icZjQqsm85rJCZf9bYa3cV/PL97m6RjueEDfiGNUh32BiUE845zdG8EDH2cSR1x
	 Yha5TJ/R+5ki/F+UmdCtLmCvesKOkc9h6yhjQq4c/vunOLyIty6OJ7YXtpkhDt3ses
	 u5uXuv7mNOmOsa38ZRAD5ookxS81gV9QUSqwH5q0=
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
Subject: [PATCH 6.6 016/189] ice: Fix reset handler
Date: Mon, 12 Aug 2024 18:01:12 +0200
Message-ID: <20240812160132.767809446@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
index 600a2f5370875..b168a37a5dfff 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -557,6 +557,8 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	if (test_bit(ICE_PREPARED_FOR_RESET, pf->state))
 		return;
 
+	synchronize_irq(pf->oicr_irq.virq);
+
 	ice_unplug_aux_dev(pf);
 
 	/* Notify VFs of impending reset */
-- 
2.43.0



