Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB162571B3;
	Thu, 17 Apr 2025 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916198; cv=none; b=Xn0ZNLi/04O0m/nbSgnd76QU+eIhaJcmRp39JbyQRT6/IT75AOVzuQ0F8/DVMF2okTMYrXdaho1ggYIc5vCHGUr7GmwPRgZj3A6zWVToOcHZzlsJcoffxtFhHOv6ZP+G2G9sk+jehvHF/GXEelN0FWp7TbZtef2HhVSDD0wt82g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916198; c=relaxed/simple;
	bh=HyRudmYEOpLTQgGzqKFPlxEGBvzireoI+d6Qfp7L3eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWRJUEHt+Cc89o1CSClXKVY7QooKR1GXKdb+qobBmruFjdOf9KfS57exid07BQrrO3xSuQmbCXuNOc2pTHpAdP2w+Uo0+CtbDhYGJPuHedhCCH/Kx8xo98SEir4AVVYxrNX5wgtfM+yNCpzjJnOZVSF3paHW9z8V1CVx+ZOlbrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ez/6+1dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ez/6+1dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D90C4CEE4;
	Thu, 17 Apr 2025 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916197;
	bh=HyRudmYEOpLTQgGzqKFPlxEGBvzireoI+d6Qfp7L3eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ez/6+1dL9Dpkvc8seNWGmp7lAcegH8P0cEOvjMUk77oNDNT/esLp603qYFmVUlLAc
	 6GT3TNZ372iayzTYnizkItSG0dpcLO+72jVAaj+Xnww4nbGFmmB1Lp6H1OCKXO74zD
	 p70QaSQjpRMhXC3Y1Au+q/nrH3ZrMdhY3cf5OTeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Hillion <jake@hillion.co.uk>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 375/393] sched_ext: create_dsq: Return -EEXIST on duplicate request
Date: Thu, 17 Apr 2025 19:53:04 +0200
Message-ID: <20250417175122.686075955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4160,8 +4160,8 @@ static struct scx_dispatch_q *create_dsq
 
 	init_dsq(dsq, dsq_id);
 
-	ret = rhashtable_insert_fast(&dsq_hash, &dsq->hash_node,
-				     dsq_hash_params);
+	ret = rhashtable_lookup_insert_fast(&dsq_hash, &dsq->hash_node,
+					    dsq_hash_params);
 	if (ret) {
 		kfree(dsq);
 		return ERR_PTR(ret);


