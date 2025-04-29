Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E91229B05;
	Tue, 29 Apr 2025 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945972; cv=none; b=MyHwq1bQx2tr1qkni7h6pESVxVEHRvp3RFdqxRw6ivOQPFiR4acW9ENzEcuZo2/9mTe1RSz+ifrp50hQVl7sDPf23KvB4FkKerOhKzWqc8pLayW8BRyOQrw1ocsm7dNdmjiq1AtwSrkrAZN71x42GAJoWgZPJ1d0zi3gUz/mqyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945972; c=relaxed/simple;
	bh=o3ybHSIfYne7gFBRZvGg+e2tf/5I+YiEjnWsmHJs7yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX5UA9eg3Ovw0cwfTEHcirlCIowzkyhQgKZbxg3cpV+D8xOk1yxfyMeZhQ2zwFODkulTDdyHyBH7nqCoYYJtOkXDFjaluxNAgdT3PHaquh5Mh2ifajyleYt/iCHSel8W7fnYPMfJbBbZ12dmKVVHoWkzAwPYum6lJFt4/BSG3L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0FQkrnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0FQkrnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B476EC4CEE9;
	Tue, 29 Apr 2025 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945972;
	bh=o3ybHSIfYne7gFBRZvGg+e2tf/5I+YiEjnWsmHJs7yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0FQkrnH5P4lNdsoSqIHX3unFa867grX9lxU2sEyX5lFBQGIbi/uSlWZCIW+ugpvh
	 uC5yueFSbvXIeFaSrx6Ps3aYY0xS7Y8j6PjgEOt+OohzmYa+H2WMLK88411lKize7v
	 bq8Kd+zvg4WU9LcYhib0uUd/a15tX0aOjOO1swCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Breno Leitao <leitao@debian.org>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.14 111/311] sched_ext: Use kvzalloc for large exit_dump allocation
Date: Tue, 29 Apr 2025 18:39:08 +0200
Message-ID: <20250429161125.579825462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 47068309b5777313b6ac84a77d8d10dc7312260a upstream.

Replace kzalloc with kvzalloc for the exit_dump buffer allocation, which
can require large contiguous memory depending on the implementation.
This change prevents allocation failures by allowing the system to fall
back to vmalloc when contiguous memory allocation fails.

Since this buffer is only used for debugging purposes, physical memory
contiguity is not required, making vmalloc a suitable alternative.

Cc: stable@vger.kernel.org
Fixes: 07814a9439a3b0 ("sched_ext: Print debug dump after an error exit")
Suggested-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4944,7 +4944,7 @@ unlock:
 
 static void free_exit_info(struct scx_exit_info *ei)
 {
-	kfree(ei->dump);
+	kvfree(ei->dump);
 	kfree(ei->msg);
 	kfree(ei->bt);
 	kfree(ei);
@@ -4960,7 +4960,7 @@ static struct scx_exit_info *alloc_exit_
 
 	ei->bt = kcalloc(SCX_EXIT_BT_LEN, sizeof(ei->bt[0]), GFP_KERNEL);
 	ei->msg = kzalloc(SCX_EXIT_MSG_LEN, GFP_KERNEL);
-	ei->dump = kzalloc(exit_dump_len, GFP_KERNEL);
+	ei->dump = kvzalloc(exit_dump_len, GFP_KERNEL);
 
 	if (!ei->bt || !ei->msg || !ei->dump) {
 		free_exit_info(ei);


