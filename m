Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C671D223C;
	Wed,  2 Oct 2024 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880679; cv=none; b=k8cY3szOB27SjzCcJT1o1r6fze4g1dxyhoBh4MJjV7J1f5uCPpg3HHXK62rwCVReRId3Aul6aOvqvzHubS3uuSevcKqM4EXOFB05on/f/qXhb8XD0Qd78mp0C1z0cFmuKs3wrj8G48b+7ww0GnNN/xrhAiWZqjQpY5jPVRfZxNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880679; c=relaxed/simple;
	bh=qAK6h08ofvC+Vth9KguoJsdyGt3KaaClVIItv8YXtKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYSnFrBD3rtyrstk3IiITF+9LRaW5f9c2GkZbiLaq4+rT4edZFVbkif1EApV0JOwapJKQvCoWfjNIqe+ZoAkfiRb/FqGAlinjOLjmwak3r/XJIcRfnvsLRpbol0L889/OxS6cNlz7825OU0zTz7SZ2xLaTzgVfKgeAPrn2HR+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGE8+VVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGE8+VVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D41C4CED8;
	Wed,  2 Oct 2024 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880679;
	bh=qAK6h08ofvC+Vth9KguoJsdyGt3KaaClVIItv8YXtKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGE8+VVt1TMLFgmIoIbBhclR6iBUWnew4BQI63EXl14xN+kKuD612bjcvJCIlMuVs
	 6rzhwt3DWmjbcV1p7jMUI8pUhMU43Ekj1vPd9BjnPMweAW4dJaEoZAkXETtp4U/1jO
	 i5m4F7Zqr6J8Vxxp3F5SfswAB810WhscXOZCIJjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 534/538] libbpf: Ensure undefined bpf_attr field stays 0
Date: Wed,  2 Oct 2024 15:02:53 +0200
Message-ID: <20241002125813.523026735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin KaFai Lau <martin.lau@kernel.org>

commit c9f115564561af63db662791e9a35fcf1dfefd2a upstream.

The commit 9e926acda0c2 ("libbpf: Find correct module BTFs for struct_ops maps and progs.")
sets a newly added field (value_type_btf_obj_fd) to -1 in libbpf when
the caller of the libbpf's bpf_map_create did not define this field by
passing a NULL "opts" or passing in a "opts" that does not cover this
new field. OPT_HAS(opts, field) is used to decide if the field is
defined or not:

	((opts) && opts->sz >= offsetofend(typeof(*(opts)), field))

Once OPTS_HAS decided the field is not defined, that field should
be set to 0. For this particular new field (value_type_btf_obj_fd),
its corresponding map_flags "BPF_F_VTYPE_BTF_OBJ_FD" is not set.
Thus, the kernel does not treat it as an fd field.

Fixes: 9e926acda0c2 ("libbpf: Find correct module BTFs for struct_ops maps and progs.")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240124224418.2905133-1-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -192,7 +192,7 @@ int bpf_map_create(enum bpf_map_type map
 	attr.btf_key_type_id = OPTS_GET(opts, btf_key_type_id, 0);
 	attr.btf_value_type_id = OPTS_GET(opts, btf_value_type_id, 0);
 	attr.btf_vmlinux_value_type_id = OPTS_GET(opts, btf_vmlinux_value_type_id, 0);
-	attr.value_type_btf_obj_fd = OPTS_GET(opts, value_type_btf_obj_fd, -1);
+	attr.value_type_btf_obj_fd = OPTS_GET(opts, value_type_btf_obj_fd, 0);
 
 	attr.inner_map_fd = OPTS_GET(opts, inner_map_fd, 0);
 	attr.map_flags = OPTS_GET(opts, map_flags, 0);


