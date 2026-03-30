Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AF0395242;
	Mon, 30 Mar 2026 07:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774856041; cv=none; b=Qso1Ta3SbJNg6G7ldiCP+7vAC9vMef2jkmdtgRiBagjxO166U9y7hyqGMvPUB+yebADn9A48v2J4vxuz+k9BZ7Q/5MPaIGITh1JeB/yG3Tnf6bHejGfYpx1n83dNnBUrTJYPePhzwi4mfZl8fEkIAbFuZAYfZGrNL+tTiAgydzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774856041; c=relaxed/simple;
	bh=7kgUQuFANCPaR5uCvT7NPfT7IH4fWzabVqEmhp/cEHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WsFbzj+OZCv6YhFwT7U5t5p2s93qV3UmeeIj2FpSYaIeUR+gG436/PGuPcQ6X9JHW4WY9Y7w9N10snZB/sT5fv1NXnhzMYsO2P6XkN43PWFyDKLC3yjOYj4UDwdjmmlWrdQkw83ZIcbC8PIfy5IKzsBspLOYBRf96+JOwaya9A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifHBMOea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifHBMOea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004CEC19423;
	Mon, 30 Mar 2026 07:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774856040;
	bh=7kgUQuFANCPaR5uCvT7NPfT7IH4fWzabVqEmhp/cEHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ifHBMOea1qbxwQjnwUekkcAyh3AghrMj4LkZvBOhcfwXywdmiWyfNOZVth/qA700o
	 MkKQPo6bV6Y1v7FH2BsGUpNi03IP+4wfy7JZnaxB47e1eczKOeaUBkrk0Mzuon4qz3
	 MND6x74hP7mnxtw8Saxk6Be611YAMCWBBd3iPtcQ8j6z5kPQPW3mciNb6qMOrkPZ0y
	 MY+78m+R/vxmC6G4uBmr+HgRahdIrU6xBzfo7opZE4Saso/iOIKXTGvXL7CucHOIwx
	 S84TRtrFXR/nP1vEOKM+FfNrucDVzKj0/sUqrP0gkcghazAnljgQl6E4+ZzPMxnSrw
	 hVC+vMxt/2PRg==
Date: Mon, 30 Mar 2026 09:33:56 +0200
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, Rahul Sharma <black.hawk@163.com>
Subject: Re: [PATCH 6.1 379/481] net: enetc: allocate vf_state during PF
 probes
