Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCB03594E;
	Mon,  6 Jan 2025 16:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179322; cv=none; b=EvwS6m5FDs7xnarLya3G1FWlLGXJ2dHtZWSr8nSWVYxKN5VipSrmf/qj7/nvXbjIT/OgrS2Zht6I19YQsZA3DV7wZZYbqDLFBFOvjA96To5zLrYVBYQq7o8kvFNbvHiiEFRKsZNcJGQB/DYEvlYfAutaCasBv/BDMNEr5k9qTQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179322; c=relaxed/simple;
	bh=4zwl3+M1E0XZTF7NcecHD1sNixX7PYaay1qAGhChnWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV6OeJ9J/YID3fXWZEqWTw/tcZELEjHtcYcRFvWAGmi7WETv8JFDp9PtwZTsQ2Mwj9JQVToBjt87vUE9I81p80+tCtdkNSQEuLXAlVbXJkQ6rjgUYdzacpybrO7FKRkxYMjDmfD2RiwzD2YK/m5cfrahZ+B/X+o+7BF+AEQ5scw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VE+/drqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VE+/drqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C962C4CED6;
	Mon,  6 Jan 2025 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179321;
	bh=4zwl3+M1E0XZTF7NcecHD1sNixX7PYaay1qAGhChnWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VE+/drqLVYaLymwZBRqaJ1mrkwTBd1Mn7P9+gRE1i0Nn9+wvmOePVfiEkDl1GPpBh
	 ld1azE75cN/k9EEuWMknq7UKWjv2Tow/WE48zS7u7nMbkGjeDNSIOOab/+LdWqH5EO
	 4VoxoMzixXKGG/6ZCbPwMzWAwbVIAQ+vDRT8qF2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.4 88/93] RDMA/uverbs: Prevent integer overflow issue
Date: Mon,  6 Jan 2025 16:18:04 +0100
Message-ID: <20250106151132.024284049@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2024,11 +2024,13 @@ static int ib_uverbs_post_send(struct uv
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
@@ -2213,11 +2215,11 @@ ib_uverbs_unmarshall_recv(struct uverbs_
 	if (wqe_size < sizeof (struct ib_uverbs_recv_wr))
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


