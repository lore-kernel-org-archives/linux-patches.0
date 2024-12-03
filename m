Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6001E1EE00E;
	Tue,  3 Dec 2024 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242522; cv=none; b=GIstibLtnsYOaWtq7zjP5Pki4pO79G9tduiqoFrj2wxsnKZKzMGCDE1ZkWM1xt/v4PpFREpSR34LLN+6bu2IhVm+QL/ZQVNZyLSqaEheMfIOm5URwb7cU76A/YNR49NJ1eZNWZjrx5a8b4zzINUCJDiO2DanvQ2VDT7jgYyOMiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242522; c=relaxed/simple;
	bh=cpclEtFJm8gmOzx2ZQitcUB8ygG52oTyx7SxU4piJ60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9Tjg16frX+X6JEbvWVnedbeXjQwLikxeJ+sNoqjHkh48omZxmhWsusCZKuWiKimN7ddPw4xaqcqjryOG2pp5FBxjTvsayjNrRXZrbUiCzwTDGMOMzHzF82+IgeTlrCM5er6AyPLGkb13rfnHhf/YPHegMOnwekRK39f2q00jFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeCX5NXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeCX5NXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B80C4CECF;
	Tue,  3 Dec 2024 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242522;
	bh=cpclEtFJm8gmOzx2ZQitcUB8ygG52oTyx7SxU4piJ60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeCX5NXMzfb/7zCcBuLRJtbFBBRTJgcP4INA+xu8McMzKAGJly6fiqbrdMtpSlqUf
	 kZqLbU1d5YgOQLvaVF+Q/M016B0mOt+TabCq/GRlePlxPhatbcz9mPw7MQtY5EEgxb
	 Ikqy/6IMRhX9uA4LFHM2pFhEu6Wu2BS5SyxFfq00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Peter=20Gro=C3=9Fe?= <pegro@friiks.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 730/826] i40e: Fix handling changed priv flags
Date: Tue,  3 Dec 2024 15:47:37 +0100
Message-ID: <20241203144812.242239756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Große <pegro@friiks.de>

commit ea301aec8bb718b02b68761d2229fc12c9fefa29 upstream.

After assembling the new private flags on a PF, the operation to determine
the changed flags uses the wrong bitmaps. Instead of xor-ing orig_flags
with new_flags, it uses the still unchanged pf->flags, thus changed_flags
is always 0.

Fix it by using the correct bitmaps.

The issue was discovered while debugging why disabling source pruning
stopped working with release 6.7. Although the new flags will be copied to
pf->flags later on in that function, disabling source pruning requires
a reset of the PF, which was skipped due to this bug.

Disabling source pruning:
$ sudo ethtool --set-priv-flags eno1 disable-source-pruning on
$ sudo ethtool --show-priv-flags eno1
Private flags for eno1:
MFP                   : off
total-port-shutdown   : off
LinkPolling           : off
flow-director-atr     : on
veb-stats             : off
hw-atr-eviction       : off
link-down-on-close    : off
legacy-rx             : off
disable-source-pruning: on
disable-fw-lldp       : off
rs-fec                : off
base-r-fec            : off
vf-vlan-pruning       : off

Regarding reproducing:

I observed the issue with a rather complicated lab setup, where
 * two VLAN interfaces are created on eno1
 * each with a different MAC address assigned
 * each moved into a separate namespace
 * both VLANs are bridged externally, so they form a single layer 2 network

The external bridge is done via a channel emulator adding packet loss and
delay and the application in the namespaces tries to send/receive traffic
and measure the performance. Sender and receiver are separated by
namespaces, yet the network card "sees its own traffic" send back to it.
To make that work, source pruning has to be disabled.

Cc: stable@vger.kernel.org
Fixes: 70756d0a4727 ("i40e: Use DECLARE_BITMAP for flags and hw_features fields in i40e_pf")
Signed-off-by: Peter Große <pegro@friiks.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20241113210705.1296408-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5299,7 +5299,7 @@ static int i40e_set_priv_flags(struct ne
 	}
 
 flags_complete:
-	bitmap_xor(changed_flags, pf->flags, orig_flags, I40E_PF_FLAGS_NBITS);
+	bitmap_xor(changed_flags, new_flags, orig_flags, I40E_PF_FLAGS_NBITS);
 
 	if (test_bit(I40E_FLAG_FW_LLDP_DIS, changed_flags))
 		reset_needed = I40E_PF_RESET_AND_REBUILD_FLAG;


