Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B02DF3C9;
	Tue, 17 Jun 2025 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174721; cv=none; b=Nx4Dhvk4wqGz398OOJlfJx8rKmHW1erqDViP802Gx9ok/flez2UjJXDAtR3gMRpPXFHn1snRPsJENzbJ7IQ8m4aazAE5H00So3LKJRPwJKDfshxFd8kFX7rYaIfW5vLHkUfpA6Pz6rVAJeSjjQZ766QBOmUwCZjrTaxgizvAp+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174721; c=relaxed/simple;
	bh=SASNGHRMcFKz2NJluvnZHAqWe/An3dW4c2ddq5Jj5iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj62U1Z6RD75Mezbr0JcRqH0oDgy32/BStcGv7d++IuVz3RTS1djmpLfhyRtcRu4cXGCLUfQHB/EcxrB/s5ZegjpoNQLrqIcTibnMYbQNdpufznSFp6hIkNzCVs/b6zw2Ii0naPBCH+XPoVp8eeHJ7n4IgJj3En3IdZDb26NoII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGrtuCw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGrtuCw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E1C4CEE3;
	Tue, 17 Jun 2025 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174720;
	bh=SASNGHRMcFKz2NJluvnZHAqWe/An3dW4c2ddq5Jj5iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGrtuCw9Vkftv2pQyUk/p/zPEJrI5w6vJU+iTQ7zzW35ga3i5UMq3SB/aqZ5QbHn5
	 bQpkO2DnDTvK8zgP1R9j95ZpyF4N8Tj5sF5rxSDshQVOneKpprmr5b00hdNdlYiIEh
	 E6bDSMnYbji8GxYRHwDaBl2QcUQH8efoGXXGZWoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/356] bpf: Allow XDP dev-bound programs to perform XDP_REDIRECT into maps
Date: Tue, 17 Jun 2025 17:23:40 +0200
Message-ID: <20250617152342.450498864@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 81fd1bb994164..3f140b7527cfc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2258,8 +2258,8 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 }
 #endif
 
-bool bpf_prog_map_compatible(struct bpf_map *map,
-			     const struct bpf_prog *fp)
+static bool __bpf_prog_map_compatible(struct bpf_map *map,
+				      const struct bpf_prog *fp)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	bool ret;
@@ -2268,14 +2268,6 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
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
@@ -2309,6 +2301,19 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
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
@@ -2321,7 +2326,7 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 		if (!map_type_contains_progs(map))
 			continue;
 
-		if (!bpf_prog_map_compatible(map, fp)) {
+		if (!__bpf_prog_map_compatible(map, fp)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.5



