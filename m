Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067403F2101;
	Tue, 21 Jul 2026 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659931; cv=none; b=jyU0es9NEFs/iRWgDeUTIL7JO4dswkyXH2hrFtcN+d0cwI7fw825xlNRM20BR11fojiu4rAw6fKAbWrBtlvx4atOKzTYBAJ1WehlPLxy6s9S5vbrGP2JKFZpQQA17KsCzaCXfctwEpLal/CiF3svp5ugSex0NvHi4HVo3owpQ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659931; c=relaxed/simple;
	bh=fRxt4sfQxpNuJT8Blvwxx0eZL391p/gLft4c2itZz/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVL9nUkATiiYchkbgU8R4fVvmMijMJyteo83W5bbHT38KBGJZcOj+eOecPXydc+k3/gVYlK1+6fJZApAEs5w4/DbzZ+9vZq2PtuYJu6QaaK34Ly5gGayJpdB5Q5kgn0R8qLWwN45bCsT0GZnLvIHCV0BtPwMl6UrP1enOk/g1Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVboc6Fj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVboc6Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668931F000E9;
	Tue, 21 Jul 2026 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659929;
	bh=Eth7TVKKPrvGki05WlEnTyusYLTxB011JG7aLLLlLbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVboc6Fji1kl5cEePKfRzHDAHyMHejtpOQhDtIBl+8Pk9qaBxzIW+ncAlJWElazJM
	 7QWZCBSpJQqz6B6YgW5bg4hkHnJRslA9kfvvZcIymZS/fzKo6NKyNqCHmFgKfTOCYG
	 oRNcP+hDcsi7j0hoYk5aHVblxiGZhiYZoZChihW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0780/2077] bpf: Guard __get_user acesss with access_ok for uprobe_multi data
Date: Tue, 21 Jul 2026 17:07:33 +0200
Message-ID: <20260721152611.195223838@linuxfoundation.org>
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
index a02bd258677ee1..a4de502950c4b9 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3180,6 +3180,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	unsigned long __user *uoffsets;
 	u64 __user *ucookies;
 	void __user *upath;
+	unsigned long size;
 	u32 flags, cnt, i;
 	struct path path;
 	char *name;
@@ -3217,6 +3218,16 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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



