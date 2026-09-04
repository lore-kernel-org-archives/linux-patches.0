Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FBD4477E3
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515530; cv=none; b=toS73n1LaCWBRypuuDrkuZWZDypv69s6iU4FpknWlqT1o+2+X4AvuViZqFbn5Dq6uuQqUct4lysVybDbxWVMA1Sha8pXfjsOT42jSDXh0Pc2p3q1KMf5fpeXshNyiEi1uex0VBYdo6xWR2JTrEnomAeYOMIcLhofPT9sTLXdxbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515530; c=relaxed/simple;
	bh=GBgZoGAzOYlhiYEFLHygWw5xhvEEb9W0OPkjhNDIOgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajWZ13CSB3gc4XH/2L5vuLcLXpTfLvhPOeuqFVZFrzNmhM1Y9YD2nTtLbmXmQPthfF3IQYPSmpo0pSzIPuEyS0Smyv2/lIL9TN0HZufi0bbX0K84wNNT5xCdTD/SRtqkXd9fA1vMC10BtBNNDlXQ5HQBgtTvQUN2SB5p+4aRqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EdTgfYW6; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EdTgfYW6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788515519; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=19HkBx4CJhIGhDPL9cr/SS1aulypWTvYI+SiigUORts=;
	b=EdTgfYW686Q22UyHtu2lb745KYlYMZ9PBZfBfQSM4nwjDKIMn5J8n8dXHYgWl2ZXaovvPATGIZ/cWFXoTzcDSi7GfQnMFhTh9pwFqZYYqIgmE+qi4svMc3XGqKIaWM3qn1z1CboCO8sIxC3/5b0zo+DyGof35pXIHqYe00ukWNI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XAIS-aS_1788515518;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0XAIS-aS_1788515518 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 17:51:58 +0800
Date: Fri, 4 Sep 2026 17:51:58 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 5.10 28/43] xfrm: espintcp: fix UAF during close
Message-ID: <20260904095158.GA83164@j66a10360.sqa.eu95>
References: <20260831133358.571886287@linuxfoundation.org>
 <20260831133359.883892832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260831133359.883892832@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Aug 31, 2026 at 03:35:36PM +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sabrina Dubroca <sd@queasysnail.net>
> 
> commit deb232e884877bf10b4ce2580909eedec986c284 upstream.
> 
> ZDI reported and analyzed a race condition during close for espintcp
> sockets:
> 
>     espintcp_close() frees emsg->skb via kfree_skb() without holding
>     any socket lock. Concurrently, the xfrm_trans_reinject work queue
>     invokes esp_output_tcp_finish() -> espintcp_push_skb() ->
>     espintcp_push_msgs() -> skb_send_sock_locked(), which reads the
>     same skb as a data source.
> 
> Fix this by adding a synchronize_rcu() call after resetting sk_prot,
> since esp_output_tcp_finish() runs under RCU and won't use a socket
> with sk_prot == &tcp_prot.  Simply taking the socket lock in
> espintcp_close() could lead to leaks, if esp_output_tcp_finish()
> re-adds an skb in the slot we just freed. After this, the existing
> barrier() is no longer needed.
> 
> Cc: stable@vger.kernel.org
> Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> Reported-by: zdi-disclosures@trendmicro.com
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/xfrm/espintcp.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/net/xfrm/espintcp.c
> +++ b/net/xfrm/espintcp.c
> @@ -506,7 +506,8 @@ static void espintcp_close(struct sock *
>  	strp_stop(&ctx->strp);
>  
>  	sk->sk_prot = &tcp_prot;
> -	barrier();
> +
> +	synchronize_rcu();


This backport depends on upstream
028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"),
which is not in 5.15.y. Without it, esp_find_tcp_sk() still
returns the cached x->encap_sk based only on sk_state == TCP_ESTABLISHED
(no tcp_is_ulp_esp() check), so new readers keep racing with
espintcp_close()'s kfree_skb on ctx->partial.emsg->skb — the UAF issue
this patch is supposed to fix.

Reproduced on 5.15.219+ (with this patch applied), KASAN trimmed:

  BUG: KASAN: use-after-free in __skb_send_sock+0x6cf/0x7b0
  Workqueue: events xfrm_trans_reinject

  Reader:
    __skb_send_sock <- espintcp_push_msgs <- espintcp_push_skb <-
    esp_output_tcp_encap_cb <- xfrm_trans_reinject

  Free:
    espintcp_close <- inet_release <- __sock_release <- sock_close <-
    __fput

  Object: skbuff_head_cache (size 224), i.e. struct sk_buff.

Provenance: the static analysis (missing-prerequisite chain, code-path
derivation) and the KASAN reproducer above were both produced by our
internal AI-assisted backport triage pipeline. I have personally
reviewed the reasoning line-by-line against the 5.15.y source, re-ran
the reproducer end-to-end, and confirm the finding — sending it upstream
on that basis.

Thanks,
D. Wythe

>  
>  	cancel_work_sync(&ctx->work);
>  	strp_done(&ctx->strp);
> 
> 
