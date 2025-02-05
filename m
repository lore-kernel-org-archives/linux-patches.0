Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E1B1519AA;
	Wed,  5 Feb 2025 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764592; cv=none; b=BNCSAJOPKaVKdP/GsZBhf9fWVR05+NnO49fqMNR3+R4Y8D4DHTEuBRjkdgeypip5LIUBGaG7rOkQemfAvw7wkbeqZcJRL4LrhFhtNZpozTIgPz9mkpOlbklVMm+sV124B4Lu4BZT0dvFJz8z1c9+tT9qK2pDAD4Q9Iw1o4x/HeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764592; c=relaxed/simple;
	bh=/mo+JzAeaLFCXX9BAGFyqJoYSibOF84kWE+a/BB/W2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNzAJWb1ui2+nvA9DcgdFkZftbBhD0eaivxozi1ukhsiKcHdlaZhcuhaHQPN00suLwgtegXOcjVmSOr3vB81J8oA1vkh1++u+gKNym8PJUJ3qEZzZEDXcYFEUDtP3cOqJTEWQhT1v3/GcuiFF9CFk1p0+57wWYYa0BQNjlR8pcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq4BAy4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq4BAy4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058F6C4CEDD;
	Wed,  5 Feb 2025 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764592;
	bh=/mo+JzAeaLFCXX9BAGFyqJoYSibOF84kWE+a/BB/W2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq4BAy4yu1cvN/+Rb9+1kIUrZSUHS75giiyVCpyZJH/cVZxeTbj/PeklBc95K+w7l
	 IkG8EPxng+pTAKlAFiQ1NdgXn/61xgS5ohk+bHLSRyQ8Wz+kJCFC7NqkinGqCmzu1q
	 MbeXUxGlAse9Bxazq36FIx0CBWwB4CuDZPxx0ZH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/393] bpf: Send signals asynchronously if !preemptible
Date: Wed,  5 Feb 2025 14:41:44 +0100
Message-ID: <20250205134427.377399634@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 87c544108b612512b254c8f79aa5c0a8546e2cc4 ]

BPF programs can execute in all kinds of contexts and when a program
running in a non-preemptible context uses the bpf_send_signal() kfunc,
it will cause issues because this kfunc can sleep.
Change `irqs_disabled()` to `!preemptible()`.

Reported-by: syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67486b09.050a0220.253251.0084.GAE@google.com/
Fixes: 1bc7896e9ef4 ("bpf: Fix deadlock with rq_lock in bpf_send_signal()")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250115103647.38487-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5f12bb727b850..9d8f60e0cb554 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -853,7 +853,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



