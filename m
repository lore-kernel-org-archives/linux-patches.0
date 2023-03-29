Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D546FA2;
	Wed, 29 Mar 2023 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=V3nhz2pvP7h7Cz23MObcCMnl1WaF8f98/d7AXl1BRts=;
	t=1680116458; x=1681326058; b=yTH0zi43MAqnpdDBRBlCXVbDq7Y2Bi9Ia2KY97WSaLiyerA
	6+J+lhehT8L2cRJ8RcYAfbLCMB5VESx7mWnPIXwVd6bkTBvwzsOVhE4XpU9u5iGsV3udBKmBvlKjw
	lMhpM/+UBwX8MdHLZHUG42Dj3Kgams0aufExQMrvUb7oaZlpDhiHfcjovG6YHpRSGw9yBuCJxxNFk
	aMzB4W2d/MKC8ssFPayCly75xa3svV2OCuEV56BkDcfmyCicoAaFLCCPr1TX+hk5vSpeD0hQtkm+H
	pcwa4bp3Vgj9YOLUXYTweCQ20tvyM65rZJ3s52j5k+QRwXD7K9LmjjCIfuoFwjJg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1phb2O-000CaR-0l;
	Wed, 29 Mar 2023 21:00:48 +0200
Message-ID: <465e2312486da2c68f26811884474d080e906d87.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: iwlwifi: mvm: Avoid 64-bit division
 in iwl_mvm_get_crosstimestamp_fw()
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, gregory.greenman@intel.com, 
 kvalo@kernel.org, trix@redhat.com, avraham.stern@intel.com, 
 krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
  patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>, "kernelci.org bot"
 <bot@kernelci.org>, Craig Topper <craig.topper@sifive.com>
Date: Wed, 29 Mar 2023 21:00:47 +0200
In-Reply-To: <CAKwvOdnQ9feXGYV2CUyVwg-FNAOmb4HBmDxMg243v28DzSfLuA@mail.gmail.com>
References: 
	<20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
	 <9058a032c177e9b04adbf944ad34c5ed8090d9d6.camel@sipsolutions.net>
	 <CAKwvOdnQ9feXGYV2CUyVwg-FNAOmb4HBmDxMg243v28DzSfLuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2023-03-29 at 10:30 -0700, Nick Desaulniers wrote:
> >=20
> > > Nick pointed out that the result of this division is being
> > > stored to a 32-bit type anyways, so truncate gp2_10ns first then do t=
he
> > > division, which elides the need for libcalls.
> >=20
> > That loses ~7 top bits though, no? I'd be more worried about that, than
> > the time div_u64() takes.
>=20
> The result is still stored in a u32; there is a loss of precision
> regardless of use of div_u64 or open coded binary operator /. =C2=A0
>=20

Right, obviously.

> So is
> the loss of precision before the division as tolerable as after the
> division?

For all I can tell this is meant to be 'gp2' with an additional lower
bits to reach a unit/granularity of 10ns, basically in FW something like

  gp2_10ns =3D gp2 * 100 + subsampling_10ns_unit

(and gp2 in FW is a 32-bit value, so it rolls over eventually).

But I _think_ we want to make a proper division by 100 to obtain back
the original 'gp2' value here.

johannes
