Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B129A54705B;
	Thu, 17 Sep 2026 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665094; cv=none; b=QORCX/6SU/Ma90W9LAEi5K4y5WKvsvatV1fWq3HnqEEdXE5oxiAFk7vnByelDEXWZ3VLO3u1EAavA/Cwejs3QReLaDiwJfQGmuPh2JCOFN69sisSNzmvalJVmt9fRMJib81KPANzABQYZZ5SacUhswwznExavunyTEY+ehIOHms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665094; c=relaxed/simple;
	bh=xs/R0aZc3cuL9pfW1ntXXMD3RgqfyIxIJkdXb4l0284=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrGRVj4WtAFO7eH0etrT6mKujwwPUCfEEnMOjCgT+9e6t1SBLiJbYjS8Z6fg7SKefCRPKXVc/IqRj2y/9ZF9omSls345YSIvwamxAKuV7slISvruxlN6WrcO2seFt1Tt1HBPJnG28I3DWo1Eq7GmBHkAWnn58xQQwdaoRYBQaCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xinDwrmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xinDwrmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB081F000FF;
	Thu, 17 Sep 2026 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665093;
	bh=LqmHy1B+JGfgR6JS1M6Utqc7gQc37DapGo8el4b4FW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xinDwrmvkU/y6h3LMale2MZcyuEyXzzMgB/qgkNvUvbjvXcxxy1rfO/KtyedLs2Ke
	 uPlW9tPiObxtlzoOgRBYMM6s0c7b8XcjQufR11H0l4tbJkFEruL1BgKVv2fud1rLZD
	 lI1CugGfdzmCGz/0LmIcibWMzr7QeV5YNqylzNJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0589/1250] bpf: Guard __get_user acesss with access_ok for uprobe_multi data
Date: Thu, 17 Sep 2026 16:06:24 +0100
Message-ID: <20260917151607.849334908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 22d779ae345d0..e692d67907e49 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3168,6 +3168,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	unsigned long __user *uoffsets;
 	u64 __user *ucookies;
 	void __user *upath;
+	unsigned long size;
 	u32 flags, cnt, i;
 	struct path path;
 	char *name;
@@ -3205,6 +3206,16 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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



