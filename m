Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B047348C70;
	Tue, 21 Jul 2026 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663903; cv=none; b=ek95kORvF08Z6ifjbFhZ8ZngnAWgnG7fOOyg4qfQYtzx7htfe2HQq34MeGUX58B5dcDLvTq+jhkRojtxUgL9iTT8OuI2KNszpocEpOWmp0+H/gFHbx/D6+SNgEKZh86V+0PUYlz3Hhq65mjcZs2tSg1gt8bcLkMZ2yAHdJsgtxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663903; c=relaxed/simple;
	bh=dRD5HdbkgbujoFsndpX96+t1dyftClPWBU2i4sRmS/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz24qj3qWspUHanRv3peYCyVIkmYkoXncofj4+XH7W6fsy4jf+bC+sQz81D+XKckzjPcz+iQOqOnpoMskBXxpSMY9OF/4PWtmW6kTWMcimcaapZZL46XEz1t1vk5SM3FLZU2ei4XW+loZ6WhyMaglcSoHavkPURu8ymkgjjf9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jw5GFfjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw5GFfjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788E61F000E9;
	Tue, 21 Jul 2026 19:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663901;
	bh=NauZ0uMEoBSh94MJBjjv5v2Gr1uvCXujbH+UvXEiKEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jw5GFfjWOmhgfK6/fpnWx7IEVE91bLEKTDr4SjjtStQKmakfhLAq6BB5wqIV4WCnL
	 DO8YOxmOdS+yVxG1ajjdzMXkDzSEUUruOFhLyFiXBcxTXDjcoX8RdB/HW2GWjhq2SG
	 w8xPON8sURtqj16nnoDXuY6k1GDTJtyJvvJ7ZzG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 0997/1276] bpf: Add missing access_ok call to copy_user_syms
Date: Tue, 21 Jul 2026 17:24:00 +0200
Message-ID: <20260721152508.322391765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2559,9 +2559,12 @@ static int copy_user_syms(struct user_sy
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
@@ -2586,10 +2589,8 @@ static int copy_user_syms(struct user_sy
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
 


