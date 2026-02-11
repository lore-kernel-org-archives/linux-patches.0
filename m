Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D8630FC1C;
	Wed, 11 Feb 2026 11:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770809843; cv=none; b=q6Sz7CR9xRpJjTEBMZ0dLdEQOsy/BC8PnX3NM/QYemwBhnOA65ufaDJLeTLHJBC/cdSwJmRRIOteJqFuEi/v+UZoGALueTxKVrLDg9PNYWUFFO6l1fcWtYnkic41fM/CzIgkUcbNbeW2DT9RoDIU71AnwQ7ixauME8fmspWhCYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770809843; c=relaxed/simple;
	bh=B8qCfDH8IucAVQlQxF0PqgeDGjyVUTzYQUcKocAx/aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gn7PXhziH+hQR4t6TtBVM+K94nCnJLzY+xljGjVFRYHKfRsg+5Wqlh0z1BYzkAu8BI5/nNeLiR5BR7cLoka5qiNEZRyvvmKZwQQ4fmO+x5kkFnvYUaH3f2zmqUWFeaT/f4TLSYrsRDIfs+K9h/LPVTxVJ0yADix2FkWn9Shp0X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id+sTax7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id+sTax7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34CBC4CEF7;
	Wed, 11 Feb 2026 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770809843;
	bh=B8qCfDH8IucAVQlQxF0PqgeDGjyVUTzYQUcKocAx/aY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=id+sTax7e3H74WDbUVECGY71eYZspzt5wSg9mVe91rf8JIWEiuZmtb8Y2+q/2N7Pv
	 F8qwogKUJiruAz8+SNBlspfd61Bg5EwUfvg2g0LWVB+SpLnQENyr0I+C1o9pJE+aO/
	 4EJpaqZKNioqwBk/NPBDwJ5yoxgl75brdfzMSf6I=
Date: Wed, 11 Feb 2026 12:37:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Korsnes <johan.korsnes@remarkable.no>
Cc: Stefano Garzarella <sgarzare@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 094/169] vsock/test: fix seqpacket message bounds
 test
Message-ID: <2026021103-gusto-karaoke-6c60@gregkh>
References: <20260128145334.006287341@linuxfoundation.org>
 <20260128145337.388867288@linuxfoundation.org>
 <61627e8a-6998-4138-a174-d7fd257db93e@remarkable.no>
 <aYw9N_Ido_FZzblw@sgarzare-redhat>
 <cc9bcfe1-4667-4a33-b370-1f3912f0adca@remarkable.no>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc9bcfe1-4667-4a33-b370-1f3912f0adca@remarkable.no>

On Wed, Feb 11, 2026 at 09:58:08AM +0100, Johan Korsnes wrote:
> On 11/02/2026 09:30, Stefano Garzarella wrote:
> > On Wed, Feb 11, 2026 at 08:50:11AM +0100, Johan Korsnes wrote:
> >> On 28/01/2026 16:22, Greg Kroah-Hartman wrote:
> >>> 6.12-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Stefano Garzarella <sgarzare@redhat.com>
> >>>
> >>> [ Upstream commit 0a98de80136968bab7db37b16282b37f044694d3 ]
> >>>
> >>> The test requires the sender (client) to send all messages before waking
> >>> up the receiver (server).
> >>> Since virtio-vsock had a bug and did not respect the size of the TX
> >>> buffer, this test worked, but now that we are going to fix the bug, the
> >>> test hangs because the sender would fill the TX buffer before waking up
> >>> the receiver.
> >>>
> >>> Set the buffer size in the sender (client) as well, as we already do for
> >>> the receiver (server).
> >>>
> >>> Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
> >>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >>> Link: https://patch.msgid.link/20260121093628.9941-3-sgarzare@redhat.com
> >>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> >>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>>  tools/testing/vsock/vsock_test.c | 11 +++++++++++
> >>>  1 file changed, 11 insertions(+)
> >>>
> >>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> >>> index 0c22ff7a8de2a..79ef11c0ab14f 100644
> >>> --- a/tools/testing/vsock/vsock_test.c
> >>> +++ b/tools/testing/vsock/vsock_test.c
> >>> @@ -359,6 +359,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> >>>
> >>>  static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> >>>  {
> >>> +	unsigned long long sock_buf_size;
> >>>  	unsigned long curr_hash;
> >>>  	size_t max_msg_size;
> >>>  	int page_size;
> >>> @@ -371,6 +372,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> >>>  		exit(EXIT_FAILURE);
> >>>  	}
> >>>
> >>> +	sock_buf_size = SOCK_BUF_SIZE;
> >>> +
> >>> +	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
> >>> +			     sock_buf_size,
> >>> +			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
> >>
> >> Hi Greg,
> >>
> >> This patch causes build failure as the setsockopt_ull_check() function
> >> does not seem to be defined in the 6.12 tree.
> > 
> > I guess just when you build vsock_test, right?
> >
> 
> Correct. I should have specified that.
> 
> > BTW to fix that we should backport commit 86814d8ffd55 ("vsock/test: 
> > verify socket options after setting them").
> > 
> > I tried to cherry-pick it on current linux-6.12.y and apply clean.
> > 
> 
> I can confirm it builds fine after cherry-picking that commit.
> 
> Kind regards,
> Johan
> 
> > Greg, let me know if I should send a proper patch for 6.12.

Great!  Can you send a proper patch for 6.12.y for this?

thanks,

greg k-h
