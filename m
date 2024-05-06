Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE015381AA
	for <patches@lists.linux.dev>; Mon,  6 May 2024 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714959277; cv=none; b=WwRMPq2htl4icWAnVq8Or0sCZmxJ8TdJQMtIbZlzHGX1G0ccg7s7GV0rRP8V9J+LUinQGEpQ/+zxFupomJgNWTFFUjTYPxtjguoN42ZOkk3RihPNHxLUR6QxpwSt8UH/oAX7n3HK2dCIxTpE8AFmWmDgYrg8TNzbkMEPF6DDIKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714959277; c=relaxed/simple;
	bh=9p2EKmV6g8hE7RNWs3XlzZv1iNP4rOcjZ1lWs5BKz+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZBY1RDfhOm/rbeHzAjvWHe/OFP0LlFyYFYdDt4ycLzB/lg6bx6GYbPkY2BvXnFrN1WsniiVNIPT56bf8/hpCt6Elru8hZP0GRz2DX5Jn98MujYwZF2nN3hk+g0qAqpJQu58v1Brtm7Z0J8L/jd4dJ+TyFT8rU8Mrr+xmWEPCY9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VXkQC5gkpz1RC6f;
	Mon,  6 May 2024 09:31:15 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (unknown [7.185.36.106])
	by mail.maildlp.com (Postfix) with ESMTPS id 787C218007D;
	Mon,  6 May 2024 09:34:32 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 09:34:31 +0800
Message-ID: <4ebb4956-65ed-fb35-d3ff-b00be6322527@huawei.com>
Date: Mon, 6 May 2024 09:34:31 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 5.4 098/107] tcp: Clean up kernel listeners reqsk in
 inet_twsk_purge()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, syzbot <syzkaller@googlegroups.com>, Eric
 Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Jakub
 Kicinski <kuba@kernel.org>
References: <20240430103044.655968143@linuxfoundation.org>
 <20240430103047.550538724@linuxfoundation.org>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20240430103047.550538724@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)



On 2024/4/30 18:40, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> commit 740ea3c4a0b2e326b23d7cdf05472a0e92aa39bc upstream.
> 
> Eric Dumazet reported a use-after-free related to the per-netns ehash
> series. [0]
> 
> When we create a TCP socket from userspace, the socket always holds a
> refcnt of the netns.  This guarantees that a reqsk timer is always fired
> before netns dismantle.  Each reqsk has a refcnt of its listener, so the
> listener is not freed before the reqsk, and the net is not freed before
> the listener as well.
> 
> OTOH, when in-kernel users create a TCP socket, it might not hold a refcnt
> of its netns.  Thus, a reqsk timer can be fired after the netns dismantle
> and access freed per-netns ehash.
> 
> To avoid the use-after-free, we need to clean up TCP_NEW_SYN_RECV sockets
> in inet_twsk_purge() if the netns uses a per-netns ehash.
> 
> [0]: https://lore.kernel.org/netdev/CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com/
> 
> BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
> include/net/inet_hashtables.h:181 [inline]
> BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
> net/ipv4/inet_connection_sock.c:913
> Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301
> 
> CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
> 6.0.0-syzkaller-02757-gaf7d23f9d96a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 09/22/2022
> Call Trace:
> <IRQ>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:317 [inline]
> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
> tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
> reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
> inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
> inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
> reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
> call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> expire_timers kernel/time/timer.c:1519 [inline]
> __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
> __run_timers kernel/time/timer.c:1768 [inline]
> run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
> __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
> invoke_softirq kernel/softirq.c:445 [inline]
> __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
> </IRQ>
> 
> Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://lore.kernel.org/r/20221012145036.74960-1-kuniyu@amazon.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [shaozhengchao: resolved conflicts in 5.10]
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/ipv4/inet_timewait_sock.c |   15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -268,8 +268,21 @@ restart_rcu:
>   		rcu_read_lock();
>   restart:
>   		sk_nulls_for_each_rcu(sk, node, &head->chain) {
> -			if (sk->sk_state != TCP_TIME_WAIT)
> +			if (sk->sk_state != TCP_TIME_WAIT) {
> +				/* A kernel listener socket might not hold refcnt for net,
> +				 * so reqsk_timer_handler() could be fired after net is
> +				 * freed.  Userspace listener and reqsk never exist here.
> +				 */
> +				if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
> +					     hashinfo->pernet)) {

Hi Greg:
   I'm very very sorry, there's no pernet variable in the struct 
hashinfo. The pernet variable is introduced from v6.1-rc1. This patch
has a problem and cannot be merged.

Zhengchao Shao
> +					struct request_sock *req = inet_reqsk(sk);
> +
> +					inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
> +				}
> +
>   				continue;
> +			}
> +
>   			tw = inet_twsk(sk);
>   			if ((tw->tw_family != family) ||
>   				refcount_read(&twsk_net(tw)->count))
> 
> 
