Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BF63148B1;
	Mon, 19 Jan 2026 11:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768822795; cv=none; b=dQSf5C3N6LOHQwZWIHIDoNa8cz6MwBxbgqUuHsRlc8Jl16+d3nmDx5I8numTFgIiWFyAVP2eIic9ibsOvqK0KLDFbWvBdUGpsckX6AFrYKkkFkd43T+3CW3AmbIEvjWo2tLbom36eZ/s2cXEqnkB2CbRHx4c7oMQc1HMDlHb2Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768822795; c=relaxed/simple;
	bh=AGjpBY9PRzOJwXFxtqhktNL8+kYSWCpGTglVyO7L64Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWBRqeu8P7/Q00zzMstMnGyHfGZ3tdvqRbnXYSXwuep6P+xnqJkF7DGHipan5Z+LoX8Cs3HrZdqnlXqZAAuBUp2IzOulyufPmIcRR9aiYciz9SdUCMEhhAwv6imbs9ChgbFpaEvS/ljHMjsNj7wr5C5TGy4ZleOsduV3DLRmApQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIvz5gqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIvz5gqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BE8C116C6;
	Mon, 19 Jan 2026 11:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768822794;
	bh=AGjpBY9PRzOJwXFxtqhktNL8+kYSWCpGTglVyO7L64Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JIvz5gqLIqjyWC1/h5tKV6dCljNMKjYphm97dzcn/VptQ8w6UY4wI/PoVMNizRprY
	 4SU5fLHTiEXUvFDv4CUdFm0pmejFSnx2dQHSXwaZkshRPQNYuDduoLz/TEgBJQn3uI
	 b7thoDrdWEhviXRaA7xiH3rf4GmHDQvbyoQaMTcE=
Date: Mon, 19 Jan 2026 12:39:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Keerthana Kalyanasundaram <keerthana.kalyanasundaram@broadcom.com>
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
	stable <stable@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 423/451] tls: Use __sk_dst_get() and dst_dev_rcu()
 in get_netdev_for_sock().
Message-ID: <2026011923-coat-strict-6cc4@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164246.242565555@linuxfoundation.org>
 <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk>
 <CAM8uoQ-F++6iScZBzntmF=KhHRK3=rQvc-oug3KAXPddJPqR-Q@mail.gmail.com>
 <CAM8uoQ_7HD0AtJLqXsRvO=F2knq=BtrdTM2Fv0Dd4h-4oYebNw@mail.gmail.com>
 <2026011944-wielder-ignition-dee8@gregkh>
 <CAM8uoQ-NyJQatRYXty2XdiTjsuO6hRmEam_YaNrBbgEUuK6KQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM8uoQ-NyJQatRYXty2XdiTjsuO6hRmEam_YaNrBbgEUuK6KQA@mail.gmail.com>

On Mon, Jan 19, 2026 at 04:38:41PM +0530, Keerthana Kalyanasundaram wrote:
> On Mon, Jan 19, 2026 at 3:36 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, Jan 19, 2026 at 03:09:32PM +0530, Keerthana Kalyanasundaram wrote:
> > > Hi Greg,
> > >
> > > I have backported the two additional patches required for the 5.10.y tree
> > > and submitted a v2 series. You can find the updated patches here:
> > >
> > https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalyanasundaram@broadcom.com/T/#t
> > >
> > >
> > > Could you please consume these in the next version, or alternatively, add
> > > the two missed patches (commit IDs 5b998545 and 719a402cf) to the current
> > > queue?
> >
> > I've dropped them all from the 5.10.y tree now, and from the 5.15.y
> > tree. Can you also resend that series?
> >
> 
> Hi Greg,
> 
> The other two commits are already part of the stable 5.15.y tree, so
> changes are only needed for the 5.10.y tree.
> 
> Please check my latest v2 patchset : (
> https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalyanasundaram@broadcom.com/T/#t
> )

I see the series, sorry, they are now dropped.  Can you resend them for 5.15?

thanks,

greg k-h
