Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412A027FB11;
	Tue, 20 May 2025 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747757376; cv=none; b=To8odE45tY6fv/HdmXJUeeQ03jkkZP5MHllXuaP8aAtDFwbekyvJBQPv6VMryy+H+q0TaYCceRy5f43WvlTsxrnMvskzir8ABVPacR7wpuEJjSJjqsmBGFbDiJVSNrtDT7rx1s7iB4R0X3OBi0n2TUoOZqAiQivwTJ4H3cDhpoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747757376; c=relaxed/simple;
	bh=+R04HOmOfccXt0RSDephEzkCpB8I1VduPqNFhk5P/cY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvhIXotoHNGHf1E6okzYyMyQKe9BoQzZ4XBIokddZaPYLyK5k3zozgIVAKAnTDMwO7XL7BP8+S+wnQ0aM1vqQVzEyzDmF+S1yZwh7eea4Bpli858TZYDvkIgIYzf2V4v4yQVl7UbkrwqqKW2LfSJNfWqaumSMCLQTEO4HsAHLn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pak8Lm6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pak8Lm6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA3EC4CEEA;
	Tue, 20 May 2025 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747757375;
	bh=+R04HOmOfccXt0RSDephEzkCpB8I1VduPqNFhk5P/cY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pak8Lm6I26q9MzIn3LzNfLzQPBUrMzhegHxr4R3pO3kS6AqHoaOWH1ruZhM2bg65x
	 hrniDWPVYSIFwpBeO/tYvDWGapMdwvK0tnqtP5j9AZpi8zrUWuUcMGxRxdxLcQXhqf
	 NxLhqNon59Yomgl0EEWZ/FsEEYiIh+O44nEJF254=
Date: Tue, 20 May 2025 18:09:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin Forbes <jmforbes@linuxtx.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+6af973a3b8dfd2faefdc@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>, Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 162/197] loop: Add sanity check for read/write_iter
Message-ID: <2025052023-rework-dean-1017@gregkh>
References: <20250512172044.326436266@linuxfoundation.org>
 <20250512172050.980575013@linuxfoundation.org>
 <CAFxkdAq+5ur__TPi6ZW9uoOBv037hgn1d_9906cBeXWE=X3Sgw@mail.gmail.com>
 <2025052059-unsteady-octagon-9321@gregkh>
 <e05dbb79-9769-4825-aa33-1ed82e9bff69@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e05dbb79-9769-4825-aa33-1ed82e9bff69@kernel.dk>

On Tue, May 20, 2025 at 09:22:16AM -0600, Jens Axboe wrote:
> On 5/19/25 10:56 PM, Greg Kroah-Hartman wrote:
> > On Mon, May 19, 2025 at 06:19:26PM -0600, Justin Forbes wrote:
> >> On Mon, May 12, 2025 at 11:51 AM Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >>>
> >>> 6.14-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Lizhi Xu <lizhi.xu@windriver.com>
> >>>
> >>> [ Upstream commit f5c84eff634ba003326aa034c414e2a9dcb7c6a7 ]
> >>>
> >>> Some file systems do not support read_iter/write_iter, such as selinuxfs
> >>> in this issue.
> >>> So before calling them, first confirm that the interface is supported and
> >>> then call it.
> >>>
> >>> It is releavant in that vfs_iter_read/write have the check, and removal
> >>> of their used caused szybot to be able to hit this issue.
> >>>
> >>> Fixes: f2fed441c69b ("loop: stop using vfs_iter__{read,write} for buffered I/O")
> >>> Reported-by: syzbot+6af973a3b8dfd2faefdc@syzkaller.appspotmail.com
> >>> Closes: https://syzkaller.appspot.com/bug?extid=6af973a3b8dfd2faefdc
> >>> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> >>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>> Link: https://lore.kernel.org/r/20250428143626.3318717-1-lizhi.xu@windriver.com
> >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>>  drivers/block/loop.c | 23 +++++++++++++++++++++++
> >>>  1 file changed, 23 insertions(+)
> >>
> >> We have had an issue failing to set up loop devices with CI and Linus'
> >> tree since rc6, and once this patch hit stable it proved to be the
> >> culprit.  If I revert this patch, things work as they should. The
> >> problem we are seeing is "
> >>
> >> More information can be found in:
> >> https://github.com/coreos/fedora-coreos-tracker/issues/1948
> >> and
> >> https://openqa.fedoraproject.org/tests/3438220#step/_boot_to_anaconda/5
> > 
> > Sorry to hear that, please work with the developers to get this resolved
> > in Linus's tree and then we will be glad to apply the needed fix from
> > there.
> 
> Should be sorted and land before 6.15:
> 
> https://git.kernel.dk/cgit/linux/commit/?h=block-6.15&id=355341e4359b2d5edf0ed5e117f7e9e7a0a5dac0

Great, thanks!
