Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D3E8462;
	Thu, 17 Apr 2025 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913736; cv=none; b=lJI76JKmOuVn8nFB8F14N4/Rkg+0oOZS0zC9vCk9nr3SeSZry0suY+dZ+qecwu5RoHycHpR6Q1+6p8NqSoh5ADfNTIJgf3+SkbSM1CA+9FlNTZlRwQCzKpv9+pcRquDpPOSIhTgErh+CpxcFWbnqbgjM7fqshlCm2rkLA0iS4Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913736; c=relaxed/simple;
	bh=tRlHhLV3G3YKdW8ocoDPxFvfYgKe89p1jyvnFVFEcGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYOPtr8S96bMEd1gnM9H8sv4+ww2gL9BukeL8xqKqRSH4fYKUz2a/hb+WuVxzx96BKeszJI5CWQdNBQ5xcyyJW9MQ7bdYB7psT12sLuvbLosC3l8IuGPOXPqZq+j1iAcbclE2nBUazov6RldPR4ccmD+N8utcPJak+b3vuoi1fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSoT+s70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSoT+s70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0C8C4CEE4;
	Thu, 17 Apr 2025 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913736;
	bh=tRlHhLV3G3YKdW8ocoDPxFvfYgKe89p1jyvnFVFEcGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSoT+s70Gx05J2Ab8wN3Wi5S6qa51omv6vzsk1HcKKPPsAyeh8J4foqPrmewxgq8U
	 i33DI2F91DofV2wheQPLXje80vUji1LJxgvYdh56tX8UDlx9WkihWZluAe5k4fd98h
	 Zp9x1a3apx5vmBaaCSZZkRxPDmQjGI841WTWFIOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Hillion <jake@hillion.co.uk>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.14 437/449] sched_ext: create_dsq: Return -EEXIST on duplicate request
Date: Thu, 17 Apr 2025 19:52:05 +0200
Message-ID: <20250417175135.903173358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Jake Hillion <jake@hillion.co.uk>

commit a8897ed8523d4c9d782e282b18005a3779c92714 upstream.

create_dsq and therefore the scx_bpf_create_dsq kfunc currently silently
ignore duplicate entries. As a sched_ext scheduler is creating each DSQ
for a different purpose this is surprising behaviour.

Replace rhashtable_insert_fast which ignores duplicates with
rhashtable_lookup_insert_fast that reports duplicates (though doesn't
return their value). The rest of the code is structured correctly and
this now returns -EEXIST.

Tested by adding an extra scx_bpf_create_dsq to scx_simple. Previously
this was ignored, now init fails with a -17 code. Also ran scx_lavd
which continued to work well.

Signed-off-by: Jake Hillion <jake@hillion.co.uk>
Acked-by: Andrea Righi <arighi@nvidia.com>
Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4523,8 +4523,8 @@ static struct scx_dispatch_q *create_dsq
 
 	init_dsq(dsq, dsq_id);
 
-	ret = rhashtable_insert_fast(&dsq_hash, &dsq->hash_node,
-				     dsq_hash_params);
+	ret = rhashtable_lookup_insert_fast(&dsq_hash, &dsq->hash_node,
+					    dsq_hash_params);
 	if (ret) {
 		kfree(dsq);
 		return ERR_PTR(ret);


