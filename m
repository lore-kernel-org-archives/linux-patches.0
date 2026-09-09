Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B863560AD1;
	Wed,  9 Sep 2026 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963182; cv=none; b=tzb0pwhLWU+4ThP/974nZ24t/Y7JCF2rRR4NifedCXOP1db4hJZGc8IRkwVnVjUin+TTacd2lo7x90FtE+fyY38RkzohoyD3+uPo2wOlSulUkQpUV4dQhYZsEWE2fIRFEu97QRkcI1+3OVGHGKP7MZXaAi/5Sjh+UlQpZCdqmf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963182; c=relaxed/simple;
	bh=mHh8sqbET5p5219F+V8ivjhFbH8fdVQzNg5nlWaAdes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKbG3Ek/rfFCEJTCLjRQsS546+2oVtWCvL47NWU2qIWg8MonA8pU+lQOpJkckocmMKq+5Ss2lnYgdEek/z9ludLjaZ33Aq+82Ifcwr9d1gbaobznG/Bi/kfrH5yYe2BcyTkHUbuEzEfCSFnd6MU1X+VJojph/F9PrWSGT/53C9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crdjDCT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crdjDCT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8DD1F00A3A;
	Wed,  9 Sep 2026 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963181;
	bh=ElnbKIDBR1QsAnz++/bzfTMyTmNkBXlMES2vWNJiGYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crdjDCT0UU7Plae8zMMUqoHQg0K/vUIBLihvV5it0gj/1cCcL9k3XhrxW/ki0vZSf
	 oubxhZDP29pTNH6JaFXeLDbPSiJVSNnTvQvwcnRCOLiu2FTFqHL+OK4bVZfC+elbKf
	 K66eCGlS7nAcA+SABRI24y2dewX6xN6LVH6ohxbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 546/556] bpf: Disable preemption in bpf_get_stackid
Date: Wed,  9 Sep 2026 15:43:46 +0200
Message-ID: <20260909134249.597011421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -632,20 +632,22 @@ BPF_CALL_3(bpf_get_stackid, struct pt_re
 		return -EINVAL;
 
 	max_depth = stack_map_calculate_max_depth(map->value_size, elem_size, flags);
-	trace = get_perf_callchain(regs, kernel, user, max_depth,
-				   false, false, 0);
 
-	if (unlikely(!trace))
-		/* couldn't fetch the stack trace */
-		return -EFAULT;
+	scoped_guard(preempt) {
+		trace = get_perf_callchain(regs, kernel, user, max_depth,
+					   false, false, 0);
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