Message-ID: <20260330073356.GA1017537@ax162>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260323134534.371230946@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134534.371230946@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:46:01PM +0100, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Wei Fang <wei.fang@nxp.com>
> 
> [ Upstream commit e15c5506dd39885cd047f811a64240e2e8ab401b ]
> 
> In the previous implementation, vf_state is allocated memory only when VF
> is enabled. However, net_device_ops::ndo_set_vf_mac() may be called before
> VF is enabled to configure the MAC address of VF. If this is the case,
> enetc_pf_set_vf_mac() will access vf_state, resulting in access to a null
> pointer. The simplified error log is as follows.
> 
> root@ls1028ardb:~# ip link set eno0 vf 1 mac 00:0c:e7:66:77:89
> [  173.543315] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
> [  173.637254] pc : enetc_pf_set_vf_mac+0x3c/0x80 Message from sy
> [  173.641973] lr : do_setlink+0x4a8/0xec8
> [  173.732292] Call trace:
> [  173.734740]  enetc_pf_set_vf_mac+0x3c/0x80
> [  173.738847]  __rtnl_newlink+0x530/0x89c
> [  173.742692]  rtnl_newlink+0x50/0x7c
> [  173.746189]  rtnetlink_rcv_msg+0x128/0x390
> [  173.750298]  netlink_rcv_skb+0x60/0x130
> [  173.754145]  rtnetlink_rcv+0x18/0x24
> [  173.757731]  netlink_unicast+0x318/0x380
> [  173.761665]  netlink_sendmsg+0x17c/0x3c8
> 
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Link: https://patch.msgid.link/20241031060247.1290941-2-wei.fang@nxp.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Rahul Sharma <black.hawk@163.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -683,19 +683,11 @@ static int enetc_sriov_configure(struct
>  
>  	if (!num_vfs) {
>  		enetc_msg_psi_free(pf);
> -		kfree(pf->vf_state);
>  		pf->num_vfs = 0;
>  		pci_disable_sriov(pdev);
>  	} else {
>  		pf->num_vfs = num_vfs;
>  
> -		pf->vf_state = kcalloc(num_vfs, sizeof(struct enetc_vf_state),
> -				       GFP_KERNEL);
> -		if (!pf->vf_state) {
> -			pf->num_vfs = 0;
> -			return -ENOMEM;
> -		}
> -
>  		err = enetc_msg_psi_init(pf);
>  		if (err) {
>  			dev_err(&pdev->dev, "enetc_msg_psi_init (%d)\n", err);
> @@ -714,7 +706,6 @@ static int enetc_sriov_configure(struct
>  err_en_sriov:
>  	enetc_msg_psi_free(pf);
>  err_msg_psi:
> -	kfree(pf->vf_state);
>  	pf->num_vfs = 0;
>  
>  	return err;
> @@ -1322,6 +1313,12 @@ static int enetc_pf_probe(struct pci_dev
>  	pf = enetc_si_priv(si);
>  	pf->si = si;
>  	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
> +	if (pf->total_vfs) {
> +		pf->vf_state = kcalloc(pf->total_vfs, sizeof(struct enetc_vf_state),
> +				       GFP_KERNEL);
> +		if (!pf->vf_state)
> +			goto err_alloc_vf_state;
> +	}
>  
>  	err = enetc_setup_mac_addresses(node, pf);
>  	if (err)
> @@ -1398,6 +1395,8 @@ err_alloc_si_res:
>  err_alloc_netdev:
>  err_device_disabled:
>  err_setup_mac_addresses:
> +	kfree(pf->vf_state);
> +err_alloc_vf_state:
>  	enetc_psi_destroy(pdev);
>  err_psi_create:
>  	return err;
> @@ -1424,6 +1423,7 @@ static void enetc_pf_remove(struct pci_d
>  	enetc_free_si_resources(priv);
>  
>  	free_netdev(si->ndev);
> +	kfree(pf->vf_state);
>  
>  	enetc_psi_destroy(pdev);
>  }

This results in a clang warning:

  drivers/net/ethernet/freescale/enetc/enetc_pf.c:1307:6: error: variable 'pf' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
   1307 |         if (node && !of_device_is_available(node)) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/net/ethernet/freescale/enetc/enetc_pf.c:1398:8: note: uninitialized use occurs here
   1398 |         kfree(pf->vf_state);
        |               ^~
  drivers/net/ethernet/freescale/enetc/enetc_pf.c:1307:2: note: remove the 'if' if its condition is always false
   1307 |         if (node && !of_device_is_available(node)) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1308 |                 dev_info(&pdev->dev, "device is disabled, skipping\n");
        |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1309 |                 err = -ENODEV;
        |                 ~~~~~~~~~~~~~~
   1310 |                 goto err_device_disabled;
        |                 ~~~~~~~~~~~~~~~~~~~~~~~~~
   1311 |         }
        |         ~
  drivers/net/ethernet/freescale/enetc/enetc_pf.c:1290:21: note: initialize the variable 'pf' to silence this warning
   1290 |         struct enetc_pf *pf;
        |                            ^
        |                             = NULL

I see two options.

1. Backport commit bfce089ddd0e ("net: enetc: remove
   of_device_is_available() handling") and its dependent change,
   commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled status"),
   although I did not look to see if there are any other necessary fixes
   or dependencies.

2. Address this with a stable-only patch like:

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 99422c0b4a26..e4c8bdff68c5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1285,9 +1285,9 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct enetc_ndev_priv *priv;
+	struct enetc_pf *pf = NULL;
 	struct net_device *ndev;
 	struct enetc_si *si;
-	struct enetc_pf *pf;
 	int err;
 
 	err = enetc_pf_register_with_ierb(pdev);
@@ -1395,7 +1395,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 err_alloc_netdev:
 err_device_disabled:
 err_setup_mac_addresses:
-	kfree(pf->vf_state);
+	if (pf)
+		kfree(pf->vf_state);
 err_alloc_vf_state:
 	enetc_psi_destroy(pdev);
 err_psi_create:
--

Cheers,
Nathan
