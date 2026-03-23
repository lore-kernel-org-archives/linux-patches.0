Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8323CC9F2
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289753; cv=none; b=tbRU6T/TTBzFqcZ/asLp0tDLQpTXaSJxQR4eKly/OinuMbiL7hvsECLjxxJK1aYvI90lJ2gOssayvM7oY9NTrQd3NKLY2NVyFqB336t9LE5ZZwdLGDG9Gqs8PZYIi05uErAdwGTTeA4M/ebNJP3O3SXfdUa8WbAUskP0M3NJTL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289753; c=relaxed/simple;
	bh=ZbNwgKzJxYX/zMwWV8EO8YjnqlV6AIsbDklpeDd3IK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9UcOBeQjAMSPraIQ9cfsk/7OCVpQbTfqStDHSKjZKGHqpmfLn9yHZN0zl12K+qhF4JDKR1E8HO3/u5BHMwv0VtMqeIwk8byrAkjwnGGJCnN1nuJUxxMR/65RCAynNATWuR4BDRJhaBMpDqQwNWwOLrObzGiMJbsvWqTQUTzr70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NJTIH8za; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NJTIH8za"
Message-ID: <ef531334-b26f-43b1-863e-8f6c3fea0723@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774289746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ihCmhZcnN8v0P1Lw0vFhlpCVnAb8+HL30hkvGr682/0=;
	b=NJTIH8zaqWzBRhj8UGPOwk0DfGYsApj23yjO7RvJeDcHxUOfsT543iduFsJbPPmskaeJlD
	dV1dO7eJPmItyFZ0R1XozKiwI8wVwdVHnKag43VE8olHYXRdR6wAqL+bzsiJB9aqp3LRPZ
	W9zrmxU4lY4Wa9E2tRpdH4JMIwmB3ps=
Date: Mon, 23 Mar 2026 11:15:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 5.10 094/147] RDMA/rxe: Fix double free in
 rxe_srq_from_init
To: Ben Hutchings <ben@decadent.org.uk>, Sasha Levin <sashal@kernel.org>,
 patches@lists.linux.dev, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
 Leon Romanovsky <leon@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
 <20260228181736.1605592-94-sashal@kernel.org>
 <f7f34b5cf1ddd5a880e0ceba52670bb73f2d21e2.camel@decadent.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <f7f34b5cf1ddd5a880e0ceba52670bb73f2d21e2.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 3/23/26 5:37 AM, Ben Hutchings wrote:
> On Sat, 2026-02-28 at 13:16 -0500, Sasha Levin wrote:
>> From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
>>
>> [ Upstream commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 ]
>>
>> In rxe_srq_from_init(), the queue pointer 'q' is assigned to
>> 'srq->rq.queue' before copying the SRQ number to user space.
>> If copy_to_user() fails, the function calls rxe_queue_cleanup()
>> to free the queue, but leaves the now-invalid pointer in
>> 'srq->rq.queue'.
> [...]
>> Fix this by moving 'srq->rq.queue = q' after copy_to_user.
> But this backport to 5.10 only added an assignment to srq->rq.queue and
> did not remove the existing assignment (on line 101), so the bug is not
> fixed here.
  74 int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
  75                       struct ib_srq_init_attr *init, struct 
ib_udata *udata,
  76                       struct rxe_create_srq_resp __user *uresp)
  77 {

...

100

101         srq->rq.queue = q;       <----This line still exists.
102
103         err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, udata, 
q->buf,
104                            q->buf_size, &q->ip);
105         if (err) {
106                 vfree(q->buf);
107                 kfree(q);
108                 return err;
109         }
110
111         if (uresp) {
112                 if (copy_to_user(&uresp->srq_num, &srq->srq_num,
113                                  sizeof(uresp->srq_num))) {
114                         rxe_queue_cleanup(q);
115                         return -EFAULT;
116                 }
117         }

..

122         return 0;

123 }

Thanks a lot. I think this problem that ("RDMA/rxe: Fix double free in 
rxe_srq_from_init") mentioned still exists.

In Linux 5.10.252, maybe the following can fix this problem.

"
diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c 
b/drivers/infiniband/sw/rxe/rxe_srq.c
index 9d9baca26949..65bad1ec170e 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -98,8 +98,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct 
rxe_srq *srq,
                 return -ENOMEM;
         }

-       srq->rq.queue = q;
-
         err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, udata, q->buf,
                            q->buf_size, &q->ip);
         if (err) {
"

Thanks. Ben.

Zhu Yanjun

>
> Ben.
>
>> Fixes: aae0484e15f0 ("IB/rxe: avoid srq memory leak")
>> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
>> Link: https://patch.msgid.link/20260112015412.29458-1-jiashengjiangcool@gmail.com
>> Reviewed-by: Zhu Yanjun <yanjun.Zhu@linux.dev>
>> Signed-off-by: Leon Romanovsky <leon@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/infiniband/sw/rxe/rxe_srq.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
>> index 41b0d1e11bafd..9d9baca269499 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_srq.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_srq.c
>> @@ -116,6 +116,9 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
>>   		}
>>   	}
>>   
>> +	srq->rq.queue = q;
>> +	init->attr.max_wr = srq->rq.max_wr;
>> +
>>   	return 0;
>>   }
>>   
