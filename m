Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CA91553BB;
	Mon,  6 Jan 2025 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179001; cv=none; b=pexsVOguj7ClHkLX6cW08txZmfsG1EdhwTVhR7/w0cxHXRPkDsPllntg0Csxwwco16BDXnvQ/G0CB8eex5GZB3VSDH77Q9hvorzbLhsSiRj0bB9PN35iE/bjlWPgZ4ejet8BZouFkPeJbWyfxj7NBENpFNBD7Ktg4hNBUwW2xDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179001; c=relaxed/simple;
	bh=MHjJt+m9Cm6SyZ0Qq2s5PJJl1mGu/krduVY8Md1SevQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri7/6QZ5lwI5uJUc7Fx8deXM6ZGJmF++VDc+YQbV9VUF6M2eVWWp78loH3dUJDx8iTpkVtMtsjLup9TH7+GenEyeO15cydfdBVhaLl/NQABe2rFSOhw7iEjKfl7sROxp4NFaljCSq3mGtN0ogRTmBwdvejSkOuSQ8xOrb4ckWPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK3FVABZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK3FVABZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47F8C4CED2;
	Mon,  6 Jan 2025 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179001;
	bh=MHjJt+m9Cm6SyZ0Qq2s5PJJl1mGu/krduVY8Md1SevQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KK3FVABZk5/E20vSpIgZG3A3wVqxGGVcwqHpRb41b16IDVaJgV6hojh+LCOLdPYcj
	 UioPU65hAZz6K9Yjlx7/dZ917kv0aklrOfPWDGNuNM8FiMP133PzjjbOZsc5/s3OuW
	 xWKEx7FT38WqB7IWoghShrK5nt2182FuOe1xxF6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.15 162/168] RDMA/uverbs: Prevent integer overflow issue
Date: Mon,  6 Jan 2025 16:17:50 +0100
Message-ID: <20250106151144.547733735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2010,11 +2010,13 @@ static int ib_uverbs_post_send(struct uv
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
@@ -2200,11 +2202,11 @@ ib_uverbs_unmarshall_recv(struct uverbs_
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


