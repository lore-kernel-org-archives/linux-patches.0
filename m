Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A53A374A1E;
	Tue, 21 Jul 2026 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649262; cv=none; b=ULC3Nj24cwsJTMfxyZHV+xxlD5mYFPjapKSxL9lJre1CVoly01AJEpeNtCNNOhTaRMPl1MNYoEFvVrhgkpFMioY/cvaMujEZhY/PV3DW0Qa4btrG8sMUnqOaIhHEGCe5X/HO5+nyxAudtuYk44Axbbx3xLLj8mxpG/fEH8DQq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649262; c=relaxed/simple;
	bh=NUILn3PbDHF4c2C85gf4oVEwg6M32K+e8Fr6F1TWZjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiR02ovXMe1Ofsyy9qUt28fQZvr/VKVwyLGcw/BeOkjWekVyAUwWZDnfuzfY1p0OIcFJcznted3p/4KTJuwSrNVxXdCdE6dEywQQfdQuZqFnLMs59bwcU7rL9kctlttNKGx9x2F/mfNJMQ57YONG9kfmtCIXwY1wYthyIUXCeS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrbKCsck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrbKCsck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0607D1F000E9;
	Tue, 21 Jul 2026 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649260;
	bh=0RfiCtPwriq+q2dp/Ete+qHkk9jwq5LAuk0l+y4au6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrbKCsckeiXlTvH8U8PezvPpOSiKw6QjKLade8BnWV4P1NrXz+VhVkPKq26UqYD++
	 cfPU+0eIDvNgIli/PhdMF8gNgNnYOP4z2aw8I0nsOs34a7UGKfBYskJG5AyZU8u/Qx
	 7GEiGQuOSEbgHG4U+syZ+D3lJiv0sy539aVHEjq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0512/2077] bpf: Check tail zero of bpf_map_info
Date: Tue, 21 Jul 2026 17:03:05 +0200
Message-ID: <20260721152604.889362167@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit e2a49fdb1beed150125b4104c90eb2a96ec7f63a ]

Since there're 4 bytes padding at the end of struct bpf_map_info, they
won't be checked by bpf_check_uarg_tail_zero().

pahole -C bpf_map_info ./vmlinux
struct bpf_map_info {
	...
	__u64                      hash __attribute__((__aligned__(8))); /*    88     8 */
	__u32                      hash_size;            /*    96     4 */

	/* size: 104, cachelines: 2, members: 18 */
	/* padding: 4 */
	/* forced alignments: 1 */
	/* last cacheline: 40 bytes */
} __attribute__((__aligned__(8)));

If a future kernel extension adds a new 4-byte field, older userspace
programs allocating this structure on the stack might inadvertently pass
uninitialized stack garbage into the new field, permanently breaking
backward compatibility. -- sashiko [1]

Fix it by changing sizeof(info) to
offsetofend(struct bpf_map_info, hash_size).

And, add "__u32 :32" to the tail of struct bpf_map_info.

[1] https://lore.kernel.org/bpf/20260513224823.6494FC19425@smtp.kernel.org/

Fixes: ea2e6467ac36 ("bpf: Return hashes of maps in BPF_OBJ_GET_INFO_BY_FD")
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20260605155249.20772-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 1 +
 kernel/bpf/syscall.c           | 5 +++--
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 552bc5d9afbd16..93778d60c760e9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6719,6 +6719,7 @@ struct bpf_map_info {
 	__u64 map_extra;
 	__aligned_u64 hash;
 	__u32 hash_size;
+	__u32 :32;
 } __attribute__((aligned(8)));
 
 struct bpf_btf_info {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2edda1844ec7fd..0be81c6437c24f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5337,10 +5337,11 @@ static int bpf_map_get_info_by_fd(struct file *file,
 {
 	struct bpf_map_info __user *uinfo = u64_to_user_ptr(attr->info.info);
 	struct bpf_map_info info;
-	u32 info_len = attr->info.info_len;
+	u32 info_len = attr->info.info_len, len;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), sizeof(info), info_len);
+	len = offsetofend(struct bpf_map_info, hash_size);
+	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), len, info_len);
 	if (err)
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 677be9a4734768..4b3fecb01852ef 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6719,6 +6719,7 @@ struct bpf_map_info {
 	__u64 map_extra;
 	__aligned_u64 hash;
 	__u32 hash_size;
+	__u32 :32;
 } __attribute__((aligned(8)));
 
 struct bpf_btf_info {
-- 
2.53.0



