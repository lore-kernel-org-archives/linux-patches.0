Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEC82F8EBC;
	Tue, 16 Jun 2026 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623194; cv=none; b=tTDfoPVa4HGaBqdi2xVPIAMUAdonUFJJM/PHIqR1UFg5M9Ld6NUVKVa6b/YL4H0+mlPTSisUhjUlOyukuBRWOZUaedh05OW6qBwakbk4SGVGioljOVFNN9dlQEKQEy+b+PpNSMDtyqZ5LJNTwFyMmyNGz9DRWRZFgXGV6kPDJlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623194; c=relaxed/simple;
	bh=NJIvOhvELW7KjCMoOUtDbanOwFBk3unDn8k0PFp+vjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnfRU0YDkwfYmlMNpAVqYfS7WaFli8zWYkByirPj3v6G+KcN0EPwGm82XeI4A03dUN/NMFjXRLOoWOnJ826maURKOyNzJodYo2u39wuhVngs3HenyTxfeZi6F4XCHIXjjKbtlL01hhzFHSrArKH42r/n0+e8Oedz3rCjHiIZAj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wba7Q8xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wba7Q8xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA5A1F000E9;
	Tue, 16 Jun 2026 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623192;
	bh=51A8FErQlr82zfbaiJbsud3xD2KSMqF+R3fBz5Udgz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wba7Q8xhaGa4POWUsW2DZoOnwtQR0xiUkmbO7/cVQngt0HjA0xJ53WICCBqeIKtFn
	 DKn9LyNodRsBiDzS/xLtV7ZO69oUXdxCW0+O0OOg2L3dBX1vCuenjkiBHdEr+Oyx0t
	 iNCZnt+QbvWr8d5WIX/ewqL3an1XfrWtdOeDCYOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Petr Oros <poros@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.0 102/378] ice: fix missing priority callbacks for U.FL DPLL pins
Date: Tue, 16 Jun 2026 20:25:33 +0530
Message-ID: <20260616145115.729372503@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit f1fa677e428e8873486938086bd934dc18169b47 ]

The U.FL2 input pin advertises DPLL_PIN_CAPABILITIES_PRIORITY_CAN_CHANGE
in its capability mask, but ice_dpll_pin_ufl_ops does not provide
.prio_get and .prio_set callbacks. As a result the DPLL subsystem
cannot report or accept priority for U.FL pins: pin-get omits the prio
field on U.FL2 and pin-set with prio is rejected as invalid, even
though the capability is present. This prevents user space from using
priority to select or disable U.FL2 as a DPLL input source.

Reproducer with iproute2 (dpll command):

  # dpll pin show board-label U.FL2
  pin id 16:
    module-name ice
    board-label U.FL2
    type ext
    capabilities priority-can-change|state-can-change
    parent-device:
      id 0 direction input state selectable phase-offset 0
    /* note: no "prio" between "direction" and "state",
       even though priority-can-change is advertised */

  # dpll pin set id 16 parent-device 0 prio 5
  RTNETLINK answers: Operation not supported

After the fix the prio field is reported by pin show and pin set with
prio is accepted on U.FL2.

Add the missing .prio_get and .prio_set callbacks to
ice_dpll_pin_ufl_ops, reusing ice_dpll_sw_input_prio_{get,set}. The
same ops struct is shared by U.FL1 and U.FL2: U.FL2 (input) delegates
to the backing hardware input pin, while U.FL1 (output) does not
advertise DPLL_PIN_CAPABILITIES_PRIORITY_CAN_CHANGE so the dpll core
capability gate never invokes prio_set for it, and prio_get reports
the OUTPUT sentinel (ICE_DPLL_PIN_PRIO_OUTPUT) on the output side
exactly like the SMA path does today.

Fixes: 2dd5d03c77e2 ("ice: redesign dpll sma/u.fl pins control")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260602225513.393338-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 892bc7c2e28b46..0704e92ab04305 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -2633,6 +2633,8 @@ static const struct dpll_pin_ops ice_dpll_pin_ufl_ops = {
 	.state_on_dpll_set = ice_dpll_ufl_pin_state_set,
 	.state_on_dpll_get = ice_dpll_sw_pin_state_get,
 	.direction_get = ice_dpll_pin_sw_direction_get,
+	.prio_get = ice_dpll_sw_input_prio_get,
+	.prio_set = ice_dpll_sw_input_prio_set,
 	.frequency_get = ice_dpll_sw_pin_frequency_get,
 	.frequency_set = ice_dpll_sw_pin_frequency_set,
 	.esync_set = ice_dpll_sw_esync_set,
-- 
2.53.0



