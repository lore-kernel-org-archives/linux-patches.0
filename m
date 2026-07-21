Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7E1372EEF;
	Tue, 21 Jul 2026 20:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665964; cv=none; b=mv5EVNoK8soHuptBD3nu/mEKsN/er7PvMdw24Dvau54BCoqbQCOclLZ1sbCEzYR+0GuWiBa/fIe5m9r3zyY22CvM49lma7brK+dOhZuhkylRj7TEm6oIrmXtFZ+Nqe7tAy9VT/3Tf2/HaqE192sgYVvVgZgu23rENIe7BFeDsXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665964; c=relaxed/simple;
	bh=YsRMebx99eC3QnAqm9Cp8baG3vS+fXqFX/CQOCULpw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3JsbTSXUsAK/722dsivlagJ8jMmyqxZl6VSrjdPRvOE29EOCyeULf0ADC1yWvGtu/fJI3kmdqPbPwklQHzk1jVtEBkL3t7B5aygqMtZXym6fEX6h1FKtb++BnH/zWG1E82xZJr6zMShcBwjQmJUAmRee4yueWzMbthQ3FVXfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pBAJWlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pBAJWlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBCB1F000E9;
	Tue, 21 Jul 2026 20:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665963;
	bh=bLHC4M89PhYZ5LkjoxdVc1LQyx88qoBe1cYjSygb6kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pBAJWlvdvjCuUxaFt8exqTQMLB3/mL4T12wea78r8mII6ISe7vEoPYzEi8uGtrXN
	 knRIhCHuePSXMOspxML+1/T08vf3wakpDJ7DEQ+0rjX9LGhJ699Q0cycNAuVvC+Hv+
	 2T2gyLe+podmSqoJmhKprrUYCLVvCE0joqn1PavI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0501/1266] bpf: Check tail zero of bpf_prog_info
Date: Tue, 21 Jul 2026 17:15:38 +0200
Message-ID: <20260721152453.052091194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 786be2b05980a5828e67fc564ad7517e2adbe9bd ]

Since there're 4 bytes padding at the end of struct bpf_prog_info, they
won't be checked by bpf_check_uarg_tail_zero().

pahole -C bpf_prog_info ./vmlinux
struct bpf_prog_info {
	...
	__u32                      attach_btf_obj_id;    /*   220     4 */
	__u32                      attach_btf_id;        /*   224     4 */

	/* size: 232, cachelines: 4, members: 38 */
	/* sum members: 224 */
	/* sum bitfield members: 1 bits, bit holes: 1, sum bit holes: 31 bits */
	/* padding: 4 */
	/* forced alignments: 9 */
	/* last cacheline: 40 bytes */
} __attribute__((__aligned__(8)));

If a future kernel extension adds a new 4-byte field, older userspace
programs allocating this structure on the stack might inadvertently pass
uninitialized stack garbage into the new field, permanently breaking
backward compatibility. -- sashiko [1]

Fix it by changing sizeof(info) to
offsetofend(struct bpf_prog_info, attach_btf_id).

And, add "__u32 :32" to the tail of struct bpf_prog_info.

[1] https://lore.kernel.org/bpf/20260513224823.6494FC19425@smtp.kernel.org/

Fixes: aba64c7da983 ("bpf: Add verified_insns to bpf_prog_info and fdinfo")
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20260605155249.20772-3-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 1 +
 kernel/bpf/syscall.c           | 5 +++--
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6950169329ef1e..a1e17df7c49ada 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6460,6 +6460,7 @@ struct bpf_prog_info {
 	__u32 verified_insns;
 	__u32 attach_btf_obj_id;
 	__u32 attach_btf_id;
+	__u32 :32;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2207f9e7a56742..5fa86a2ab14a6b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4403,10 +4403,11 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	u32 info_len = attr->info.info_len;
 	struct bpf_prog_kstats stats;
 	char __user *uinsns;
-	u32 ulen;
+	u32 ulen, len;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), sizeof(info), info_len);
+	len = offsetofend(struct bpf_prog_info, attach_btf_id);
+	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), len, info_len);
 	if (err)
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8967952de0c2ee..d3b14f18c78f6b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6463,6 +6463,7 @@ struct bpf_prog_info {
 	__u32 verified_insns;
 	__u32 attach_btf_obj_id;
 	__u32 attach_btf_id;
+	__u32 :32;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
-- 
2.53.0



