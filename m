Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B447125D;
	Tue, 21 Jul 2026 18:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658964; cv=none; b=PgreUpqQjr6oXwQ6mtFFg6RdgRFdGowSgEIExfiObKOz6ZdX6C/7qTOAja1AJUTzIbw8mBWR2QkclKoTMUKIgRSVcUmJ/nuvFZ9C62xq5qGR7GTNbpQBVflzmINPdGjBPxPIvFItgfzDZk8px4PfGlkAhWDsWuryRzZxQ+KkfRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658964; c=relaxed/simple;
	bh=43knxKmwYAe36SC6zn4R6IejKzUjJ4Jsh1G9t2XJzhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY0lKC9+Wamz7bBCc0BmJC0tUJ/kPoOksNUUUwoL6pIrmPOuzsV2yVi3Gq6wGQUa0af8zlUQk+r6yd8TDqsY9g8UaArQrn8cc0aLFXo5wmOLBdjdZsPDrwY5b4OMcGV2dwCJO4m11TuvfgYusJgLofQc62mLt94cry4vYHiWG0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcfOZpQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcfOZpQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299341F000E9;
	Tue, 21 Jul 2026 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658962;
	bh=A7Kc0MEQ7ekiJLzT1y+uRUs394exDbcMQkZKja7KcU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcfOZpQgnVCvy74F9L+BofDRzZ3JFs/rlgPvb8xIQPh9aFgTaFt/FR/2kQPyTYoUA
	 TDMFOd370yJFxXBJMTmTOJhB5Y/U7Dsy3/s01ng2hElhg7XPrByYzdX/Ea4RmN2ooZ
	 2RMBsv/PdLRuT64Q7KPaZPA1m8qEO2lQHcTMIIvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.18 1340/1611] bpf: Add missing access_ok call to copy_user_syms
Date: Tue, 21 Jul 2026 17:24:16 +0200
Message-ID: <20260721152545.593864913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -2318,9 +2318,12 @@ static int copy_user_syms(struct user_sy
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
@@ -2345,10 +2348,8 @@ static int copy_user_syms(struct user_sy
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
 


