Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC2B402BA9;
	Tue, 21 Jul 2026 17:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654792; cv=none; b=tKEkQQI+ASMw6EhBMRBClPdoaqWlGymdmsdic71sPVUl9kZ5hwc0A6UD+K3Bj2QDE4xf0Z+n8W1bIWk8yjrwuSApFiGTDD9XMRCibSxV5cjASYAUxeRPI4DHc6+vxKPHoCOLXvrqrH8THJbpO/ZBQbP3pueSK2SVv+VVhO5c+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654792; c=relaxed/simple;
	bh=rJ3NjfYNWeWPYHPf5PLvjl2UeBt1wjRC1o8kXAW5veA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSniWH66FpbSLgFd0ap8+d9mU2hi8A0kkyUd8IUIgNcqaTYIqMXnguUjqQdaxrqCPWpq1/YyEn1iKxr65MONBri7ZUrNdgn0NQzzBIw3aOQKt8YlVf/f1I3EYgbg6cX4pb0eVvHIXzNWu9Y5pJJvKpRzOe3ICB3BCiT65NVORq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqBgTl9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqBgTl9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29321F000E9;
	Tue, 21 Jul 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654791;
	bh=w9eBp1B6OAoRruXdfrzl/10jfkq1y2Cxhtbf3uMGb8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqBgTl9ImoMFgd47kW3ocblQDXN0vTeWGPQ6C8Ccsa9Er0tZiQn3kfRBPmfMAVbFL
	 9OEUPYA5vkXg0STwILVkFtauxFMn+iOCG4+6zRzJoGaJM8SmmrFyLngHnjg/T5JdGk
	 10nxFbStyS2L7g3dLNPgLn7/eLOyuxNEn6nR2t44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 7.1 1837/2077] bpf: Add missing access_ok call to copy_user_syms
Date: Tue, 21 Jul 2026 17:25:10 +0200
Message-ID: <20260721152636.067328751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit d5dc200c3a3f217de072af269dd90adddf90e48d upstream.

As reported by sashiko we use __get_user without prior access_ok call on the
user space pointer. Adding the missing call for the whole pointer array.

Plus removing the err check in the error path, because it's not needed and
also we can return -ENOMEM directly from the first kvmalloc_array fail path.

Cc: stable@vger.kernel.org
[1] https://lore.kernel.org/bpf/20260611115503.AC16D1F00893@smtp.kernel.org/
Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/bpf/20260611115503.AC16D1F00893@smtp.kernel.org/
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260616083056.405652-1-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2331,9 +2331,12 @@ static int copy_user_syms(struct user_sy
 	int err = -ENOMEM;
 	unsigned int i;
 
+	if (!access_ok(usyms, cnt * sizeof(*usyms)))
+		return -EFAULT;
+
 	syms = kvmalloc_array(cnt, sizeof(*syms), GFP_KERNEL);
 	if (!syms)
-		goto error;
+		return -ENOMEM;
 
 	buf = kvmalloc_array(cnt, KSYM_NAME_LEN, GFP_KERNEL);
 	if (!buf)
@@ -2358,10 +2361,8 @@ static int copy_user_syms(struct user_sy
 	return 0;
 
 error:
-	if (err) {
-		kvfree(syms);
-		kvfree(buf);
-	}
+	kvfree(syms);
+	kvfree(buf);
 	return err;
 }
 


