Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8979366561;
	Thu, 23 Apr 2026 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947764; cv=none; b=DmHRtEClnmKrWPJ4BFzxNpnTJNPkonUshS6GZGxyzOHii9FBamaI/wEiqQnlviAGEN+AJCdaEOVE0EDOESc0bwv9hSmyvqkcJtFEWON+kaPOE5tl64IX5oOOVbVd4AnWvDUx8tl3E8aFTxhXJ5bx1ddw6JQvoAQJfUi9YdhAh1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947764; c=relaxed/simple;
	bh=56FefZLDpHmmuys3ADZGV9omyKcSpyvrLvTRasm58do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0Wc7g6RiRVbWgAOfwUVPyffp1PnpiyjwhgGcRc/7BkAIo073q+O8b7kw2iUiFSeJ3YdwqPal50r3IoQSEv1pIfJVPw9xezGQoebnC+op0jPs2Uol13vLdFp1kpyIMD0F1DrfFFSbIGxegvS9OtDNMofgne1od2kF0lhvSW+IeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeWJASey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeWJASey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C47C2BCAF;
	Thu, 23 Apr 2026 12:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776947764;
	bh=56FefZLDpHmmuys3ADZGV9omyKcSpyvrLvTRasm58do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SeWJASeyERbJPmLOtBz0cys0VpWKvb34/WaYOKEYuZ8SwYyP8jrjUBh+Ij3Kts3G1
	 lT6bdl466dN2x7VSVoC8tClD3RJmaEg9uJjs2Fp2dCd3JY+r+fNRjDxl70obBs287u
	 ZPhhyllGB1hwULM9H8WH5Sd2AUqSBdH/oYwdd7Uw=
Date: Thu, 23 Apr 2026 14:35:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <2026042330-pond-resupply-6d1e@gregkh>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
 <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
 <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
 <97121442-388e-454c-9a85-85e4dd66cc19@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97121442-388e-454c-9a85-85e4dd66cc19@kernel.dk>

On Thu, Apr 23, 2026 at 06:30:02AM -0600, Jens Axboe wrote:
> On 4/21/26 4:58 PM, Jens Axboe wrote:
> > On 4/21/26 4:18 PM, Jens Axboe wrote:
> >>>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
> >>>>  		if (req->poll_update.update_user_data)
> >>>>  			preq->user_data = req->poll_update.new_user_data;
> >>>>  
> >>>> -		ret2 = io_poll_add(preq, issue_flags);
> >>>> +		ret2 = __io_poll_add(preq, issue_flags);
> >>>>  		/* successfully updated, don't complete poll request */
> >>>>  		if (!ret2)
> >>>>  			goto out;
> >>>> +		preq->result = ret2;
> >>>> +
> >>>>  	}
> >>>> -	req_set_fail(preq);
> >>>> -	io_req_complete(preq, -ECANCELED);
> >>>> +	if (preq->result < 0)
> >>>> +		req_set_fail(preq);
> >>>> +	io_req_complete(preq, preq->result);
> >>>
> >>> If __io_poll_add() returned an events mask then it completed preq, but
> >>> then we also complete preq here.  Is that really correct?
> >>
> >> Let me take a closer look, I do agree with you that the final result
> >> does not look entirely correct.
> > 
> > As far as I can tell, these two should be applied to 5.10 and 5.15
> > stable. The first one fixes an old backporting issue that I didn't
> > notice until doing some targeted testing just now. The second one should
> > take care of the issues that Ben spotted in the current backport.
> > 
> > Will be nice when 5.x is finally taken out behind the barn :-)
> 
> Greg, you adding these 2 for 5.10/5.15?

Sorry but "these 2" what?

confused,

greg k-h
