Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B752874FB;
	Fri,  1 May 2026 21:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777671553; cv=none; b=F1i6ds3qPDTc796m1rsERflesdCCgd66vyWCjCNK5nSAow8PLf3k1uobEHFjsZusgyTvzjcsnlPRpR4p6gVah+m29jVTztJu001kyd49MoztVEU2mNdmdc+drFuHg740isiMeRz/yqnYurbOuDg5qj1q5q4iF5PsLqPftT2pbsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777671553; c=relaxed/simple;
	bh=IZ4fMqegu5iKE8cxWQbd1JhDfA6xQ/yHQeOrJcQf+68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mm5+GgKI8wpnfapwdK2UgPe6m4DBBAZHfexFx50p49QMXwv0Tni5RRsiagP1GMAFjEJV1bDpPBIeeCCx+2HThrStK0tfgBCceo3uI68QKYYUpOxaUK+tp16Z0TwSKD4cI/MtRb3bJXkA1xAXXDkvPcC4Pc0s71oZwuVa97M88zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpL0xOq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpL0xOq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7823AC2BCB4;
	Fri,  1 May 2026 21:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777671552;
	bh=IZ4fMqegu5iKE8cxWQbd1JhDfA6xQ/yHQeOrJcQf+68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpL0xOq1ja8r7/RpfQgHVLfSj5uIVZW+drXKO1vyEJAPdMDONTwfTBzhyop/4dQjk
	 w2DDxccgFytfc+ASNlY4MJR3xBt7yeAM3nGeNfSeyn8nfMSk+lrMJ/+8DIDhp9uQKO
	 P0R0E6ZcZBgOFTkDUQmyE+pcLAOV++3WAHqBogQUqtThAjTl0Vm75CCG3FZz+mUyw5
	 ErfkIEP9iQbtakHVl/zgKU5mGuTuWbgn4TLEN0L+skPvOC+qIDV+VRcdDkWLjA4d2d
	 F5lYRPz9PQkvKygqqPiGC3sj0AEGdcvmR0NfozTt4QNl2eKY0ooLfjYT5HScDaxiQq
	 BbPOp/pqFYLnA==
Date: Fri, 1 May 2026 17:39:10 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	lvc-project@linuxtesting.org, Fedor Pchelkin <pchelkin@ispras.ru>
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <afUdfo_lfJJX_2pG@laps>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <20260501200000.item005-revert@kernel.org>
 <6eb47d20-ed49-45f6-90f1-41c15fa99896@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6eb47d20-ed49-45f6-90f1-41c15fa99896@kernel.dk>

On Fri, May 01, 2026 at 03:23:33PM -0600, Jens Axboe wrote:
>On 5/1/26 3:11 PM, Sasha Levin wrote:
>> On Fri, 01 May 2026 11:54:18 +0300, Fedor Pchelkin wrote:
>>> The Fixes: tag of upstream 84230ad2d2afb points to 97b388d70b53
>>> ("io_uring: handle completions in the core", v5.19), which is NOT
>>> present in 5.10 or 5.15. Additionally, in 5.10/5.15 'preq->result'
>>> is unsigned so the 'if (preq->result < 0)' check is a no-op, and
>>> __io_poll_add() already completes the request when it returns
>>> non-zero, leading to a potential double-completion.
>>>
>>> I would suggest to revert the patch from these trees because there
>>> appears to be no real bug to fix.
>>
>> Agreed. I've reverted both the original backport and the followup
>> "fix backport" commit on 5.10 and 5.15.
>
>Please hold off, I have fully tested these. It's quite possible they are
>wonky in certain ways, but they currently fix a livelock as well that
>you can hit on 5.10/15 which is arguably worse. Double claim + complete
>should be handled by the poll grab side, I'm _assuming_ more cosmetic
>than anything else.
>
>Please refrain from dropping patches until they have been confirmed by
>someone that actually knows the code. I've been busy today and haven't
>had time to look into this one just yet. You're just making more work
>for me by dropping this you have little insight into.

I haven't realized that this was a custom backport - I thought that they were
pulled in without the Fixes commit being present.

I'll drop the revert, luckily this wasn't pushed to stable-queue yet.

-- 
Thanks,
Sasha
