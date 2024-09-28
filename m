Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F1D5FEE6;
	Sat, 28 Sep 2024 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727546126; cv=none; b=nWGwJrtFZZyKgz/fHrxu8M63JDeokBPcaQlQRRo8dL4R7kR+moMYEDXpsARbFdPH2bMjwNm4yrWeLkcfqq5+k9SPTLobvLX3vqWks8+21wxSj43KcyoH1YSfd8IPbI+MzZa3B2WVRrkTAP33QFdy+ZRUGtsY+VeAw6dMtNzIWnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727546126; c=relaxed/simple;
	bh=P5nNqmfCrlk779OH11I9Mg/PvES3kL98o1evTH7Iqnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQd2hnoP4az9Y0Xh+OTqFNJdUZ161Es9awV7/rfDlWZNaaB8jLsSfBdBrI7h8a/Q706GlmEG4Ko5rPHKOTCVBeYfZxhe+ZoXo4Vkq4zwl7NycjqtDiUO9nrcLW+VwKax7lXCi0kkR31/yQy5uI+uMh/BhXEgWXle/HodyQArE0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LaDf3qJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LaDf3qJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8B1C4CEC3;
	Sat, 28 Sep 2024 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727546126;
	bh=P5nNqmfCrlk779OH11I9Mg/PvES3kL98o1evTH7Iqnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LaDf3qJZ7whPQSrM692hCpZJjRtnxSv9G1JND1aMjP1HzlXLmnu8fjcNIg0OgknsW
	 hsouFIAjNefUtk8OyIk2qDNq7lNGS8Vj+LztwNTe7FiWKQJTKnkTOtAv5e4Az31y0e
	 oROxZV2CZt3wQAtXoXhpGGQx9ouA/mAwpIBTZXaMQtAzeQxDG5V47qY5JsZauayzxa
	 XxaXaJnEmsVbIbTJM2aQy+fYQqJKdX3unyQpkZG3oBVvv5eVZg9CKe/3cujrX9Mipe
	 Rav42qc5+W36IHfiguFC6xJxcE5eeosCj0aTDJCMRxawgYOVExoQfAHgQENwxigNUn
	 fsUQ+HumnEXTQ==
Date: Sat, 28 Sep 2024 10:55:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: Re: [PATCH 5.10 247/352] mptcp: fix duplicate data handling
Message-ID: <20240928175524.GA1713144@thelio-3990X>
References: <20240815131919.196120297@linuxfoundation.org>
 <20240815131928.985734907@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815131928.985734907@linuxfoundation.org>

Hi all,

On Thu, Aug 15, 2024 at 03:25:13PM +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Paolo Abeni <pabeni@redhat.com>
> 
> commit 68cc924729ffcfe90d0383177192030a9aeb2ee4 upstream.
> 
> When a subflow receives and discards duplicate data, the mptcp
> stack assumes that the consumed offset inside the current skb is
> zero.
> 
> With multiple subflows receiving data simultaneously such assertion
> does not held true. As a result the subflow-level copied_seq will
> be incorrectly increased and later on the same subflow will observe
> a bad mapping, leading to subflow reset.
> 
> Address the issue taking into account the skb consumed offset in
> mptcp_subflow_discard_data().
> 
> Fixes: 04e4cd4f7ca4 ("mptcp: cleanup mptcp_subflow_discard_data()")
> Cc: stable@vger.kernel.org
> Link: https://github.com/multipath-tcp/mptcp_net-next/issues/501
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Mat Martineau <martineau@kernel.org>
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/mptcp/subflow.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -863,14 +863,22 @@ static void mptcp_subflow_discard_data(s
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
>  	bool fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
> -	u32 incr;
> +	struct tcp_sock *tp = tcp_sk(ssk);
> +	u32 offset, incr, avail_len;
>  
> -	incr = limit >= skb->len ? skb->len + fin : limit;
> +	offset = tp->copied_seq - TCP_SKB_CB(skb)->seq;
> +	if (WARN_ON_ONCE(offset > skb->len))
> +		goto out;
>  
> -	pr_debug("discarding=%d len=%d seq=%d", incr, skb->len,
> -		 subflow->map_subflow_seq);
> +	avail_len = skb->len - offset;
> +	incr = limit >= avail_len ? avail_len + fin : limit;
> +
> +	pr_debug("discarding=%d len=%d offset=%d seq=%d", incr, skb->len,
> +		 offset, subflow->map_subflow_seq);
>  	MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DUPDATA);
>  	tcp_sk(ssk)->copied_seq += incr;
> +
> +out:
>  	if (!before(tcp_sk(ssk)->copied_seq, TCP_SKB_CB(skb)->end_seq))
>  		sk_eat_skb(ssk, skb);
>  	if (mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len)
> 
> 

This change in 5.10 appears to introduce an instance of
-Wsometimes-uninitialized because 5.10 does not include
commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling"), which
removed the use of incr in the error path added by this change:

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 LLVM_IAS=1 mrproper allmodconfig net/mptcp/subflow.o
  net/mptcp/subflow.c:877:6: warning: variable 'incr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    877 |         if (WARN_ON_ONCE(offset > skb->len))
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  include/asm-generic/bug.h:101:33: note: expanded from macro 'WARN_ON_ONCE'
    101 | #define WARN_ON_ONCE(condition) ({                              \
        |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    102 |         int __ret_warn_on = !!(condition);                      \
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    103 |         if (unlikely(__ret_warn_on))                            \
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    104 |                 __WARN_FLAGS(BUGFLAG_ONCE |                     \
        |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    105 |                              BUGFLAG_TAINT(TAINT_WARN));        \
        |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    106 |         unlikely(__ret_warn_on);                                \
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    107 | })
        | ~~
  net/mptcp/subflow.c:893:6: note: uninitialized use occurs here
    893 |         if (incr)
        |             ^~~~
  net/mptcp/subflow.c:877:2: note: remove the 'if' if its condition is always false
    877 |         if (WARN_ON_ONCE(offset > skb->len))
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    878 |                 goto out;
        |                 ~~~~~~~~
  net/mptcp/subflow.c:874:18: note: initialize the variable 'incr' to silence this warning
    874 |         u32 offset, incr, avail_len;
        |                         ^
        |                          = 0
  1 warning generated.

That change does not really look suitable for stable (unless folks feel
otherwise), so maybe a stable only patch to adddress this is in order?

Sorry for the delay in reporting this, I guess I do not build older
stable releases as often as I should.

Cheers,
Nathan
