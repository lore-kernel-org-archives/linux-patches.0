Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673883C197C;
	Wed, 30 Sep 2026 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794883; cv=none; b=e+/mmUsYGgaBmqHQUZ1xUwa52LCmjRhqvnD1b2bxdKbS6shRAC5rLOaPnpzC8kS1SwjhkTS61QeA/dOOqctRFpq+rElTJmXuQ06gACcusNKRB1gVeHYmKAqLrQOZ64tSmhJZ9J7u/bYpHcXgB6p9JHxngMJTrTtkKwGiU7lsREQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794883; c=relaxed/simple;
	bh=3jjToTCXMeH1z/iJCzpS7cjRIIQM+x2TXy/bX7FjYxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgkA1+fZaZ+NKkxPFOB5xX+so2wfxEsfbyTafEAuDv7vVWcxgb3Gp92PQuEA3M4r3oqK9FD/UdEOFNVvVxvs1qaj3TqUo7DFp+qow3TsrtgCXQqzOj7qA+U0/coqsLrfWLFAtLknYAgPYClUdLDfjoIM4y/hAlP3/D1WnfE1XN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUFITigl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUFITigl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DE31F008A2;
	Wed, 30 Sep 2026 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794870;
	bh=lUze5njO7FDX1TfSFhfOhsyfGWpp4CAyMtmpU4xYKug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUFITiglELfD82vShdDJIQYOpcgIHmEJi+f+/o48mI1zQjPKjfhYXIsg1i7kDbZqM
	 72cqbft8+Pnlv0Hh9U/zcIxUGqYO77sM3zj+t/g34KljjoVtI8JuYr7g4UqwuBQw+4
	 ifUVu7NzAZuOkddEmlVdrL7tQBZ4iJKx8PRrwZu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0361/1193] bpf: Guard __get_user acesss with access_ok for uprobe_multi data
Date: Wed, 30 Sep 2026 17:17:25 +0200
Message-ID: <20260930152442.196806105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4d87a251d45b4a95eb4c0abcfab809c9f231258a ]

As reported by sashiko [1] we need to use access_ok to check the user
space data bounds before we use __get-user to get it.

[1] https://lore.kernel.org/bpf/20260610145235.CB1441F00893@smtp.kernel.org/
Fixes: 0b779b61f651 ("bpf: Add cookies support for uprobe_multi link")
Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260611114230.950379-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c50852022cca5..847f94443a0a6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3199,6 +3199,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	unsigned long __user *uoffsets;
 	u64 __user *ucookies;
 	void __user *upath;
+	unsigned long size;
 	u32 flags, cnt, i;
 	struct path path;
 	char *name;
@@ -3233,6 +3234,16 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	uref_ctr_offsets = u64_to_user_ptr(attr->link_create.uprobe_multi.ref_ctr_offsets);
 	ucookies = u64_to_user_ptr(attr->link_create.uprobe_multi.cookies);
 
+	/*
+	 * All uoffsets/uref_ctr_offsets/ucookies arrays have the same value
+	 * size, we need to check their address range is safe for __get_user
+	 * calls.
+	 */
+	size = sizeof(*uoffsets) * cnt;
+	if (!access_ok(uoffsets, size) || !access_ok(uref_ctr_offsets, size) ||
+	    !access_ok(ucookies, size))
+		return -EFAULT;
+
 	name = strndup_user(upath, PATH_MAX);
 	if (IS_ERR(name)) {
 		err = PTR_ERR(name);
-- 
2.53.0



