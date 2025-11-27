Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7233436C;
	Thu, 27 Nov 2025 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255589; cv=none; b=m+E6YzFjhQn6XkwFNQ/147JjgxCUKEHdx5BQHSjksa5tnPPY7vqpvs+G5DPgcykGnYDc49Ws9Ygongo3XIBqiruQqGOallSB/BAwCFk9m7qRWTvqZhB7MO6eiqnxE6KXVxb6abv/rZhN2h5u+mCCDP3svUUZvqmcu0MD5yucS7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255589; c=relaxed/simple;
	bh=+dWC88R2xvwlcahslfoydyqfb0FGHYRnlFAixExTWnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI++cYfYiN7wYqxwpvJJw8qZpnL7MqpCSfhNNAS2MECG7giLqthoWTaGoEhOyKEKNsuBqVw3eOwBHJzPiw5gLTXHE+H+fRAgQqg9lE9JFQbnxoniXZjiR3iujuG/8itswuWf/3TUqGHbyJgFZEB984+B6xnGjJqbcRQ+S9fLuIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMv7nmGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMv7nmGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011BFC4CEF8;
	Thu, 27 Nov 2025 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255589;
	bh=+dWC88R2xvwlcahslfoydyqfb0FGHYRnlFAixExTWnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMv7nmGBZUsvjkcGhXspBK94Ky+6pcT4hqo25LUJQ3p1X+VOZRTaokPspsYXnYN25
	 JxICbOHWTXeoCiXdqOLGdfrPRG0DAn9D2l94Qg3150a0Kd3RWO4siqCMVurdu/CbxR
	 6vy+8i/OaajzYVlsIlYFi8mCnpT3/gm9xK2D/MUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Andrea Righi <arighi@nvidia.com>,
	Vishal Chourasia <vishalc@linux.ibm.com>,
	Tejun Heo <tj@kernel.org>,
	Samir Mulani <samir@linux.ibm.com>
Subject: [PATCH 6.17 045/175] sched_ext: Fix scx_enable() crash on helper kthread creation failure
Date: Thu, 27 Nov 2025 15:44:58 +0100
Message-ID: <20251127144044.610943535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

commit 7b6216baae751369195fa3c83d434d23bcda406a upstream.

A crash was observed when the sched_ext selftests runner was
terminated with Ctrl+\ while test 15 was running:

NIP [c00000000028fa58] scx_enable.constprop.0+0x358/0x12b0
LR [c00000000028fa2c] scx_enable.constprop.0+0x32c/0x12b0
Call Trace:
scx_enable.constprop.0+0x32c/0x12b0 (unreliable)
bpf_struct_ops_link_create+0x18c/0x22c
__sys_bpf+0x23f8/0x3044
sys_bpf+0x2c/0x6c
system_call_exception+0x124/0x320
system_call_vectored_common+0x15c/0x2ec

kthread_run_worker() returns an ERR_PTR() on failure rather than NULL,
but the current code in scx_alloc_and_add_sched() only checks for a NULL
helper. Incase of failure on SIGQUIT, the error is not handled in
scx_alloc_and_add_sched() and scx_enable() ends up dereferencing an
error pointer.

Error handling is fixed in scx_alloc_and_add_sched() to propagate
PTR_ERR() into ret, so that scx_enable() jumps to the existing error
path, avoiding random dereference on failure.

Fixes: bff3b5aec1b7 ("sched_ext: Move disable machinery into scx_sched")
Cc: stable@vger.kernel.org # v6.16+
Reported-and-tested-by: Samir Mulani <samir@linux.ibm.com>
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Vishal Chourasia <vishalc@linux.ibm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4446,8 +4446,11 @@ static struct scx_sched *scx_alloc_and_a
 		goto err_free_gdsqs;
 
 	sch->helper = kthread_run_worker(0, "sched_ext_helper");
-	if (!sch->helper)
+	if (IS_ERR(sch->helper)) {
+		ret = PTR_ERR(sch->helper);
 		goto err_free_pcpu;
+	}
+
 	sched_set_fifo(sch->helper->task);
 
 	atomic_set(&sch->exit_kind, SCX_EXIT_NONE);


