Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3B3081D6;
	Thu, 23 Apr 2026 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947795; cv=none; b=mGyodUgDTpLvYhMhjDVco+6ymzhxgDIIuLDUJtrUrBDe7nGBqVFP6XMJB8Cw51Roc+Eur/VuDvIXrOaPlIi/XSMNa2cHciqln08rhmcT9yVbqWdzpoV+kybmb4DkMijocW1PuqHNB3Vj+0OeQ9OG/L1lrsV1ThbMWpQt8AQFQ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947795; c=relaxed/simple;
	bh=aTU4Y0jn0+VAZuFqiTN5UqRS8o7aSuHQhMFUdqo3zts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P62Qwp0maKcUHgWmhldTbt/CNoM4DiDW1NtLJlcNOb7ub7DYilUqNNW5qvHnchIG+s8rAyS29ttw5XrOiykDcNr1V1j4OU35CfYcSBRX+M++Enb9SQzzwBC0zlx1tM+hOYvL5P8xa++UJHvgi1q6+qT7tOzwsL7eAHeMM4aqNIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1it/zYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1it/zYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E36C2BCAF;
	Thu, 23 Apr 2026 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776947795;
	bh=aTU4Y0jn0+VAZuFqiTN5UqRS8o7aSuHQhMFUdqo3zts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J1it/zYcNnmuwb313C4Ofz/uX+MgYimqiiwZOfYW6vmoOhMmm0RfY6QqMlBK+3PVo
	 p9QQHzVtqUGFL+VLub7iCVDnjJ0ZJ89znArXh22AjcPCoygEjXhCpQDME42S6Y41gM
	 kanOc6GVUNKThfsKtBSKXDbt3xaw46oJHOLeTi/0=
Date: Thu, 23 Apr 2026 14:36:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <2026042317-suitcase-appealing-3398@gregkh>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
 <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
 <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
 <97121442-388e-454c-9a85-85e4dd66cc19@kernel.dk>
 <2026042330-pond-resupply-6d1e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026042330-pond-resupply-6d1e@gregkh>

On Thu, Apr 23, 2026 at 02:35:41PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 23, 2026 at 06:30:02AM -0600, Jens Axboe wrote:
> > On 4/21/26 4:58 PM, Jens Axboe wrote:
> > > On 4/21/26 4:18 PM, Jens Axboe wrote:
> > >>>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
> > >>>>  		if (req->poll_update.update_user_data)
> > >>>>  			preq->user_data = req->poll_update.new_user_data;
> > >>>>  
> > >>>> -		ret2 = io_poll_add(preq, issue_flags);
> > >>>> +		ret2 = __io_poll_add(preq, issue_flags);
> > >>>>  		/* successfully updated, don't complete poll request */
> > >>>>  		if (!ret2)
> > >>>>  			goto out;
> > >>>> +		preq->result = ret2;
> > >>>> +
> > >>>>  	}
> > >>>> -	req_set_fail(preq);
> > >>>> -	io_req_complete(preq, -ECANCELED);
> > >>>> +	if (preq->result < 0)
> > >>>> +		req_set_fail(preq);
> > >>>> +	io_req_complete(preq, preq->result);
> > >>>
> > >>> If __io_poll_add() returned an events mask then it completed preq, but
> > >>> then we also complete preq here.  Is that really correct?
> > >>
> > >> Let me take a closer look, I do agree with you that the final result
> > >> does not look entirely correct.
> > > 
> > > As far as I can tell, these two should be applied to 5.10 and 5.15
> > > stable. The first one fixes an old backporting issue that I didn't
> > > notice until doing some targeted testing just now. The second one should
> > > take care of the issues that Ben spotted in the current backport.
> > > 
> > > Will be nice when 5.x is finally taken out behind the barn :-)
> > 
> > Greg, you adding these 2 for 5.10/5.15?
> 
> Sorry but "these 2" what?

Ah, nevermind, missed the attachments, let me go queue them up now,
thanks for reminding me!

greg k-h
