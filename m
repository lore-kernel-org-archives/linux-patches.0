Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DE318800D;
	Tue, 30 Jul 2024 16:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355553; cv=none; b=plBJ724DPovw4yaFFSDeWgFLXkE0fOLqnaJ82CcZu3OzqNRo95pLRaWJ4mDt3eJwYXTQm5sGDDV2TXmlN9RV1Hko+qa9rDTYKweBGQHv5pneNbLWd5VOMtk3eIGmXc6PPjnOnu0EATE3LKjfNISqV9CI70zKSXT5X7WaE+SWrVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355553; c=relaxed/simple;
	bh=MKVv9jbVJOj7V3SNAqaTPihD8Y9HV0Ztdl5Msc8Cecs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vwz+HQkom4eHHsfWWLIuhe5TF3eDzrGx6XG5gE41jvRWNTzh0SILNgv0k+RNzytpAa8fPqHyrCwLySf67N68fszhxvaN9ULHO1YJnNkdHq7D2LQFTWu1fVpVtfLwc2/ZloSv7HvVjjRoS/UnZ7/dKfT9tMw+M0bNbDfIgHilzu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH+EvgAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH+EvgAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55152C4AF0A;
	Tue, 30 Jul 2024 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355553;
	bh=MKVv9jbVJOj7V3SNAqaTPihD8Y9HV0Ztdl5Msc8Cecs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH+EvgAn+2rKpM97ereAEoSnnhDILnuHgDEmi2dXK2f+YyjZduWVdi8SHrmrK1bC0
	 hpFS4VDC90/uvNEWG8ileo3NyQtyroc/q3q9xWmk3qelL+j5zpBZ3wOt8e3Fl7ZLk3
	 WKjz2IZqBfgMDc95CEpk1WQts3TQc4ACsNr/meUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donglin Peng <dolinux.peng@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/440] libbpf: Checking the btf_type kind when fixing variable offsets
Date: Tue, 30 Jul 2024 17:45:38 +0200
Message-ID: <20240730151619.990462491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donglin Peng <dolinux.peng@gmail.com>

[ Upstream commit cc5083d1f3881624ad2de1f3cbb3a07e152cb254 ]

I encountered an issue when building the test_progs from the repository [1]:

  $ pwd
  /work/Qemu/x86_64/linux-6.10-rc2/tools/testing/selftests/bpf/

  $ make test_progs V=1
  [...]
  ./tools/sbin/bpftool gen object ./ip_check_defrag.bpf.linked2.o ./ip_check_defrag.bpf.linked1.o
  libbpf: failed to find symbol for variable 'bpf_dynptr_slice' in section '.ksyms'
  Error: failed to link './ip_check_defrag.bpf.linked1.o': No such file or directory (2)
  [...]

Upon investigation, I discovered that the btf_types referenced in the '.ksyms'
section had a kind of BTF_KIND_FUNC instead of BTF_KIND_VAR:

  $ bpftool btf dump file ./ip_check_defrag.bpf.linked1.o
  [...]
  [2] DATASEC '.ksyms' size=0 vlen=2
        type_id=16 offset=0 size=0 (FUNC 'bpf_dynptr_from_skb')
        type_id=17 offset=0 size=0 (FUNC 'bpf_dynptr_slice')
  [...]
  [16] FUNC 'bpf_dynptr_from_skb' type_id=82 linkage=extern
  [17] FUNC 'bpf_dynptr_slice' type_id=85 linkage=extern
  [...]

For a detailed analysis, please refer to [2]. We can add a kind checking to
fix the issue.

  [1] https://github.com/eddyz87/bpf/tree/binsort-btf-dedup
  [2] https://lore.kernel.org/all/0c0ef20c-c05e-4db9-bad7-2cbc0d6dfae7@oracle.com/

Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
Signed-off-by: Donglin Peng <dolinux.peng@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20240619122355.426405-1-dolinux.peng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 4ac02c28e152a..8a7cb830bff14 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -2189,10 +2189,17 @@ static int linker_fixup_btf(struct src_obj *obj)
 		vi = btf_var_secinfos(t);
 		for (j = 0, m = btf_vlen(t); j < m; j++, vi++) {
 			const struct btf_type *vt = btf__type_by_id(obj->btf, vi->type);
-			const char *var_name = btf__str_by_offset(obj->btf, vt->name_off);
-			int var_linkage = btf_var(vt)->linkage;
+			const char *var_name;
+			int var_linkage;
 			Elf64_Sym *sym;
 
+			/* could be a variable or function */
+			if (!btf_is_var(vt))
+				continue;
+
+			var_name = btf__str_by_offset(obj->btf, vt->name_off);
+			var_linkage = btf_var(vt)->linkage;
+
 			/* no need to patch up static or extern vars */
 			if (var_linkage != BTF_VAR_GLOBAL_ALLOCATED)
 				continue;
-- 
2.43.0



