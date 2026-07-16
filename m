Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193B6435A8E;
	Thu, 16 Jul 2026 14:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212148; cv=none; b=EP28naI6kte/IOCBxKiElYnaODxTsfsEnuhs9eBr0Yg5HygSqWcnO+F+6tYVco+kA7WjHoEExM+1Wz/2+yG6AG4L08baFmfF7fSh+kqizSQi+pjjNoSnn3aDas0xBGgHCJYFYSjfY2KRwAsVrl9bwNXWSXz+kmKzg2pEOmr4CrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212148; c=relaxed/simple;
	bh=EX1HGehAD1j0Lj4zNRq7tjdmcIXrH0c9uGiuHw15drk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMfd4s/hN4j3PpPGTz+c/EbWYpthOz24bcAJG6E1mLFbplG/bCwQKqza28qeL3XNMv3OLWspAcR4pXTi6CCegzYZuPE5U5pBpsqAFaCOLoETsrcFCHCxwFn0x4ixHueAier1Dbd65HbgfqOSwA9nlvEOKZsmIvvAIA05HbApOm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L75vDW6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L75vDW6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855691F00AC4;
	Thu, 16 Jul 2026 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212147;
	bh=VjVPLaa8qkjAUuSJqGxqGT/lXvV9BL6NsCRkPJt6I40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L75vDW6Vg3XvStcAg+xcYk3Lm8FYjiYR8q1m/oe2vNs8Wkmo5SqDTYOFzIycI0hhu
	 snzmKyCkHfJPi+EvCPSvG30nD22LNt6Mw+s9fb02VDygPDXnKTTI2n1BEZISmUZL7L
	 16WueSZUgirhfFL//cVDdck+R6xGQO4DVzdTyw94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 217/349] bpf: Restore sysctl new-value from 1 to 0
Date: Thu, 16 Jul 2026 15:32:31 +0200
Message-ID: <20260716133038.220142986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 2566c3b24219c5b30e35205cba029ff34ff7c78b upstream.

Commit 4e63acdff864 ("bpf: Introduce bpf_sysctl_{get,set}_new_value
helpers") changed the success return value to 0, but failed to update the
corresponding check in __cgroup_bpf_run_filter_sysctl(). Since
bpf_prog_run_array_cg() now returns 0 on success, the legacy ret == 1
condition is never satisfied. As a result, the modified value is ignored,
and bpf_sysctl_set_new_value() fails to replace the write buffer.

Fix this by checking for a return value of 0 instead, so cgroup/sysctl
programs can correctly replace the pending sysctl buffer.

This bug was discovered during a manual code review. Tested via a
cgroup/sysctl BPF reproducer overriding writes to a target sysctl.
Pre-fix, bpf_sysctl_set_new_value("foo") was silently ignored: the write
returned 8192 and the value remained "600". Post-fix, the BPF replacement
buffer properly propagates: the write returns 3 and the value updates to
"foo".

Fixes: f10d05966196 ("bpf: Make BPF_PROG_RUN_ARRAY return -err instead of allow boolean")
Cc: stable@vger.kernel.org

Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20260603105317.944304-4-dawei.feng@seu.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1773,7 +1773,7 @@ int __cgroup_bpf_run_filter_sysctl(struc
 
 	kfree(ctx.cur_val);
 
-	if (ret == 1 && ctx.new_updated) {
+	if (!ret && ctx.new_updated) {
 		kvfree(*buf);
 		*buf = ctx.new_val;
 		*pcount = ctx.new_len;


