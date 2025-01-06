Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297F349652;
	Mon,  6 Jan 2025 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176912; cv=none; b=pXDb2y1bdwsmZJ0GsZiBmEBdMt2BeASm04+Ecxg0rQQREs9XC5eLEpZ0QHttCyEQ5EqDQlcgEWK0ayyDxZI5tL+YiE1WV/SjR1s59ZwIM2UeolEdwWKrTFM/a/Y8qmXJs0g1k3P2OG/8g0si4qnxMMynnIwdIDEed1hMHKhbfxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176912; c=relaxed/simple;
	bh=1NLlNAvkCqBorTOdPefM10e8U6Yxa+eG9X34gtjurQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0Xy34iYzYiJfQfXsJnxJIVH3vSCGPRQKgm0EWfUwDskGwhrT2P2+8zD7AVO0f/2/331sj6pPnO075yEf2RSuvWvYr1b9wrdLnXYmz2V/57wPBrYqqJlCm63F5AwxDaYAIzT+idukztKi2Nq/Cw7hKFPQYhyZGwi0QVe//ja1yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEjvTRwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEjvTRwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5E5C4CED2;
	Mon,  6 Jan 2025 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176911;
	bh=1NLlNAvkCqBorTOdPefM10e8U6Yxa+eG9X34gtjurQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEjvTRwkeC8W5Ixoy37QY5Wyd6VQSgY8WZkV0JQODjN3YFWhZlXKW2wCVJN6njs4q
	 xVSL5crrADldev6mdCMBVUFc8KtWvOSpjtKrklb8x4zqXOU1stCnLOeEaA4cXj1bgv
	 2fOUmOqoFS6OODmQ2EBNNRJDlMZZUyR6joL2lSes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 71/81] RDMA/uverbs: Prevent integer overflow issue
Date: Mon,  6 Jan 2025 16:16:43 +0100
Message-ID: <20250106151132.110649689@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit d0257e089d1bbd35c69b6c97ff73e3690ab149a9 upstream.

In the expression "cmd.wqe_size * cmd.wr_count", both variables are u32
values that come from the user so the multiplication can lead to integer
wrapping.  Then we pass the result to uverbs_request_next_ptr() which also
could potentially wrap.  The "cmd.sge_count * sizeof(struct ib_uverbs_sge)"
multiplication can also overflow on 32bit systems although it's fine on
64bit systems.

This patch does two things.  First, I've re-arranged the condition in
uverbs_request_next_ptr() so that the use controlled variable "len" is on
one side of the comparison by itself without any math.  Then I've modified
all the callers to use size_mul() for the multiplications.

Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/b8765ab3-c2da-4611-aae0-ddd6ba173d23@stanley.mountain
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -161,7 +161,7 @@ static const void __user *uverbs_request
 {
 	const void __user *res = iter->cur;
 
-	if (iter->cur + len > iter->end)
+	if (len > iter->end - iter->cur)
 		return (void __force __user *)ERR_PTR(-ENOSPC);
 	iter->cur += len;
 	return res;
@@ -2009,11 +2009,13 @@ static int ib_uverbs_post_send(struct uv
 	ret = uverbs_request_start(attrs, &iter, &cmd, sizeof(cmd));
 	if (ret)
 		return ret;
-	wqes = uverbs_request_next_ptr(&iter, cmd.wqe_size * cmd.wr_count);
+	wqes = uverbs_request_next_ptr(&iter, size_mul(cmd.wqe_size,
+						       cmd.wr_count));
 	if (IS_ERR(wqes))
 		return PTR_ERR(wqes);
-	sgls = uverbs_request_next_ptr(
-		&iter, cmd.sge_count * sizeof(struct ib_uverbs_sge));
+	sgls = uverbs_request_next_ptr(&iter,
+				       size_mul(cmd.sge_count,
+						sizeof(struct ib_uverbs_sge)));
 	if (IS_ERR(sgls))
 		return PTR_ERR(sgls);
 	ret = uverbs_request_finish(&iter);
@@ -2199,11 +2201,11 @@ ib_uverbs_unmarshall_recv(struct uverbs_
 	if (wqe_size < sizeof(struct ib_uverbs_recv_wr))
 		return ERR_PTR(-EINVAL);
 
-	wqes = uverbs_request_next_ptr(iter, wqe_size * wr_count);
+	wqes = uverbs_request_next_ptr(iter, size_mul(wqe_size, wr_count));
 	if (IS_ERR(wqes))
 		return ERR_CAST(wqes);
-	sgls = uverbs_request_next_ptr(
-		iter, sge_count * sizeof(struct ib_uverbs_sge));
+	sgls = uverbs_request_next_ptr(iter, size_mul(sge_count,
+						      sizeof(struct ib_uverbs_sge)));
 	if (IS_ERR(sgls))
 		return ERR_CAST(sgls);
 	ret = uverbs_request_finish(iter);


