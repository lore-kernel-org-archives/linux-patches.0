Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D186912B60;
	Tue, 19 Dec 2023 07:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGYJiQVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A49C433C8;
	Tue, 19 Dec 2023 07:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702970599;
	bh=5YOdQKhD83mQjSzjOFpWP6ZK3wwnQuCrw8yf9SpIq6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QGYJiQVPWcJysW7lz9PfDgoKBiEmK6o1Qj0WUvDQuKfEm9Ahw4Yy7/hi2H5b+aZ4U
	 B74l2XQIIvUexTR2uIeOsVmIIOWffMeSZItoLFle+w+fjf+OssV8BcMqbDdC0a3Knd
	 3I639xCv6hU57Ay+cziYxRpNVBUqCSrAphQ3GNd0=
Date: Tue, 19 Dec 2023 08:23:16 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 13/36] net: stmmac: use dev_err_probe() for
 reporting mdio bus registration failure
Message-ID: <2023121945-hatred-revoke-8f86@gregkh>
References: <20231218135041.876499958@linuxfoundation.org>
 <20231218135042.347406314@linuxfoundation.org>
 <6299a661-5ae5-4f7c-9fa7-96c4e7ae39eb@linaro.org>
 <2023121847-surfacing-hardhead-78ab@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023121847-surfacing-hardhead-78ab@gregkh>

On Mon, Dec 18, 2023 at 09:25:02PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Dec 18, 2023 at 12:45:42PM -0600, Daniel Díaz wrote:
> > Hello!
> > 
> > On 18/12/23 7:51 a. m., Greg Kroah-Hartman wrote:
> > > 4.19-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > > 
> > > [ Upstream commit 839612d23ffd933174db911ce56dc3f3ca883ec5 ]
> > > 
> > > I have a board where these two lines are always printed during boot:
> > > 
> > >     imx-dwmac 30bf0000.ethernet: Cannot register the MDIO bus
> > >     imx-dwmac 30bf0000.ethernet: stmmac_dvr_probe: MDIO bus (id: 1) registration failed
> > > 
> > > It's perfectly fine, and the device is successfully (and silently, as
> > > far as the console goes) probed later.
> > > 
> > > Use dev_err_probe() instead, which will demote these messages to debug
> > > level (thus removing the alarming messages from the console) when the
> > > error is -EPROBE_DEFER, and also has the advantage of including the
> > > error code if/when it happens to be something other than -EPROBE_DEFER.
> > > 
> > > While here, add the missing \n to one of the format strings.
> > > 
> > > Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > > Link: https://lore.kernel.org/r/20220602074840.1143360-1-linux@rasmusvillemoes.dk
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > Stable-dep-of: e23c0d21ce92 ("net: stmmac: Handle disabled MDIO busses from devicetree")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -4428,7 +4428,7 @@ int stmmac_dvr_probe(struct device *devi
> > >   		ret = stmmac_mdio_register(ndev);
> > >   		if (ret < 0) {
> > >   			dev_err(priv->device,
> > > -				"%s: MDIO bus (id: %d) registration failed",
> > > +				"%s: MDIO bus (id: %d) registration failed\n",
> > >   				__func__, priv->plat->bus_id);
> > >   			goto error_mdio_register;
> > >   		}
> > 
> > This patch doesn't do what it says it does.
> 
> Hah, it really doesn't, good catch.  I removed dev_err_probe() from the
> 4.19 tree as it didn't make sense to backport it so late in the release
> cycle of it (and it required many other follow-on fixes.)  and so I
> fixed up this commit to build properly, but I didn't realize that all I
> did was properly add a \n to the string, the rest of the commit faded
> away.
> 
> I'll just go drop this entirely, thanks for the review!

Also, it was only added because of the need for it for the next patch in
the series, which I had already fixed up to work properly, so this realy
isn't needed at all.  I'll go drop it now, thanks.

greg k-h
