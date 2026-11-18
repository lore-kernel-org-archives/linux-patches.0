Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020996;
	b=dGcy809mQPemcFvpcircFmYoXXmV5d2mxXJR389RnPUONoPCvBQ39A/W74t4eELbRKH1
	 fmYSpgIw5uUvg+JJsrqNr8mU7bf+yBRkoBx3Zr6cZEA6OpBqkdzEcuUw67Igh/5LNExdc
	 8xsFMAEQXwyMbmu64W8N3CAXzYq2Cpa5QLsq0w/z6bmL7lnAgSmX8tfPxyQb8HbCV+4uf
	 d11M8vLyuzhuoda9ntsLs2BdbbKoXOZAmHiNOyF23AoE2srH2K4uF0f/S6n8FUb3Wd03W
	 5HZ9bEWfhkQniHKnBITVuV7vtL35LBnvVqT4FvFrp57V1LNDBbv72jK6tF84GG1Y2MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZA6G/hF9po+yyHZ7TTDWi7C7APQh7gX45NVkLuj+64I=;
	b=dSy+TczRuCDejwYwQrjtwv1hh/lkzAYZtNY4PKY21xTT5KvD/mo3O+bFDpwU/zypucNe
	 07F02/h5EpRQp9/1XKKsBQU80UWBtFqX3ZwT6bicjnvtYQYq/vW7YXrT3DGrBaz0i0kj3
	 9X40w3PeZNhQeLuo1u8EP5GxknBMU6nHBhQ2I8HhTZocDN/UEqo1W5TFLrQtTTxbluwj2
	 E/lswRAHE86nkCJ7VSxxyMRrRw8lkhAjJyicddnElc0LGL0sYbq3AQwqkkESxPMHyqYnZ
	 fAw6NGD9snEV/j28cSxVaDyvE7Rcftqsnq3of4HhnrLAPlfPl/dLCaCjVeiGNz3mFyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqq98pbx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D824606A31C;
	Wed, 18 Nov 2026 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqq98pbx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4831F000C4;
	Wed, 18 Nov 2026 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020996;
	bh=ZA6G/hF9po+yyHZ7TTDWi7C7APQh7gX45NVkLuj+64I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqq98pbx/6c/JQFG40iQda9EljtUtgqIoaGVTkv+GQMNvhNDacTpvJhihKu/2aib0
	 Fx8PwMBoATC6j96DKPynNthRU3Qe8gR8+31/amSirW36ZmniiT+eU7IGswB7XMJkDU
	 +8Tkx7PvQ2OXyS8jM3TgFfU4uwQ/b2TTkOlPbsTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masoud Aghasi <maghasi@disroot.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2151/2651] bpf: Fix incorrect handling of user flags by percpu hash map updates
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150403.272144764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masoud Aghasi <maghasi@disroot.org>

[ Upstream commit 4a9b25fe8d138f2e0e65b337ecf829ce7ce42d09 ]

For BPF_MAP_TYPE_PERCPU_HASH and BPF_MAP_TYPE_LRU_PERCPU_HASH maps,
htab_map_check_update_flags() and check_flags() are not considering
the possibility of a combination of (BPF_NOEXIST, BPF_EXIST) flags
with (BPF_F_CPU, BPF_F_ALL_CPUS) flags. This causes the
(BPF_NOEXIST, BPF_EXIST) flags to lose their effect in some cases.

For example, when using (BPF_F_CPU | BPF_EXIST) or
(BPF_F_CPU | BPF_NOEXIST) flag combinations with bpf_map_update_elem()
on a percpu hash map, the BPF_EXIST flag does not prevent new
insertions as expected and BPF_NOEXIST flag does not prevent
modification of existing entries as expected.

This patch fixes the bug by adding proper flag validations and checks.
Before this patch, htab_map_check_update_flags() rejected
(BPF_F_ALL_CPUS | BPF_EXIST) and (BPF_F_ALL_CPUS | BPF_NOEXIST) with
-EINVAL. After the patch those combinations are accepted.

This patch also starts returning -EINVAL for (BPF_EXIST | BPF_NOEXIST),
with or without BPF_F_CPU, which was previously accepted.

Fixes: c6936161fd55 ("bpf: Add BPF_F_CPU and BPF_F_ALL_CPUS flags support for percpu_hash and lru_percpu_hash maps")
Signed-off-by: Masoud Aghasi <maghasi@disroot.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://patch.msgid.link/20261008120734.1565972-3-maghasi@disroot.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 02523a6f0bdc5..b2b27f87d8f55 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1186,11 +1186,11 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
 		       u64 map_flags)
 {
-	if (l_old && (map_flags & ~BPF_F_LOCK) == BPF_NOEXIST)
+	if (l_old && (map_flags & BPF_NOEXIST))
 		/* elem already exists */
 		return -EEXIST;
 
-	if (!l_old && (map_flags & ~BPF_F_LOCK) == BPF_EXIST)
+	if (!l_old && (map_flags & BPF_EXIST))
 		/* elem doesn't exist, cannot update it */
 		return -ENOENT;
 
@@ -1377,9 +1377,11 @@ static long htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value
 
 static int htab_map_check_update_flags(bool onallcpus, u64 map_flags)
 {
+	if (unlikely((map_flags & BPF_EXIST_FLAGS) == BPF_EXIST_FLAGS))
+		return -EINVAL;
 	if (unlikely(!onallcpus && map_flags > BPF_EXIST))
 		return -EINVAL;
-	if (unlikely(onallcpus && ((map_flags & BPF_F_LOCK) || (u32)map_flags > BPF_F_ALL_CPUS)))
+	if (unlikely(onallcpus && ((u32)map_flags & ~(BPF_EXIST_FLAGS | BPF_CPU_FLAGS))))
 		return -EINVAL;
 	return 0;
 }
@@ -1477,7 +1479,7 @@ static long __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	 * to remove older elem from htab and this removal
 	 * operation will need a bucket lock.
 	 */
-	if (map_flags != BPF_EXIST) {
+	if (!(map_flags & BPF_EXIST)) {
 		l_new = prealloc_lru_pop(htab, key, hash);
 		if (!l_new)
 			return -ENOMEM;
-- 
2.53.0



