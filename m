Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC6B3B8407;
	Tue, 21 Jul 2026 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670239; cv=none; b=DG2LnRf3+3284njB3V2TZyXdcdLiouPnSsGrK389c58xZMI8ZVavhQVKHPlMa9aJYAeGE5qmF4MuQ/BH6Ckr65JspfOdmyBMickXtqNP8zhpHCWGtXNvPACm/c7im3ZRv2dTkYdhpxI2RtEcQUccQ+P4Bc7iUhi9+9ALknND5Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670239; c=relaxed/simple;
	bh=xJDy3I1AqXYXHYv2flFof2aL3OXvF4Sh/slgOxWdrXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm+LlHIijPc1Vn2Vm5bmMQOuFxc55g9Aec2X9V5y3UeGeaa8apEk079E+H+Z7lAFWb4dsLfrjwzKweErGG//PMjL/Wbo1bQ9CiJXA4u5i3GFEnJ73FW1C4zHaxFRpUy7UDb1YVYtiqF5YUG/e9aWTPfEBAi7myyfuDySB+YreUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZXz46US; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZXz46US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DD71F000E9;
	Tue, 21 Jul 2026 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670237;
	bh=GY9bRZ29x2n8gnqsKySXRviF3oUfnqV3HaiUJ7MQgBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZXz46USqd7C0H4UgB2kNF2PtqqRwZSWfix6j6iI0Ti1gNWtx9FPzzE6tYfvKYBhU
	 y40QUIVcZGCAE83kxD/x+oLgaAAEMC1Uuzb5Hdp+CuxqiuD++4gqtuqQqWIJwDNKQx
	 AMaYM1eKfGWoy22jQnSpOuA7fbs8o3rxq2B8jbp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 0840/1067] bpf: Add missing access_ok call to copy_user_syms
Date: Tue, 21 Jul 2026 17:24:01 +0200
Message-ID: <20260721152443.340545723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2504,9 +2504,12 @@ static int copy_user_syms(struct user_sy
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
@@ -2531,10 +2534,8 @@ static int copy_user_syms(struct user_sy
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
 


