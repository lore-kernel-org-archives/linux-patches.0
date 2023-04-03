Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527D83205
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 20:53:11 +0000 (UTC)
Message-ID: <57df03d5-0a84-1667-35af-50acf89e7509@0.smtp.remotehost.it>
Date: Mon, 3 Apr 2023 22:47:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.1 022/181] blk-mq: fix "bad unlock balance detected" on
 q->srcu in __blk_mq_run_dispatch_ops
Content-Language: en-US, de-DE, lb-LU, fr-FR
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marco Patalano <mpatalan@redhat.com>,
 Chris Leech <cleech@redhat.com>, Ming Lei <ming.lei@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
References: <20230403140415.090615502@linuxfoundation.org>
 <20230403140415.869808922@linuxfoundation.org>
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20230403140415.869808922@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2023-04-03 16:07] Greg Kroah-Hartman:
> From: Chris Leech <cleech@redhat.com>
> 
> [ Upstream commit 00e885efcfbb8712d3e1bfc1ae30639c15ca1d3b ]
> 
> The 'q' parameter of the macro __blk_mq_run_dispatch_ops may not be one
> local variable, such as, it is rq->q, then request queue pointed by
> this variable could be changed to another queue in case of
> BLK_MQ_F_TAG_QUEUE_SHARED after 'dispatch_ops' returns, then
> 'bad unlock balance' is triggered.
> 
> Fixes the issue by adding one local variable for doing srcu lock/unlock.
> 
> Fixes: 2a904d00855f ("blk-mq: remove hctx_lock and hctx_unlock")
> Cc: Marco Patalano <mpatalan@redhat.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Link: https://lore.kernel.org/r/20230310010913.1014789-1-ming.lei@redhat.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   block/blk-mq.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index ef59fee62780d..a7482d2cc82e7 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -378,12 +378,13 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>   #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
>   do {								\
>   	if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {		\
> +		struct blk_mq_tag_set *__tag_set = (q)->tag_set; \
>   		int srcu_idx;					\
>   								\
>   		might_sleep_if(check_sleep);			\
> -		srcu_idx = srcu_read_lock((q)->tag_set->srcu);	\
> +		srcu_idx = srcu_read_lock(__tag_set->srcu);	\
>   		(dispatch_ops);					\
> -		srcu_read_unlock((q)->tag_set->srcu, srcu_idx);	\
> +		srcu_read_unlock(__tag_set->srcu, srcu_idx);	\
>   	} else {						\
>   		rcu_read_lock();				\
>   		(dispatch_ops);					\


On systems with their (btrfs) root filesystem residing on an LVM volume, 
this patch is reproducibly causing a complete freeze during shutdowns 
and reboots.


Regards
Pascal
