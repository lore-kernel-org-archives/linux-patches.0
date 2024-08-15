Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011477DA7D;
	Thu, 15 Aug 2024 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730356; cv=none; b=fgForomexKVlzytdhQl1BWfI3hXQH7OId028ZpfxLITXwY5d8N7YVTPXYMKWSGZ2KI0zAgEWJQcEi1+vuKtMq63UgkjhGzbiH3gyWBdCFMjHyY2ii75DC9nbimHN0BLwVKzPSfrGpDEqNO2nXkiwKFVDTixdHzWkP//gTAJztO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730356; c=relaxed/simple;
	bh=GV1s2gxXjTJmssSykOOdlmiPF/wPYTMo7Noojt7TNGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJ2coVklwtAjYAB3jgMSBH/Ac+KN95OdH7JDo7gKWU/ShbW8P2gcntIMLA2v/SfQ9834yOLXGQXVsSes4vIXoLppqAmMZrilbrshytjo5innRbl462zKc5iV/2wKklvRkygZkcfez9S5W/IqHd9Q9DHqWWrsaTFNwslk9Sp3o4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjhgaDbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjhgaDbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4EAC32786;
	Thu, 15 Aug 2024 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723730355;
	bh=GV1s2gxXjTJmssSykOOdlmiPF/wPYTMo7Noojt7TNGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PjhgaDbK6GgO70eg+Agi6sCY/HxpZyIfT1Kecn/7nJLuVozswnXhXVNBFvyKa7VaP
	 Kt2I59Vw7Xs6b4te1YhGbpsewR7Y8CP8W1vF/0HRpnTVN2vBbUYVB9I74EqbYcIYFr
	 1UAVBD96XTZCRnAvCpIvSpqk1MBc4nqPJuHQAVke37COznV4t7VletXA1ztt3CksfD
	 oIqQRuVU2PXL3dCfUXeF35jEC19BT0Aawmtd0C89GU+zREtxsOn5Yy/qffO+SgghSV
	 GDMeMkGczsBTWsavFkp647kjy9af5IqpbMgmIqzggLOoFLRCsq+Hyp/jfRLzrzunKL
	 UwitcxutFB80w==
Date: Thu, 15 Aug 2024 15:59:11 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>, Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 5.15 179/484] ata: libata-scsi: Honor the D_SENSE bit for
 CK_COND=1 and no error
Message-ID: <Zr4Jr520dIGvkIN6@ryzen.lan>
References: <20240815131941.255804951@linuxfoundation.org>
 <20240815131948.331340891@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815131948.331340891@linuxfoundation.org>

On Thu, Aug 15, 2024 at 03:20:37PM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Igor Pylypiv <ipylypiv@google.com>
> 
> commit 28ab9769117ca944cb6eb537af5599aa436287a4 upstream.
> 
> SAT-5 revision 8 specification removed the text about the ANSI INCITS
> 431-2007 compliance which was requiring SCSI/ATA Translation (SAT) to
> return descriptor format sense data for the ATA PASS-THROUGH commands
> regardless of the setting of the D_SENSE bit.
> 
> Let's honor the D_SENSE bit for ATA PASS-THROUGH commands while
> generating the "ATA PASS-THROUGH INFORMATION AVAILABLE" sense data.
> 
> SAT-5 revision 7
> ================
> 
> 12.2.2.8 Fixed format sense data
> 
> Table 212 shows the fields returned in the fixed format sense data
> (see SPC-5) for ATA PASS-THROUGH commands. SATLs compliant with ANSI
> INCITS 431-2007, SCSI/ATA Translation (SAT) return descriptor format
> sense data for the ATA PASS-THROUGH commands regardless of the setting
> of the D_SENSE bit.
> 
> SAT-5 revision 8
> ================
> 
> 12.2.2.8 Fixed format sense data
> 
> Table 211 shows the fields returned in the fixed format sense data
> (see SPC-5) for ATA PASS-THROUGH commands.
> 
> Cc: stable@vger.kernel.org # 4.19+
> Reported-by: Niklas Cassel <cassel@kernel.org>
> Closes: https://lore.kernel.org/linux-ide/Zn1WUhmLglM4iais@ryzen.lan
> Reviewed-by: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Link: https://lore.kernel.org/r/20240702024735.1152293-4-ipylypiv@google.com
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/ata/libata-scsi.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -872,11 +872,8 @@ static void ata_gen_passthru_sense(struc
>  				   &sense_key, &asc, &ascq, verbose);
>  		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
>  	} else {
> -		/*
> -		 * ATA PASS-THROUGH INFORMATION AVAILABLE
> -		 * Always in descriptor format sense.
> -		 */
> -		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
> +		/* ATA PASS-THROUGH INFORMATION AVAILABLE */
> +		ata_scsi_set_sense(qc->dev, cmd, RECOVERED_ERROR, 0, 0x1D);
>  	}
>  
>  	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
> 
> 

Hello Greg,

This commit unfortunately breaks hdparm, hddtemp and udisks,
and I have just sent a PR to Linus that reverts this commit, see:
https://lore.kernel.org/linux-ide/20240815124310.1349324-1-cassel@kernel.org/T/#u
and
https://git.kernel.org/pub/scm/linux/kernel/git/libata/linux.git/commit/?h=ata-6.11-rc4

So it might be a good idea to not include this patch in v5.15.x in the
first place, so that we avoid having a v5.15.x release that will be broken
until the revert gets backported (in v5.15.x+1).


Kind regards,
Niklas
