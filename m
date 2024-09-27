Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E82290F
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 02:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727402579; cv=none; b=f0IBCzDF2QdzPFVQDSryRAyVL3hu9GIpSHyq5AO20Qy37IYxToHmDTjH1WxW9kSFa7BIGS4te7cmpSnTHtwkEOx9BP8yrgCKkScFy5w/qidSjQNK7JL289xUO+YgxTk8St3K59oRUaMRayMPzt/SZHDhdsjKD9InUB8IbyoU+3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727402579; c=relaxed/simple;
	bh=BQL9qCrHsiPnNdbKuAwt41xVjbgBh1gg81qaeNqjQX4=;
	h=From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Type; b=lNgW3Yn+vik5zigD3VURKguYZjVqGSgs6S+UOfTjxxW/yJfGT5Q2aU0u2VAx4LXI8y58LExl/cKkrcfRdUEy64hS8LCXbEHRJ6rBih60xrMNiexT5QKXy/B+g9xQzJXCJN95wW+vuHbDhP6hcF1wj9K4lrspOIYDLLmYwjDm138=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com; spf=pass smtp.mailfrom=net-swift.com; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=net-swift.com
X-QQ-mid:Yeas3t1727402535t087t34301
Received: from 73E00E8BC808433CB9DB281092DFBE6B (duanqiangwen@net-swift.com [60.186.242.192])
X-QQ-SSF:00400000000000F0FI4000000000000
From: duanqiangwen@net-swift.com
X-BIZMAIL-ID: 14199240526905965873
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
	<stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>,
	"'David S. Miller'" <davem@davemloft.net>,
	"'Sasha Levin'" <sashal@kernel.org>
References: <20240430103058.010791820@linuxfoundation.org> <20240430103059.311606449@linuxfoundation.org>
In-Reply-To: <20240430103059.311606449@linuxfoundation.org>
Subject: RE: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
Date: Fri, 27 Sep 2024 10:02:14 +0800
Message-ID: <000201db1081$45ae0660$d10a1320$@net-swift.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFOC2zPFGIL1BJCPg2TAnlAJkwjuwHfHi+Qs3XyrZA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:net-swift.com:qybglogicsvrgz:qybglogicsvrgz7a-0

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 2024=C4=EA4=D4=C230=C8=D5 18:38
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> patches@lists.linux.dev; Duanqiang Wen <duanqiangwen@net-swift.com>;
> David S. Miller <davem@davemloft.net>; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
>=20
> 6.6-stable review patch.  If anyone has any objections, please let me
know.
>=20
> ------------------
>=20
> From: Duanqiang Wen <duanqiangwen@net-swift.com>
>=20
> [ Upstream commit 69197dfc64007b5292cc960581548f41ccd44828 ]
>=20
> driver needs queue msix vectors and one misc irq vector, but only =
queue
> vectors need irq affinity.
> when num_online_cpus is less than chip max msix vectors, driver will
acquire
> (num_online_cpus + 1) vecotrs, and call pci_alloc_irq_vectors_affinity
> functions with affinity params without setting pre_vectors or
post_vectors, it
> will cause return error code -ENOSPC.
> Misc irq vector is vector 0, driver need to set affinity params
.pre_vectors =3D 1.
>=20
> Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> index e078f4071dc23..be434c833c69c 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> @@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx *wx)
>   */
>  static int wx_acquire_msix_vectors(struct wx *wx)  {
> -	struct irq_affinity affd =3D {0, };
> +	struct irq_affinity affd =3D { .pre_vectors =3D 1 };
>  	int nvecs, i;
>=20
>  	nvecs =3D min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
> --
> 2.43.0
>=20
This patch in kernel-6.6 and kernel 6.7 will cause problems. In =
kernel-6.6
and kernel 6.7,=20
Wangxun txgbe & ngbe driver adjust misc irq to vector 0 not yet.  How to
revert it in
kernel-6.6 and kernel-6.7 stable?>=20
>=20

