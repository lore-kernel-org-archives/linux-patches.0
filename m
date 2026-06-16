Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AB715B998;
	Tue, 16 Jun 2026 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625163; cv=none; b=iBAH0dcmnk0+OqDM7WciHl1Pq6ybJhJvKXSfAjMo6OG9m9FwNblL9YkLoHHQkgVpuJETWzJNKJsW2eo7AmymDv5Trg6U2tSITJkVFEcFOly/FtESGwS8+lnz7w0ZceA2Nzhr0J9Y09+OJIjxTy1BojNrkcge5MdEavlI5+AIr1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625163; c=relaxed/simple;
	bh=HUbPa4AVK8CXO1KtkeeUe+ROuRL6mpYmf5hTO9m8bk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeDZ0RWmcuHAxPL/4t8hKoC8PC08WMYE9KO5FGda7lh2uRXhGQ0o/Btft9z5zdk/QGW8hrItm08Wfd8KDyzXwBziJHJYL8R9MOYfKn/LLYDYoiwNhnBir35TiTH1B01xq+a8C6DEKnYqVQjE/Sv0Xx9XnA3njHyg7Qakcvkcazo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkArL0fJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkArL0fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1CA1F000E9;
	Tue, 16 Jun 2026 15:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625162;
	bh=XO0avWOJnh8s8sSfMYE12oPPSdJSdtCnYBO0UXZQ4dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkArL0fJ2nARLOLsQGQR3COf+SOVIoJXQdUGwsj+Ly+PnNICOl3rrhnbCKXV0tvs4
	 kKPu9Btzmb2gNfH1q5DtMAMi4Dt0UOh0V2TPV7RZY5IeyG8o1GEyfg6FTgI81tA71X
	 aDzmiKPi3rZ1ry3SYbSgcMDO1j8ZEibif+OKm5VQ=
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
Subject: [PATCH 6.18 090/325] ice: fix missing priority callbacks for U.FL DPLL pins
Date: Tue, 16 Jun 2026 20:28:06 +0530
Message-ID: <20260616145102.187037376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 14048ac5eff56f..81267bae0e5cb5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -2481,6 +2481,8 @@ static const struct dpll_pin_ops ice_dpll_pin_ufl_ops = {
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



