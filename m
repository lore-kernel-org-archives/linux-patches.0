Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E23AEAC6
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 07:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727420450; cv=none; b=OBmRxE0WFI8+IrL7GW07djuPjI50XDUV+4dzeFBpW2Hp7Shg87SDhmdIt0aEB8/I0MlAui3w7EVLwOn7ZVLD4Cy8Pp9oebKV63IrdBzAaf+3MDzDqcxe7fTgxYZN5HagLUSfF75PgTqaioSmRpe8klzkYBjgdC+6dqVxO2FvVyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727420450; c=relaxed/simple;
	bh=PFnApE/C+ZHBlowwZwA9bLXw/UX4Qkv6SWf9h8FhqQs=;
	h=From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Type; b=YN23ABihCUUQkFI6OLvzy+phQJfuWhnesa+g8kvqh8/c77UQOmtplZWH0Cfb87ZtvNpDNhPToDSama79boqSk97k8SV3soqvjNIEjRHj4aT+x9m9xBY++Vm4zrKQ+Sa3jmuB03FxCnC0QJn+GAfrays9r/uxDmFFXdxtZ6iQx0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com; spf=pass smtp.mailfrom=net-swift.com; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=net-swift.com
X-QQ-mid:Yeas7t1727420383t138t30679
Received: from 73E00E8BC808433CB9DB281092DFBE6B (duanqiangwen@net-swift.com [60.186.242.192])
X-QQ-SSF:00400000000000F0FI4000000000000
From: duanqiangwen@net-swift.com
X-BIZMAIL-ID: 11177712466447322945
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>,
	<patches@lists.linux.dev>,
	"'David S. Miller'" <davem@davemloft.net>,
	"'Sasha Levin'" <sashal@kernel.org>
References: <20240430103058.010791820@linuxfoundation.org> <20240430103059.311606449@linuxfoundation.org> <000201db1081$45ae0660$d10a1320$@net-swift.com> <2024092715-olive-disallow-e28c@gregkh>
In-Reply-To: <2024092715-olive-disallow-e28c@gregkh>
Subject: RE: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
Date: Fri, 27 Sep 2024 14:59:42 +0800
Message-ID: <001701db10aa$d3fd7710$7bf86530$@net-swift.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFOC2zPFGIL1BJCPg2TAnlAJkwjuwHfHi+QAbIP1l4BpKpYSbNbj4Yg
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:net-swift.com:qybglogicsvrgz:qybglogicsvrgz7a-0

> -----Original Message-----
> From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
> Sent: 2024=E5=B9=B49=E6=9C=8827=E6=97=A5 14:53
> To: duanqiangwen@net-swift.com
> Cc: stable@vger.kernel.org; patches@lists.linux.dev; 'David S. Miller'
> <davem@davemloft.net>; 'Sasha Levin' <sashal@kernel.org>
> Subject: Re: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors =
failed
>=20
> On Fri, Sep 27, 2024 at 10:02:14AM +0800, duanqiangwen@net-swift.com
> wrote:
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: 2024=E5=B9=B44=E6=9C=8830=E6=97=A5 18:38
> > > To: stable@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > patches@lists.linux.dev; Duanqiang Wen <duanqiangwen@net-
> swift.com>;
> > > David S. Miller <davem@davemloft.net>; Sasha Levin
> > > <sashal@kernel.org>
> > > Subject: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors
> > > failed
> > >
> > > 6.6-stable review patch.  If anyone has any objections, please let
> > > me
> > know.
> > >
> > > ------------------
> > >
> > > From: Duanqiang Wen <duanqiangwen@net-swift.com>
> > >
> > > [ Upstream commit 69197dfc64007b5292cc960581548f41ccd44828 ]
> > >
> > > driver needs queue msix vectors and one misc irq vector, but only
> > > queue vectors need irq affinity.
> > > when num_online_cpus is less than chip max msix vectors, driver =
will
> > acquire
> > > (num_online_cpus + 1) vecotrs, and call
> > > pci_alloc_irq_vectors_affinity functions with affinity params
> > > without setting pre_vectors or
> > post_vectors, it
> > > will cause return error code -ENOSPC.
> > > Misc irq vector is vector 0, driver need to set affinity params
> > .pre_vectors =3D 1.
> > >
> > > Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> > > Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > index e078f4071dc23..be434c833c69c 100644
> > > --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> > > @@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx *wx)
> > >   */
> > >  static int wx_acquire_msix_vectors(struct wx *wx)  {
> > > -	struct irq_affinity affd =3D {0, };
> > > +	struct irq_affinity affd =3D { .pre_vectors =3D 1 };
> > >  	int nvecs, i;
> > >
> > >  	nvecs =3D min_t(int, num_online_cpus(), =
wx->mac.max_msix_vectors);
> > > --
> > > 2.43.0
> > >
> > This patch in kernel-6.6 and kernel 6.7 will cause problems. In
> > kernel-6.6 and kernel 6.7, Wangxun txgbe & ngbe driver adjust misc =
irq
> > to vector 0 not yet.  How to revert it in
> > kernel-6.6 and kernel-6.7 stable?>
>=20
> Please send a revert.
>=20
> thanks,
>=20
> greg k-h
>=20
Should I send revert to stable/master repo? I only wan't to revert it in =
6.6.y and 6.7.y.
How maintainer recognize this revert should be applied in different =
tags?

