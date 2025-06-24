Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECFA19F480;
	Tue, 24 Jun 2025 10:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759799; cv=none; b=GD4KA4JaBeXTQiWye89J3pUmqMoukrBDtf/bEC0S8C3ruRIdBoLejVhyK7sFSnmdyjexzJoynDXCrxr2v3Kj234chYNNOGu1gE0xaeqOBuPsWob2xLPcceQGjY8yFy5F90BldFeEtebGI1HzwOYc+j6YwMZJvOUnBbX1nZ2oeW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759799; c=relaxed/simple;
	bh=J9RJ3coPB46I++cggYob00efMH6HCcP8JaBmVfloOUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FY/rbzuxKsE6L8wIpH+OsbCxUOvvQFEkp1KqMHsbY0WZ8v0Y+t+wHoHcj1KL+iGej3uz1oqwoZmNMfpYrHNZfT986wyCYJqirVvauAABcyeXVrxMYFWkHsdg+vwbATOafd89eLc6F4j/dAaL38Z69nNGsweHkG/4O547JZLvX+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hY1p/XLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hY1p/XLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C92C4CEE3;
	Tue, 24 Jun 2025 10:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750759799;
	bh=J9RJ3coPB46I++cggYob00efMH6HCcP8JaBmVfloOUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hY1p/XLiVvvKYKMVeJ9kjrjdO3KVafXqNfw3ofVh9n4ScQTRupVC6KU4DLsO5ir6O
	 LVcW6W7M9uW1Yely0243bvMhFi7z3LVJlXbomGGylkOmzpoEZM904OzBvktvmuT8FY
	 Ac3S4reg4WXUNOguhRMcfvjbR3qDCzw5aMsA6U2E=
Date: Tue, 24 Jun 2025 11:09:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Protopopov <a.s.protopopov@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 044/355] libbpf: Use proper errno value in nlattr
Message-ID: <2025062435-hence-ultimate-a8ac@gregkh>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130628.151124578@linuxfoundation.org>
 <aFlcsaJuwG9HQf6S@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFlcsaJuwG9HQf6S@mail.gmail.com>

On Mon, Jun 23, 2025 at 01:54:57PM +0000, Anton Protopopov wrote:
> On 25/06/23 03:04PM, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Anton Protopopov <a.s.protopopov@gmail.com>
> > 
> > [ Upstream commit fd5fd538a1f4b34cee6823ba0ddda2f7a55aca96 ]
> > 
> > Return value of the validate_nla() function can be propagated all the
> > way up to users of libbpf API. In case of error this libbpf version
> > of validate_nla returns -1 which will be seen as -EPERM from user's
> > point of view. Instead, return a more reasonable -EINVAL.
> > 
> > Fixes: bbf48c18ee0c ("libbpf: add error reporting in XDP")
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > Link: https://lore.kernel.org/bpf/20250510182011.2246631-1-a.s.protopopov@gmail.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  tools/lib/bpf/nlattr.c | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
> > index 1a04299a2a604..35ad5a845a147 100644
> > --- a/tools/lib/bpf/nlattr.c
> > +++ b/tools/lib/bpf/nlattr.c
> > @@ -63,16 +63,16 @@ static int validate_nla(struct nlattr *nla, int maxtype,
> >  		minlen = nla_attr_minlen[pt->type];
> >  
> >  	if (libbpf_nla_len(nla) < minlen)
> > -		return -1;
> > +		return -EINVAL;
> >  
> >  	if (pt->maxlen && libbpf_nla_len(nla) > pt->maxlen)
> > -		return -1;
> > +		return -EINVAL;
> >  
> >  	if (pt->type == LIBBPF_NLA_STRING) {
> >  		char *data = libbpf_nla_data(nla);
> >  
> >  		if (data[libbpf_nla_len(nla) - 1] != '\0')
> > -			return -1;
> > +			return -EINVAL;
> >  	}
> >  
> >  	return 0;
> > @@ -118,19 +118,18 @@ int libbpf_nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head,
> >  		if (policy) {
> >  			err = validate_nla(nla, maxtype, policy);
> >  			if (err < 0)
> > -				goto errout;
> > +				return err;
> >  		}
> >  
> > -		if (tb[type])
> > +		if (tb[type]) {
> >  			pr_warn("Attribute of type %#x found multiple times in message, "
> >  				"previous attribute is being ignored.\n", type);
> > +		}
> >  
> >  		tb[type] = nla;
> >  	}
> >  
> > -	err = 0;
> > -errout:
> > -	return err;
> > +	return 0;
> >  }
> >  
> >  /**
> > -- 
> > 2.39.5
> > 
> 
> The patch ^ is ok. But the rest of the letter below is unrelated:
> 
> > 
> > wer/supply/bq27xxx_battery_i2c.c b/drivers/power/supply/bq27xxx_battery_i2c.c
> > index ba0d22d904295..868e95f0887e1 100644
> > --- a/drivers/power/supply/bq27xxx_battery_i2c.c

<snip>

Looks like the race condition in my local email scripts finally
happened, I was sending all of these to my local instance at the same
time and the temp file name overlapped.  Not bad for working well for
20+ years, I guess it's finally time to fix it :)

The original patches here are fine, no need to worry, thanks for
noticing it though, it's good to see people are reviewing this stuff.

Here's the code if anyone wants to laugh at it:

	# Create new unique filenames of the form
	# MAILFILE:  ccyy-mm-dd-hh.mm.ss[-x].mail
	# MSMTPFILE: ccyy-mm-dd-hh.mm.ss[-x].msmtp
	# where x is a consecutive number only appended if you send more than one
	# mail per second.
	BASE="`date +%Y-%m-%d-%H.%M.%S`"
	if [ -f "$BASE.mail" -o -f "$BASE.msmtp" ]; then
		TMP="$BASE"
		i=1
		while [ -f "$TMP-$i.mail" -o -f "$TMP-$i.msmtp" ]; do
			i=$(expr $i + 1)
		done
		BASE="$BASE-$i"
	fi
	MAILFILE="$BASE.mail"
	MSMTPFILE="$BASE.msmtp"

	# Write command line to $MSMTPFILE
	echo "$@" > "$MSMTPFILE" || exit 1


thanks,

greg k-h
