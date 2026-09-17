Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550C13A48E3;
	Thu, 17 Sep 2026 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660067; cv=none; b=LMTzTidkbLbPSTEz6hZWiHG4/kUU+QaVqcrfBvIRSxwd3KPUBpTUGglCIOT+UYMHwTG2O6CrEHuJUGr6gFQViZ+NZ5MISEC8Nj4zNKWa9doGOKPZ3qFqDjkqpLIwOSP8fSCvawHRmhlDDzi2EJmqRdp/DfcXeN328T6z7FN1JYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660067; c=relaxed/simple;
	bh=ymPDzgxFGxfUzsin9XqOgYkxcLqklix2EKP2C5GtcXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alcgW2+uIQMgFljH1eMvO21JO04DkODHUP9VXn0oqXSewmBjngBTqX+ykwAd/KAkkevEZnP0BTPwUCqb5QGwHntZEQmlKX3EklGoU05ntpsi6MKyqEupbPoZSGqGO7fbF1N2PPkRZ5TWwfx2KgL30nKoHkgSikDrKvKt+nQYP7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlljIPUV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlljIPUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FE51F00893;
	Thu, 17 Sep 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660062;
	bh=nbHI/fcuPtg+YXUp3FC7MsUtgG1wEplFxvpjXZE3IG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlljIPUV5AodcM3jVFIhrpyLOIooB/9KWJYPoZxfXjQ1oi33OTatlsp3N62Mjrhae
	 bcr1r/Mh+NXFRriTcLwM3oyos463q90EvTZ/XaDw/YXmwxsXHoZmCWbLy+mqct77Fs
	 +8F644fs9B7Y94RvqSPdm51ttCgm2I0fuESHRZK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 467/733] ftrace: Use rcu_assign_pointer() for tmp_ops filter hash
Date: Thu, 17 Sep 2026 16:12:55 +0100
Message-ID: <20260917151403.612979891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

commit b4dcc18b97913888e8d009624e07c8014ce41b84 upstream.

tmp_ops.func_hash->filter_hash is annotated __rcu, but
update_ftrace_direct_mod() assigns hash to it directly. Sparse reports an
address-space mismatch.

Use rcu_assign_pointer() for the assignment.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260911142512.19344-1-leon.hwang@linux.dev
Fixes: 50b35c9e50a8 ("ftrace: Use hash argument for tmp_ops in update_ftrace_direct_mod")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609110704.Q3M5vCDV-lkp@intel.com/
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 53d5db60bfa5..673a54fdf392 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6675,7 +6675,7 @@ int update_ftrace_direct_mod(struct ftrace_ops *ops, struct ftrace_hash *hash, b
 
 	/* Enable the tmp_ops to have the same functions as the hash object. */
 	ftrace_ops_init(&tmp_ops);
-	tmp_ops.func_hash->filter_hash = hash;
+	rcu_assign_pointer(tmp_ops.func_hash->filter_hash, hash);
 
 	err = register_ftrace_function_nolock(&tmp_ops);
 	if (err)
-- 
2.55.0



