Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BD816423;
	Tue, 27 Feb 2024 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042542; cv=none; b=DGX5BKglH5JgsgD20fPelnsfzclhWbPSKZiW8+X2yw7h7nkurCz+fLAw7ShhLc/WFRSDSLYtZlKYy2y7y+fpFH5VhRuHqzD7vod9Ui9FnObmHoO79Jf/dRcVMYdsnPriDFGMVyzR/vbjrbeCAGEz/Ak08hrdK39CeHoLCYYJRSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042542; c=relaxed/simple;
	bh=SvuLVW29o/YcF7m/pDAW+PWeaH3+NU8lbGC/AUrM9DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mreg7+L506SHnWxwjH7hi2J5b9AAIbRgSwJPsMSrkkJHqBj5y9XVrVqf6v6ycvW9J60YdG5b/LJizkF5OuogL6Im3kYWF9UtwLmPEYomcf04FJk+L6sbPh++U8dO9rgjJIaB4dvfLU35Jn8wj2BIvPPT88+HXFC6ErFbLn8E4Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQGjdeKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQGjdeKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B52C433F1;
	Tue, 27 Feb 2024 14:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042542;
	bh=SvuLVW29o/YcF7m/pDAW+PWeaH3+NU8lbGC/AUrM9DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQGjdeKbQbrTi5gZG8T18UpcGdvU8EjANm6Wz+1OC9f/5r1nYsrYVVwTvB7xq5KAj
	 EdkXegn4LQgqdqcbicWKHjj1OYmZ1cTRsCJGlFg3O2+eMgPW/z4lwvi7dW3ZLeOW38
	 7ET5MPJQxiS3tAtKx+CJggoWRmaNdDTjhf5bppXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 009/245] bpf: Merge printk and seq_printf VARARG max macros
Date: Tue, 27 Feb 2024 14:23:17 +0100
Message-ID: <20240227131615.411970481@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Marchevsky <davemarchevsky@fb.com>

commit 335ff4990cf3bfa42d8846f9b3d8c09456f51801 upstream.

MAX_SNPRINTF_VARARGS and MAX_SEQ_PRINTF_VARARGS are used by bpf helpers
bpf_snprintf and bpf_seq_printf to limit their varargs. Both call into
bpf_bprintf_prepare for print formatting logic and have convenience
macros in libbpf (BPF_SNPRINTF, BPF_SEQ_PRINTF) which use the same
helper macros to convert varargs to a byte array.

Changing shared functionality to support more varargs for either bpf
helper would affect the other as well, so let's combine the _VARARGS
macros to make this more obvious.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210917182911.2426606-2-davemarchevsky@fb.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    2 ++
 kernel/bpf/helpers.c     |    4 +---
 kernel/trace/bpf_trace.c |    4 +---
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2290,6 +2290,8 @@ void bpf_arch_poke_desc_update(struct bp
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
 
+#define MAX_BPRINTF_VARARGS		12
+
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 **bin_buf, u32 num_args);
 void bpf_bprintf_cleanup(void);
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -979,15 +979,13 @@ out:
 	return err;
 }
 
-#define MAX_SNPRINTF_VARARGS		12
-
 BPF_CALL_5(bpf_snprintf, char *, str, u32, str_size, char *, fmt,
 	   const void *, data, u32, data_len)
 {
 	int err, num_args;
 	u32 *bin_args;
 
-	if (data_len % 8 || data_len > MAX_SNPRINTF_VARARGS * 8 ||
+	if (data_len % 8 || data_len > MAX_BPRINTF_VARARGS * 8 ||
 	    (data_len && !data))
 		return -EINVAL;
 	num_args = data_len / 8;
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -414,15 +414,13 @@ const struct bpf_func_proto *bpf_get_tra
 	return &bpf_trace_printk_proto;
 }
 
-#define MAX_SEQ_PRINTF_VARARGS		12
-
 BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
 	   const void *, data, u32, data_len)
 {
 	int err, num_args;
 	u32 *bin_args;
 
-	if (data_len & 7 || data_len > MAX_SEQ_PRINTF_VARARGS * 8 ||
+	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
 	    (data_len && !data))
 		return -EINVAL;
 	num_args = data_len / 8;


