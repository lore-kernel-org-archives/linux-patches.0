Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0526526AA91;
	Wed,  9 Sep 2026 14:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964619; cv=none; b=IxYVLShaGNPjPYJ2q8Vjn2nh3wToep1Ks4NyfrVFdVxhTDYL6skQA6LjuI6ICCEgE4yEYc13vr1pkbtvoQS4444BmLASXLe2S14cP34vXrS8kzBPIRFFKbcincuG0Eepqu3cq98FOfiZpfiJ++5WtaAxlF8PskGQCFZ2VOrWJh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964619; c=relaxed/simple;
	bh=78fC2xsjtr8MTT8q/PNOJt6jSS1hJgLf2EPKZecb8ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skJgty+4UKPc93YLsC4bklqqzITyAyBUsMEgK2tVJlvEfhFzMUFWOMvsV8NwT661xh/eyMKQQQD241rv3B7khQYEbqH9cXboN6ODtU4s7Yy7/qczlYBBmF6sDcTmC3r/PYmmu9yx8ttHnSc4zAAvfeFnMx/navOMMhGXRBHBaJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT9Wn8VX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT9Wn8VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DD81F00A3A;
	Wed,  9 Sep 2026 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964617;
	bh=g/4kyKgkRr9hGvSuDKEmlSbdd8HEbpyp3h18HUH5MjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uT9Wn8VXEU6ntSmWvixSVOd/qTo97OWqZJ52hH/gRTvO52nl3ld713cMEj+UKE5Mu
	 g77YFHlFX9yyyLzNnbBVwqr5R+1w+J7ebKMrd+VMkGM2ylRe59GV9um13cow8T3/mi
	 wnqyaSISbr7cG6WbMoUV7Hjq66Hnc/JBk58u6ac4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/583] bpf: Disable preemption in bpf_get_stackid
Date: Wed,  9 Sep 2026 15:42:51 +0200
Message-ID: <20260909134254.655367318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 15f1bd8574662f1b7b26aaa2e23ebf4066f0117d ]

The get_perf_callchain call needs disabled preemption plus we need
it disabled as long as we access its returned trace entries buffer.

Note the bpf_get_stackid_pe function is executed already with
preemption disabled.

Fixes: d5a3b1f69186 ("bpf: introduce BPF_MAP_TYPE_STACK_TRACE")
Reported-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803210149.296496-6-jolsa@kernel.org

Closes: https://lore.kernel.org/bpf/20260206090653.1336687-2-chen.dylane@linux.dev/
[ adapted get_perf_callchain() to the older six-argument form ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -374,20 +374,22 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 		return -EINVAL;
 
 	max_depth = stack_map_calculate_max_depth(map->value_size, elem_size, flags);
-	trace = get_perf_callchain(regs, kernel, user, max_depth,
-				   false, false);
 
-	if (unlikely(!trace))
-		/* couldn't fetch the stack trace */
-		return -EFAULT;
+	scoped_guard(preempt) {
+		trace = get_perf_callchain(regs, kernel, user, max_depth,
+					   false, false);
+		if (unlikely(!trace))
+			/* couldn't fetch the stack trace */
+			return -EFAULT;
 
-	err = stackid_fastpath(&stackid, map, trace, flags);
-	if (err != -ENOENT)
-		return err;
+		err = stackid_fastpath(&stackid, map, trace, flags);
+		if (err != -ENOENT)
+			return err;
 
-	new_bucket = stackid_new_bucket(&stackid, map);
-	if (!new_bucket)
-		return -ENOMEM;
+		new_bucket = stackid_new_bucket(&stackid, map);
+		if (!new_bucket)
+			return -ENOMEM;
+	}
 
 	return stackid_install(&stackid, map, new_bucket, flags);
 }


