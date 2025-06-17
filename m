Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAA42ECEAE;
	Tue, 17 Jun 2025 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176875; cv=none; b=hRCvz8dbGam/bAKAWlo5rm/zwcwUCGaS4hvxngRDXZTeYbzRxjYrExZENmeIb5gkpt6Lrl5vxK4JQsQbqV+k4/7j/tR1d3CEeuXEwwbUc6rnYXAq3UP/C0jWNwwIz5jw20szn6kmvf8TdVje87KaKXwuJ6nRzt4SkeuNF73ko1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176875; c=relaxed/simple;
	bh=HL0Ldza2hJxnD2sBm9IaxsEX/WBNaAmyBEaEkBf+KM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+jHhDqHGhYSMbZDOYB7FCuYrosuk/4zNahl8aZGobj3FtHHqxWLwBYQr7vYjDvrL30FB8PBMQEWVeGUTCcUZdDQPbbQe9/xGynRJD7q1YW+7xHJv2NdDMPPuLXgvD/IllEfdKv3cPcnoN8S2HFIqHnCQppqVxtJO1gN15Nzio4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAMc/QI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAMc/QI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32BEC4CEE3;
	Tue, 17 Jun 2025 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176875;
	bh=HL0Ldza2hJxnD2sBm9IaxsEX/WBNaAmyBEaEkBf+KM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAMc/QI3U72lSJuZJpCxDyXdyczV7oWUq6ruyUUNgkC9+lTWBsRbYtzGPvtN9voQN
	 EUsG2wXFgEgwxPU9Qwn1vbpfoL3x7Qxp3Ao0hqPcbWGgacZM0pfFhQv4DSBHwCLZKp
	 AP/7KyvJ7Z9aOhMRBS+RG4JuvHzYli09WRt4BAGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 234/780] bpf: Allow XDP dev-bound programs to perform XDP_REDIRECT into maps
Date: Tue, 17 Jun 2025 17:19:02 +0200
Message-ID: <20250617152500.988078634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 714070c4cb7a10ff57450a618a936775f3036245 ]

In the current implementation if the program is dev-bound to a specific
device, it will not be possible to perform XDP_REDIRECT into a DEVMAP
or CPUMAP even if the program is running in the driver NAPI context and
it is not attached to any map entry. This seems in contrast with the
explanation available in bpf_prog_map_compatible routine.
Fix the issue introducing __bpf_prog_map_compatible utility routine in
order to avoid bpf_prog_is_dev_bound() check running bpf_check_tail_call()
at program load time (bpf_prog_select_runtime()).
Continue forbidding to attach a dev-bound program to XDP maps
(BPF_MAP_TYPE_PROG_ARRAY, BPF_MAP_TYPE_DEVMAP and BPF_MAP_TYPE_CPUMAP).

Fixes: 3d76a4d3d4e59 ("bpf: XDP metadata RX kfuncs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ba6b6118cf504..a3e5716884211 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2358,8 +2358,8 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 	return 0;
 }
 
-bool bpf_prog_map_compatible(struct bpf_map *map,
-			     const struct bpf_prog *fp)
+static bool __bpf_prog_map_compatible(struct bpf_map *map,
+				      const struct bpf_prog *fp)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	bool ret;
@@ -2368,14 +2368,6 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 	if (fp->kprobe_override)
 		return false;
 
-	/* XDP programs inserted into maps are not guaranteed to run on
-	 * a particular netdev (and can run outside driver context entirely
-	 * in the case of devmap and cpumap). Until device checks
-	 * are implemented, prohibit adding dev-bound programs to program maps.
-	 */
-	if (bpf_prog_is_dev_bound(aux))
-		return false;
-
 	spin_lock(&map->owner.lock);
 	if (!map->owner.type) {
 		/* There's no owner yet where we could check for
@@ -2409,6 +2401,19 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 	return ret;
 }
 
+bool bpf_prog_map_compatible(struct bpf_map *map, const struct bpf_prog *fp)
+{
+	/* XDP programs inserted into maps are not guaranteed to run on
+	 * a particular netdev (and can run outside driver context entirely
+	 * in the case of devmap and cpumap). Until device checks
+	 * are implemented, prohibit adding dev-bound programs to program maps.
+	 */
+	if (bpf_prog_is_dev_bound(fp->aux))
+		return false;
+
+	return __bpf_prog_map_compatible(map, fp);
+}
+
 static int bpf_check_tail_call(const struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
@@ -2421,7 +2426,7 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 		if (!map_type_contains_progs(map))
 			continue;
 
-		if (!bpf_prog_map_compatible(map, fp)) {
+		if (!__bpf_prog_map_compatible(map, fp)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.5



