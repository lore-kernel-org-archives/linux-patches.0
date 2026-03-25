Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3972359A8C;
	Wed, 25 Mar 2026 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432206; cv=none; b=Y+MYGipI/uZR9Zn0sGR1eYJm2Rxf9PLafRN4OdbaZ6U4rdvSHnK9EEVApZ6lN6sopRmkt/WwcsO53alFqYb2l/N0KOh76ilFWu8liT0Vw3SJHGzLoH7LyFZ7uhPc/TP4gmgWJgIWVjVzPjTbJIDjGbx7BprHZBvdEztZEaCKddA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432206; c=relaxed/simple;
	bh=Bf0PBw5Adw8enGJg9vZPnLPb1pWLLwp32Nna1aPLguc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSVbgngZPcSWyKm2gQ77jJ25Esh3nt68TfjkAiSVgeD2aG9Dfp0lpBhvXXHTXsduZEtEraPfdkL22XBpJCjC7y5i7wqODWxnkoz56DxCmoZDGZYIpakBSQuVE2j1n7OIgSKTz4L1HiE6YYtCjYpt64tXAbYFcNKsDAjhEqraq7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpYoACiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpYoACiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EBEC4CEF7;
	Wed, 25 Mar 2026 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774432206;
	bh=Bf0PBw5Adw8enGJg9vZPnLPb1pWLLwp32Nna1aPLguc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OpYoACiFwpZzD7hxqtfIslwJd5mby0S8GfHQLcnUOGVqnykROGMgCTUut5LCxMmvb
	 8hra4wguoV0cDs1AyXquxLsgH2FSGKmkOnYht1vgwg6eWsSbfCtvcyNYbn2eGVvUj8
	 Hb7L/v6CfwohnmwYXQNX9+xjojKFdf3MaGJ5Kja4=
Date: Wed, 25 Mar 2026 10:49:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Mark Brown <broonie@kernel.org>, Jan Kara <jack@suse.cz>,
	Francesco Dolcini <francesco@dolcini.it>,
	Brian Foster <bfoster@redhat.com>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Matthew Wilcox <willy@infradead.org>,
	Gou Hao <gouhao@uniontech.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>, Baokun Li <libaokun1@huawei.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <2026032535-casino-cable-e039@gregkh>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
 <d8080343-20cd-4a4a-b726-b9e3c6a5c5eb@sirena.org.uk>
 <20260325035931.GC61656@mac.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325035931.GC61656@mac.lan>

On Tue, Mar 24, 2026 at 10:59:31PM -0500, Theodore Tso wrote:
> On Tue, Mar 24, 2026 at 03:36:21PM +0000, Mark Brown wrote:
> > I have a bisect for an ext4 issue in v6.1 which comes out at:
> > 
> > # first bad commit: [29897d75d6491ffe23cdc9d96caba9282a20dfc3] ext4: convert bd_bitmap_page to bd_bitmap_folio
> > 
> > For an oops which looks very similar (but on arm64):
> 
> I can confirm this bisection; I was testing on x86_64, and using
> "kvm-xfstests -c ext4/4k generic/001" on a failure, it would crash
> before running the first test (in my test runner infrastructure when
> running syncfs on the results directory --- go figure).
> 
> Unfortunately, you can't just revert this commit because of merge
> conflicts.  In order to get a clean revert, you have to revert (or
> drop) three commits:
> 
> % git log -3
> commit b12a69d9770b58fb02d3b4f72abe5acd28aa7e76 (HEAD)
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Mar 24 23:46:15 2026 -0400
> 
>     Revert "ext4: convert bd_bitmap_page to bd_bitmap_folio"
> 
>     This reverts commit 29897d75d6491ffe23cdc9d96caba9282a20dfc3.
> 
> commit 9c95c376c79f47fe9ee8ce562249d3630a50ab12
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Mar 24 23:44:23 2026 -0400
> 
>     Revert "ext4: convert bd_buddy_page to bd_buddy_folio"
> 
>     This reverts commit fe80bba8f76f9f0995cdc64fc89b65173e1ae828.
> 
> commit 98f5de80114f6194af4d9fae572b73440efa67c2
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Mar 24 23:43:40 2026 -0400
> 
>     Revert "ext4: fix e4b bitmap inconsistency reports"
> 
>     This reverts commit cb45b6209aa53979b054bd026d938107d5a3031b.
> 
> I haven't had time to investigate this more closely, but I'm assuming
> the automated stable picker was trying to backport cb45b6209aa5
> ("ext4: fix e4b bitmap inconsistency reports"), and determined that
> the fe80bba8f76f ("ext4: convert bd_buddy_page to bd_buddy_folio") and
> 29897d75d649 ("ext4: convert bd_bitmap_page to bd_bitmap_folio") were
> prerequisite commits --- and while 29897d75d649 cherry picked
> correctly, either the git scrwed up the cherry pick, or there was some
> additional prerequisite commit needed, but wasn't caught by the "it
> patches cleanly, ship it!" algorithm.
> 
> I don't have time to investigate further, but Greg, if you could drop
> these three patches, that should address this issue.

All now dropped, thanks!

greg k-h
