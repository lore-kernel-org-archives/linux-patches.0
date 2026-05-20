Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE023D6CB7;
	Wed, 20 May 2026 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297211; cv=none; b=tMu6Z3JWgImFwtsyW6N9YKep5YuCQ/0boFqEzjj6GLFQ42ZUJVqsdpBktjRfAkoOXrCHIeTLbzf94n1WJT2U2yYRPqwEf4l+T0SDxhDmJetKEaVgdiKf582KftrV9quwhiWt1h1sj+Pjhu5MBqf8m7voUh+ZoMMVeGVDr+VFFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297211; c=relaxed/simple;
	bh=X89WwMDoAKjcp4UUNjAuofPYSLoFSJCseQpeQI54zOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRPHjPtAacaOATvE2gzS0AvLY3OahVMG5x2KoAcblWhv8zc0yILedRVayi0jzUK+6iBhUDVSVtNqcxIxE3YO6AWKN5PRl9AqNr+7SUG9cn1tQ1eUcBPsC+q87D65PFxBSg43/n7nM2BHMhnE9YRVWLiA+U9e/mqbcxeRAyhnYWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jij0cMBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jij0cMBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CD81F000E9;
	Wed, 20 May 2026 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297209;
	bh=ix1jZfHkHrHnKMxC3FJj1mekaHJvPxHQP7NE885K2Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jij0cMBHbmfgdUwHGnUrRGUD2c+5/lq/mhWanOVgR8CHImsueX5GCV+GEHvxd3Avv
	 kFzVGS1Y/Xa3Q8VkwRK2UVgCIhBFapQx7XDOxEapELjHak9HKBDYqnNj490A6BDT+x
	 HeJq+EAFgbFDed+YanYgXMsP5472VXH1a4NX1RDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	stable@kernel.org,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 1050/1146] idpf: fix double free and use-after-free in aux device error paths
Date: Wed, 20 May 2026 18:21:40 +0200
Message-ID: <20260520162211.997440226@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 6c77b9510829a424d1b74409b7db9456e3522871 upstream.

When auxiliary_device_add() fails in idpf_plug_vport_aux_dev() or
idpf_plug_core_aux_dev(), the err_aux_dev_add label calls
auxiliary_device_uninit() and falls through to err_aux_dev_init.  The
uninit call will trigger put_device(), which invokes the release
callback (idpf_vport_adev_release / idpf_core_adev_release) that frees
iadev.  The fall-through then reads adev->id from the freed iadev for
ida_free() and double-frees iadev with kfree().

Free the IDA slot and clear the back-pointer before uninit, while adev
is still valid, then return immediately.

Commit 65637c3a1811 ("idpf: fix UAF in RDMA core aux dev deinitialization")
fixed the same use-after-free in the matching unplug path in this file but
missed both probe error paths.

Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: stable@kernel.org
Fixes: be91128c579c ("idpf: implement RDMA vport auxiliary dev create, init, and destroy")
Fixes: f4312e6bfa2a ("idpf: implement core RDMA auxiliary dev create, init, and destroy")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-4-a5ea4dc837a9@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_idc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/intel/idpf/idpf_idc.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_idc.c
@@ -90,7 +90,10 @@ static int idpf_plug_vport_aux_dev(struc
 	return 0;
 
 err_aux_dev_add:
+	ida_free(&idpf_idc_ida, adev->id);
+	vdev_info->adev = NULL;
 	auxiliary_device_uninit(adev);
+	return ret;
 err_aux_dev_init:
 	ida_free(&idpf_idc_ida, adev->id);
 err_ida_alloc:
@@ -228,7 +231,10 @@ static int idpf_plug_core_aux_dev(struct
 	return 0;
 
 err_aux_dev_add:
+	ida_free(&idpf_idc_ida, adev->id);
+	cdev_info->adev = NULL;
 	auxiliary_device_uninit(adev);
+	return ret;
 err_aux_dev_init:
 	ida_free(&idpf_idc_ida, adev->id);
 err_ida_alloc:


