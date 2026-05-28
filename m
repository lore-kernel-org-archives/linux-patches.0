Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49716330B2D;
	Thu, 28 May 2026 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998184; cv=none; b=pVgrIcP/zWLMYHRweqD7UX0FwY85gCcl82iW97WOdTovGVk7EZ6KHh6QGaOQ+cucrzYBDRZihLPXnWau1ijlCR8PiyHTE/JK+XRbHCzBS7rjiQmd050b/kS2yeUE+MVFHgXUcLjTFYA1ERSlNI8br9aFlhngfgmuSGyWKqxdY+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998184; c=relaxed/simple;
	bh=AhgjTAiltEgaspXPlrcPw9U51M0bQKST8d7udR1qnmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtiVlWS5BxmryNM7XBCQdeFQHN9nsGm4WGf1EVIzIHUPMRZiHIPRZzOhj9DgYoYM9wZ4igK3Z0IUR/KGrfgg7A2k7T13NScgmx5wV3v8DAJQ2kuFIAbTuYXpMPQGsssuze/M9+BOaaJeeSJ7vDnBPZGhCOEuBGZ9eeUCwxX0s6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB9rUovx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB9rUovx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD141F000E9;
	Thu, 28 May 2026 19:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998183;
	bh=/elto59Q/AbKXgzboFjhYRMTxMNfxbb5IbyJgdo+DpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JB9rUovxFivmylF4PHAkzQUIivgZz+bvI7Evb1XuBas3I5Hf0XEY6jSn3QQWVgFqX
	 SJgGATiO69mzf7y90knkgLVL3xyI1pgPbP2TrAR/rfo6ziXVK6st36xINNskemvlRj
	 Nsul5Fdj51qqvLR4jaeiXBmRVAvJ7uCw9yBVWfYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 076/461] ice: fix VF queue configuration with low MTU values
Date: Thu, 28 May 2026 21:43:25 +0200
Message-ID: <20260528194649.119088727@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 3ba4dd024d26372733d1c02e13e076c6016e3320 upstream.

The ice driver's VF queue configuration validation rejects
databuffer_size values below 1024 bytes, which prevents VFs from
using MTU values below 871 bytes.

The iavf driver calculates databuffer_size based on the MTU using:
  databuffer_size = ALIGN(MTU + LIBETH_RX_LL_LEN, 128)

where LIBETH_RX_LL_LEN = 26 (ETH_HLEN + 2*VLAN_HLEN + ETH_FCS_LEN).

For MTU values below 871:
  MTU 870: 870 + 26 = 896, aligned to 128 = 896 (< 1024, rejected)
  MTU 871: 871 + 26 = 897, aligned to 128 = 1024 (>= 1024, accepted)

The 1024-byte minimum seems unnecessarily restrictive, because the hardware
supports databuffer_size as low as 128 bytes (the alignment boundary),
which should allow MTU values down to the standard minimum of 68 bytes.

I haven't found the reason why the limit was configured in the commit
9c7dd7566d18 ("ice: add validation in OP_CONFIG_VSI_QUEUES VF message"), so
with no more information and since it is working, change the minimum
databuffer_size validation from 1024 to 128 bytes to allow standard low
MTU values while still preventing invalid configurations.

Fixes: 9c7dd7566d18 ("ice: add validation in OP_CONFIG_VSI_QUEUES VF message")
cc: stable@vger.kernel.org
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/virt/queues.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/virt/queues.c
+++ b/drivers/net/ethernet/intel/ice/virt/queues.c
@@ -840,7 +840,7 @@ int ice_vc_cfg_qs_msg(struct ice_vf *vf,
 
 			if (qpi->rxq.databuffer_size != 0 &&
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-			     qpi->rxq.databuffer_size < 1024))
+			     qpi->rxq.databuffer_size < 128))
 				goto error_param;
 
 			ring->rx_buf_len = qpi->rxq.databuffer_size;


