Received: from mail-m16.yeah.net (mail-m16.yeah.net [220.197.32.16])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD6C23AB;
	Sun,  1 Sep 2024 07:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725176243; cv=none; b=a6BY6usIMj2FIEy8lsJH9V5HR/d57CYJEoZLxAc64o59tg3oGmAupSBa8yKjyykz3LfsCLJb97JUQNVNIT1hJ+9QqDizlX69yMlCerTrEjU8R0N1QGyl3j1njF7LrVMdwquNIXoYUzEavKto23ICELbYcoaP4UlDO15jhghgsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725176243; c=relaxed/simple;
	bh=wi7L4ZDwktZiC+F/59oVfeIEQMcrwpQFSajswZvZ+Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0n/sQMgyc0umBYzqz/MBasp+qT2JxAtB9jn6IMQ1DPSOyp1+YCWNjtra2cJRHLNfjYd5RNA43p2XGm5wjOEqDN26RHpRIiqKEz+50JHtVcDUUxwfEI0UG38lhpbYHFl/OFUHO7bOCPlBdTipH6W4q/Eg/349ntTLr76XJtdyt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=Ssy/SiYt; arc=none smtp.client-ip=220.197.32.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="Ssy/SiYt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Date:From:Subject:Message-ID:MIME-Version:
	Content-Type; bh=XUKwHwHeZnfMiWQx9ysnjJQqAF9uH2ywN1zSmv3u0Yw=;
	b=Ssy/SiYtfJuY8YrQQnXuAmU+ujDdWwc5Ej+/795nngedfvpht9mGJbjGwaxRig
	XIB3NBhbMZAa6RhoK/i2FchRFDkbQCRZf4zn81jql+9MSChXVBQHPcZcSK3ODn+i
	TSHPwOxq3leFrdb/HmTZztUCWqGJ9ytW6X5Sjy//LnQoM=
Received: from dragon (unknown [114.216.210.89])
	by gzsmtp3 (Coremail) with SMTP id M88vCgD3J_WbGdRmIqJCAA--.32384S3;
	Sun, 01 Sep 2024 15:37:01 +0800 (CST)
Date: Sun, 1 Sep 2024 15:36:59 +0800
From: Shawn Guo <shawnguo2@yeah.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] ARM: imx: Annotate imx7d_enet_init() as __init
Message-ID: <ZtQZmxbLxr3dXZ/N@dragon>
References: <20240822-imx7d-mark-imx7d_enet_init-as-init-v1-1-8dfadee3bed4@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822-imx7d-mark-imx7d_enet_init-as-init-v1-1-8dfadee3bed4@kernel.org>
X-CM-TRANSID:M88vCgD3J_WbGdRmIqJCAA--.32384S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xryxtr47tr1Dtr4DXFWrXwb_yoWfGrg_Zr
	48Xw1xCr1UWw1vkw1vgFy3Aryqkw40qFy3Zrn5W3yIq34fJayvyas5G393J3s7WwsrZF98
	CrW5Jr43trnFqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0XVy7UUUUU==
X-CM-SenderInfo: pvkd40hjxrjqh1hdxhhqhw/1tbiCQJNZWbUDFkdrQAAs0

On Thu, Aug 22, 2024 at 05:05:17PM -0700, Nathan Chancellor wrote:
> After a recent LLVM change [1] that deduces __cold on functions that
> only call cold code (such as __init functions), there is a section
> mismatch warning from imx7d_enet_init(), which got moved to
> .text.unlikely. as a result of that optimization:
> 
>   WARNING: modpost: vmlinux: section mismatch in reference: imx7d_enet_init+0x20 (section: .text.unlikely.) -> imx7d_enet_clk_sel (section: .init.text)
> 
> Drop the inline keyword (which does not guarantee inlining) and replace
> it with __init, as imx7d_enet_init() is only called from __init code,
> which clears up the warning.
> 
> Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied, thanks!

