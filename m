Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9398238BD3
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 07:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978D1C433C8;
	Tue, 19 Sep 2023 07:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695109946;
	bh=njHjTnd9YJvAgThnzsTTDZkzqNUJIPmiGtcggS0SZnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NkuASuenxh/TMElcg5CGQDucAGBtOl+j+LBR1qqyiTbun4RCf5z0R8G5mE8ggLB9x
	 h66Eoo1VMZiNQGxBUlkcLoxI/kQQ3yA6ESHNK5khjw/sJqWgszYlWgXJeaNZe94WSE
	 NderuRDBRQFT1cvmcltgQl9Ijy0drvHoDxLNmz9k=
Date: Tue, 19 Sep 2023 09:52:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
Message-ID: <2023091958-aware-whomever-059c@gregkh>
References: <20230917191113.831992765@linuxfoundation.org>
 <d51e5236-54b5-40fd-86b8-c19a16f56904@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d51e5236-54b5-40fd-86b8-c19a16f56904@roeck-us.net>

On Mon, Sep 18, 2023 at 11:40:36AM -0700, Guenter Roeck wrote:
> On Sun, Sep 17, 2023 at 09:07:07PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.132 release.
> > There are 511 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> > Anything received after that time might be too late.
> > 
> 
> My tests say
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 509 pass: 509 fail: 0
> 
> However, trying to build with clang (as done by ChromeOS) does report
> 
> fs/ksmbd/smb2pdu.c:6256:6: error: variable 'fp' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>         if (work->next_smb2_rcv_hdr_off) {
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> fs/ksmbd/smb2pdu.c:6367:21: note: uninitialized use occurs here
>         ksmbd_fd_put(work, fp);
>                            ^~
> fs/ksmbd/smb2pdu.c:6256:2: note: remove the 'if' if its condition is always false
>         if (work->next_smb2_rcv_hdr_off) {
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> fs/ksmbd/smb2pdu.c:6248:23: note: initialize the variable 'fp' to silence this warning
>         struct ksmbd_file *fp;
>                              ^
>                               = NULL
> 
> I guess I should try to add clang build tests.
> 
> Anyway, smb2_write() already initializes fp with NULL, presumably to handle a
> similar problem, so maybe doing the same for the read function would be the
> easiest solution. Note that the initialization was added upstream with commit
> 2fd5dcb1c8ef9 ("ksmbd: smbd: fix missing client's memory region invalidation").

Thanks for the report, I'll go fix this up in the commit that causes the
build warning.

greg k-h
