Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CB72F31
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D3EC433D2;
	Thu, 13 Apr 2023 22:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681423264;
	bh=hX8CWjMDrFtDXuH/nkcOaymmUtk+GZRIjp0k5IesTvo=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=i/V6s08xML4Y0J15dq94uVDVuL8gdRjWepR6MmGV1lVko7Bmk2514xeJ0xJlWN+Z/
	 43r7S06ZT3bTLx3P+Nozh/4CuWb93bkYmz1gNG6QYcp1rgCoSaDG5Tc0DBcH4j5rxq
	 RBMKzHWkC8nqHWwBnx2+OEvjSCSYcNv+CxTaUl5qjoo8MKokHYttKRkUusRjVTJiR1
	 8XDW4X9a++mNqUKRR0o3RiKh1u1YS9Ic13fFvizDngp0mGR/MenugPciZRniVnopIR
	 lE9E4dAWanytDQeuuBVyuEOg83uLui76/JouO8sZ8dodvkEavlPtY1WQAQMNKy53jp
	 ypHR6jUI8KhbA==
Message-ID: <558d22a8848f2f026f272fdc0528424d.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230413-creamer-overstate-f7ce5a72e437@spud>
References: <20230413205528.4044216-1-sboyd@kernel.org> <20230413-creamer-overstate-f7ce5a72e437@spud>
Subject: Re: [PATCH] clk: starfive: Avoid casting iomem pointers
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Tommaso Merciai <tomm.merciai@gmail.com>, Emil Renner Berthing <emil.renner.berthing@canonical.com>, Hal Feng <hal.feng@starfivetech.com>, Conor Dooley <conor.dooley@microchip.com>, Xingyu Wu <xingyu.wu@starfivetech.com>
To: Conor Dooley <conor@kernel.org>
Date: Thu, 13 Apr 2023 15:01:02 -0700
User-Agent: alot/0.10

Quoting Conor Dooley (2023-04-13 14:26:56)
> > @@ -335,26 +338,32 @@ static void jh7110_reset_unregister_adev(void *_a=
dev)
> >       struct auxiliary_device *adev =3D _adev;
> > =20
> >       auxiliary_device_delete(adev);
> > +     auxiliary_device_uninit(adev);
>=20
> Huh, I think you didn't explicitly mention this one, but it's actually
> part of the UAF fix AFAICT?
>=20
> When I did the aux device stuff for the clk-mpfs driver, I copied from
> peci as there were almost no examples of aux dev stuff in-tree.
> It looks like subsequently to me starting development, this fix landed:
> 1c11289b34ab ("peci: cpu: Fix use-after-free in adev_release()")
>=20
> It similarly moves the uninit() to the release callback...
>=20
> I think I need the below (whitespace damaged):

Yeah that looks better. Care to send a proper patch for it?

> diff --git a/drivers/clk/microchip/clk-mpfs.c b/drivers/clk/microchip/clk=
-mpfs.c
> index 4f0a19db7ed7..cc5d7dee59f0 100644
> --- a/drivers/clk/microchip/clk-mpfs.c
> +++ b/drivers/clk/microchip/clk-mpfs.c
> @@ -374,14 +374,13 @@ static void mpfs_reset_unregister_adev(void *_adev)
>         struct auxiliary_device *adev =3D _adev;
> =20
>         auxiliary_device_delete(adev);
> +       auxiliary_device_uninit(adev);
>  }
> =20
>  static void mpfs_reset_adev_release(struct device *dev)
>  {
>         struct auxiliary_device *adev =3D to_auxiliary_dev(dev);
> =20
> -       auxiliary_device_uninit(adev);
> -
>         kfree(adev);
>  }
>=20
> Anyways, for this patch:
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>=20

Thanks.
