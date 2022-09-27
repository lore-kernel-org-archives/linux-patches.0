Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D680C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:51:57 +0000 (UTC)
Received: from localhost (unknown [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 3B4CC41203;
	Tue, 27 Sep 2022 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
	in-reply-to:content-disposition:content-type:content-type
	:mime-version:references:message-id:subject:subject:from:from
	:date:date:received:received:received:received; s=mta-01; t=
	1664286714; x=1666101115; bh=djkTMrw3NuDNUlcbgKWdUAMdOE33vBB/qXd
	2X5QY5YE=; b=iMmU13TmtIETymKDE54w7K8dAQmy2j5wKzhW8LlTZCXsKIT0c+p
	5yvIgsyLroZOUqfZEqEI1yaxHw8Bd3gIAiGssPBeZ54agqJvg4sBBrItDOdGOLmL
	+9Z8AISJyaqRsyMLv2uWyDd5+z7ve944JY2yce7ksuElvPdY0hn3K0KY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
	by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KZtp7uwSd8tN; Tue, 27 Sep 2022 16:51:54 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS id A558C40355;
	Tue, 27 Sep 2022 16:51:53 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 27 Sep 2022 16:51:53 +0300
Received: from yadro.com (10.199.23.254) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 27 Sep
 2022 16:51:52 +0300
Date: Tue, 27 Sep 2022 16:51:50 +0300
From: Konstantin Shelekhin <k.shelekhin@yadro.com>
To: Miguel Ojeda <ojeda@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <rust-for-linux@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<patches@lists.linux.dev>, Jarkko Sakkinen <jarkko@kernel.org>, Alex Gaynor
	<alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Gary Guo
	<gary@garyguo.net>, Matthew Bakhtiari <dev@mtbk.me>, Boqun Feng
	<boqun.feng@gmail.com>, =?iso-8859-1?Q?Bj=F6rn?= Roy Baron
	<bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
Message-ID: <YzL/9mlOHemaey2n@yadro.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-9-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-9-ojeda@kernel.org>
X-Originating-IP: [10.199.23.254]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

On Tue, Sep 27, 2022 at 03:14:39PM +0200, Miguel Ojeda wrote:
[...]
> +    /// Tries to append an element to the back of a collection.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// let mut vec = vec![1, 2];
> +    /// vec.try_push(3).unwrap();
> +    /// assert_eq!(vec, [1, 2, 3]);
> +    /// ```
> +    #[inline]
> +    #[stable(feature = "kernel", since = "1.0.0")]
> +    pub fn try_push(&mut self, value: T) -> Result<(), TryReserveError> {
> +        if self.len == self.buf.capacity() {
> +            self.buf.try_reserve_for_push(self.len)?;
> +        }
> +        unsafe {
> +            let end = self.as_mut_ptr().add(self.len);
> +            ptr::write(end, value);
> +            self.len += 1;
> +        }
> +        Ok(())
> +    }
[...]

Not being able to pass GFP flags here kinda limits the scope of Rust in
kernel. I think that it must be supported in the final version that gets
in.
