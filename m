Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD0B1DFD1;
	Sun,  1 Sep 2024 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209700; cv=none; b=UzKCoEkfiTRbTLt0EN5WguMFW9OCGjk+XuGmbZAG/h9UmIMqgQ4Fjej+ND0oq70AgmZtSqXIJwrO9GNaO03eDzCopfxE/7ksz1X/vDH4TdAUhxGKR7pPbLI6AXXM1TA7JmK1XKJFWf4OV44/sqyqmYyidokT5JJcyN3QZZTakCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209700; c=relaxed/simple;
	bh=70yC3c4VZDcm+AqfgbwlJ9bXOdhyNA2R7SV1JY6KSGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an5b09dsou/hlyrgwJB2H05A80hYTkIqSm/jljw1/oBLRVlJ64JH9LsPSXYxCOSNQ7YhreSIdO2VFIlNZ2sWZoQvVTHzPwDlQEYnniXSf46DsTOY34S52zvrHxjjWw+xbfKvvAQHDOODtdixbUYdkjtjSqGIURLbYe+41trAm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6OM9UG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6OM9UG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1D6C4CEC3;
	Sun,  1 Sep 2024 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209699;
	bh=70yC3c4VZDcm+AqfgbwlJ9bXOdhyNA2R7SV1JY6KSGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6OM9UG53yT4zcxqjl6kIPDX3e+P0oLLmjhDDDEjtezmvSRg7JBH76UiF/DsOdcgj
	 nZ/bq+eQHCvGVhN1ckMvlrRksx3yiuc7FSQIYaABjBY3m5lJdJTwtIU16Cx0CHMIuE
	 auuH4tQ2XpB5Xs+t9tK6eMqmpoy7x77MYh5wa+J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hughdan Liu <hughliu@amazon.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 117/151] nfsd: Dont call freezable_schedule_timeout() after each successful page allocation in svc_alloc_arg().
Date: Sun,  1 Sep 2024 18:17:57 +0200
Message-ID: <20240901160818.510633740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

When commit 390390240145 ("nfsd: don't allow nfsd threads to be
signalled.") is backported to 5.10, it was adjusted considering commit
3feac2b55293 ("sunrpc: exclude from freezer when waiting for requests:").

However, 3feac2b55293 is based on commit f6e70aab9dfe ("SUNRPC: refresh
rq_pages using a bulk page allocator"), which converted page-by-page
allocation to a batch allocation, so schedule_timeout() is placed
un-nested.

As a result, the backported commit 7229200f6866 ("nfsd: don't allow nfsd
threads to be signalled.") placed freezable_schedule_timeout() in the wrong
place.

Now, freezable_schedule_timeout() is called after every successful page
allocation, and we see 30%+ performance regression on 5.10.220 in our
test suite.

Let's move it to the correct place so that freezable_schedule_timeout()
is called only when page allocation fails.

Fixes: 7229200f6866 ("nfsd: don't allow nfsd threads to be signalled.")
Reported-by: Hughdan Liu <hughliu@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc_xprt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -679,8 +679,8 @@ static int svc_alloc_arg(struct svc_rqst
 					set_current_state(TASK_RUNNING);
 					return -EINTR;
 				}
+				freezable_schedule_timeout(msecs_to_jiffies(500));
 			}
-			freezable_schedule_timeout(msecs_to_jiffies(500));
 			rqstp->rq_pages[i] = p;
 		}
 	rqstp->rq_page_end = &rqstp->rq_pages[i];


