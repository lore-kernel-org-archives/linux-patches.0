Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B905136999F
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 10:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770806881; cv=none; b=MnAyHWUYpNFdxkJc7KVr7lksET1hGQ5PL0NUJBE215S5weZ1R8Qt4TInQAuDKnnyEvzbBaH6bIOdv1FNyK25DJcVo8JFjQwq/eaqp0tK0jW04ABXs/KVnedslnRY/YiDU51kOf+BK+wpuESoYs/uD5eEdnmtPx1eSNA8SWZ9c0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770806881; c=relaxed/simple;
	bh=MCPUUa2Ju6eg947OwRzfohkwmuQ65i4CAV4qwF6eXww=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LTr8XMb8nOeqRX4O+jBNNwYzYYKl4O21IV+eBLb0Rp0lDWX1zia4mqz16ryWI/Utv5FMEWC+daEiVvO7tOOsQklFhKYbJNy5ugb0i7X5ibBxXj1vID4fd+77PfHo8iM2h8Tv/9mgUpYSMFvNNFPLDwqRQWPC6YJSIUQ1i6kAMis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <jlu@pengutronix.de>)
	id 1vq7lF-0008Tc-Ps; Wed, 11 Feb 2026 11:47:57 +0100
Message-ID: <a85c602ecdd204145d4b7364418c7c52b8d6cd44.camel@pengutronix.de>
Subject: Re: [PATCH 6.12 002/169] ptp: Add PHC file mode checks. Allow RO
 adjtime() without FMODE_WRITE.
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
Reply-To: jlu@pengutronix.de
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Richard Cochran <richardcochran@gmail.com>, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, Wojtek Wasko
 <wwasko@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>,  "David S.
 Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
Date: Wed, 11 Feb 2026 11:47:56 +0100
In-Reply-To: <20260128145334.099814052@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
	 <20260128145334.099814052@linuxfoundation.org>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev

Hi,

these new permission checks break chrony < 4.8 (as used in Debian stable) w=
hen
using the PHC reclock with extpps mode, as it's opening the device without
O_RDWR.=C2=A0

chrony 4.8 is fixed:
https://gitlab.com/chrony/chrony/-/commit/f78e4681eff71d941fab3be5ee406d920=
a155a20

I've also reported this to Debian:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1127659

Regards,
Jan

On Wed, 2026-01-28 at 16:21 +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.=C2=A0 If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Wojtek Wasko <wwasko@nvidia.com>
>=20
> [ Upstream commit b4e53b15c04e3852949003752f48f7a14ae39e86 ]
>=20
> Many devices implement highly accurate clocks, which the kernel manages
> as PTP Hardware Clocks (PHCs). Userspace applications rely on these
> clocks to timestamp events, trace workload execution, correlate
> timescales across devices, and keep various clocks in sync.
>=20
> The kernel=E2=80=99s current implementation of PTP clocks does not enforc=
e file
> permissions checks for most device operations except for POSIX clock
> operations, where file mode is verified in the POSIX layer before
> forwarding the call to the PTP subsystem. Consequently, it is common
> practice to not give unprivileged userspace applications any access to
> PTP clocks whatsoever by giving the PTP chardevs 600 permissions. An
> example of users running into this limitation is documented in [1].
> Additionally, POSIX layer requires WRITE permission even for readonly
> adjtime() calls which are used in PTP layer to return current frequency
> offset applied to the PHC.
>=20
> Add permission checks for functions that modify the state of a PTP
> device. Continue enforcing permission checks for POSIX clock operations
> (settime, adjtime) in the POSIX layer. Only require WRITE access for
> dynamic clocks adjtime() if any flags are set in the modes field.
>=20
> [1] https://lists.nwtime.org/sympa/arc/linuxptp-users/2024-01/msg00036.ht=
ml
>=20
> Changes in v4:
> - Require FMODE_WRITE in ajtime() only for calls modifying the clock in
> =C2=A0 any way.
>=20
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> Signed-off-by: Wojtek Wasko <wwasko@nvidia.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =C2=A0drivers/ptp/ptp_chardev.c | 16 ++++++++++++++++
> =C2=A0kernel/time/posix-clock.c |=C2=A0 2 +-
> =C2=A02 files changed, 17 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index bf6468c56419c..4380e6ddb8495 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -205,6 +205,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext=
,
> unsigned int cmd,
> =C2=A0
> =C2=A0	case PTP_EXTTS_REQUEST:
> =C2=A0	case PTP_EXTTS_REQUEST2:
> +		if ((pccontext->fp->f_mode & FMODE_WRITE) =3D=3D 0) {
> +			err =3D -EACCES;
> +			break;
> +		}
> =C2=A0		memset(&req, 0, sizeof(req));
> =C2=A0
> =C2=A0		if (copy_from_user(&req.extts, (void __user *)arg,
> @@ -246,6 +250,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext=
,
> unsigned int cmd,
> =C2=A0
> =C2=A0	case PTP_PEROUT_REQUEST:
> =C2=A0	case PTP_PEROUT_REQUEST2:
> +		if ((pccontext->fp->f_mode & FMODE_WRITE) =3D=3D 0) {
> +			err =3D -EACCES;
> +			break;
> +		}
> =C2=A0		memset(&req, 0, sizeof(req));
> =C2=A0
> =C2=A0		if (copy_from_user(&req.perout, (void __user *)arg,
> @@ -314,6 +322,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext=
,
> unsigned int cmd,
> =C2=A0
> =C2=A0	case PTP_ENABLE_PPS:
> =C2=A0	case PTP_ENABLE_PPS2:
> +		if ((pccontext->fp->f_mode & FMODE_WRITE) =3D=3D 0) {
> +			err =3D -EACCES;
> +			break;
> +		}
> =C2=A0		memset(&req, 0, sizeof(req));
> =C2=A0
> =C2=A0		if (!capable(CAP_SYS_TIME))
> @@ -456,6 +468,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext=
,
> unsigned int cmd,
> =C2=A0
> =C2=A0	case PTP_PIN_SETFUNC:
> =C2=A0	case PTP_PIN_SETFUNC2:
> +		if ((pccontext->fp->f_mode & FMODE_WRITE) =3D=3D 0) {
> +			err =3D -EACCES;
> +			break;
> +		}
> =C2=A0		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
> =C2=A0			err =3D -EFAULT;
> =C2=A0			break;
> diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
> index 4e114e34a6e0a..fe963384d5c2a 100644
> --- a/kernel/time/posix-clock.c
> +++ b/kernel/time/posix-clock.c
> @@ -252,7 +252,7 @@ static int pc_clock_adjtime(clockid_t id, struct
> __kernel_timex *tx)
> =C2=A0	if (err)
> =C2=A0		return err;
> =C2=A0
> -	if ((cd.fp->f_mode & FMODE_WRITE) =3D=3D 0) {
> +	if (tx->modes && (cd.fp->f_mode & FMODE_WRITE) =3D=3D 0) {
> =C2=A0		err =3D -EACCES;
> =C2=A0		goto out;
> =C2=A0	}

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
