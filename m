Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7312A2EC09B;
	Wed, 15 Apr 2026 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776256983; cv=none; b=tOeUBCXupernW+lgVmRIIef8/P+b1Prd3K06N9JlOReW2bCpnq2QBfN2ezIVWrQ1hMVrVlhUsidD18v7CAK69cwC2NoNo2dveGG/9PnFGrUZNHKX4Olm8RjHRekANlQj7hp2e3Vj/+Mh872TmaFTSh2N5OYKpRQBwp/Y6eD0ORk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776256983; c=relaxed/simple;
	bh=+5uqVuOPpVJhB1siKMrAJs+wrhzmMstuLvmxpqP8mD8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lD+z/Xn3ce99lo+ziEIcegC1V8c4lH9TvrtHPW5OTa3sQ/PP+LIlamNtZxB8qITpDytd+jr0uHiOaYdBQxvHNx7+6ERSpL0791gnCfhW50ok+Jeuqm0zxOy7iIwebD+Ns5VX+f9wJKxx3QPLvmWUmBAXLairwaHgAxHGbslOOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCza7-004ybQ-31;
	Wed, 15 Apr 2026 12:42:59 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCza5-00000003fPy-1zTL;
	Wed, 15 Apr 2026 14:42:57 +0200
Message-ID: <db073c5606570f9dc898275785583a7d32031294.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 199/491] wifi: cfg80211: cancel pmsr_free_wk in
 cfg80211_pmsr_wdev_down
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>, Johannes
 Berg <johannes.berg@intel.com>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Date: Wed, 15 Apr 2026 14:42:52 +0200
In-Reply-To: <20260413155826.522907380@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155826.522907380@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A80GLlubixwLRS5nSxh2"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-A80GLlubixwLRS5nSxh2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:57 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
>=20
> [ Upstream commit 6dccbc9f3e1d38565dff7730d2b7d1e8b16c9b09 ]
>=20
> When the nl80211 socket that originated a PMSR request is
> closed, cfg80211_release_pmsr() sets the request's nl_portid
> to zero and schedules pmsr_free_wk to process the abort
> asynchronously. If the interface is concurrently torn down
> before that work runs, cfg80211_pmsr_wdev_down() calls
> cfg80211_pmsr_process_abort() directly. However, the already-
> scheduled pmsr_free_wk work item remains pending and may run
> after the interface has been removed from the driver. This
> could cause the driver's abort_pmsr callback to operate on a
> torn-down interface, leading to undefined behavior and
> potential crashes.
>=20
> Cancel pmsr_free_wk synchronously in cfg80211_pmsr_wdev_down()
> before calling cfg80211_pmsr_process_abort(). This ensures any
> pending or in-progress work is drained before interface teardown
> proceeds, preventing the work from invoking the driver abort
> callback after the interface is gone.

But cfg80211_pmsr_wdev_down() holds the wiphy lock which the work item
also tries to acquire.  Cancelling it synchronously can then lead to
deadlock.

I don't know whether this is also a problem upstream, as locking in
cfg80211 has changed significantly since 5.10.

Ben.

> Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator A=
PI")
> Signed-off-by: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.=
com>
> Link: https://patch.msgid.link/20260305160712.1263829-3-peddolla.reddy@os=
s.qualcomm.com
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/wireless/pmsr.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
> index 7503c7dd71ab5..32cea07b98fd1 100644
> --- a/net/wireless/pmsr.c
> +++ b/net/wireless/pmsr.c
> @@ -620,6 +620,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wde=
v)
>  	}
>  	spin_unlock_bh(&wdev->pmsr_lock);
> =20
> +	cancel_work_sync(&wdev->pmsr_free_wk);
>  	if (found)
>  		cfg80211_pmsr_process_abort(wdev);
> =20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-A80GLlubixwLRS5nSxh2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnfh8wACgkQ57/I7JWG
EQm3kQ/8CYUggObep/7fk7oLK2ajrx5oUXihyBg1qf8Xjwr1aH656A4RiOfJ6bDQ
NnqXA2IxZM8J0f2mfAMH22pgZuLlKZjwpS0hY/FELE0/e8fVxnundznUE8zrlQ4g
iQDmEUV5x4OA+h63LNsHGCa9eL5w9Iq/YtMV+THCVhuSXtnhyrCzNAPLKgtQtQp7
9dBCRWkZDLZ/W//jAFZEsoNmvlGN6apsUMiY45LMp7mqInWILQWFOzv8gGxHuGhS
zeQlNkpfOZFVRxOmEDIjnfapS7vFwmcUtxYflNXAISB4ScetFopAtQvi7CdF1Kd6
J065K3mlYGN4ACqbwgjAv7vpslbnXuv78MThKHq6lzGyyrjzKaDaphYitnhYmeHT
fGgOq8Ai4iq9FplFvGSombe4BSnI+/7y7Awm2fPWn8K8LQSUIHJqqnN+ou6lSEfS
qm35sxiFnU4+uiIvOQPpbWXupep73jVDEBOaP3QuP76yqtla/MrSB0zI96mI684C
Ub7HZ9/gcqmBjnftBsvyAY0PD4UIRGq4OTSeavFaLstqnkKK6wN8uXjFydC0ilpL
3dBIM30apuIImCZfaEcVh9d2hanEy/T9ZhL60MT7LQ3/3HVmqg67g0fVIPB1Lt8J
mrEuv9+qhAAu5uHRAmLUJIz5+/mHWKJeJYEjdLV67Nl1OiJV0ew=
=4/ki
-----END PGP SIGNATURE-----

--=-A80GLlubixwLRS5nSxh2--
