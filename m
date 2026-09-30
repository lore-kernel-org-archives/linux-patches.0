Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01104E36F1;
	Wed, 30 Sep 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792278; cv=none; b=m3eOC2pMrBVdCdPMJdoBgP2dRIpcYrt7sJ8i+6dJAry/r+/2+aGR5H9vy4iOZSwfmtNvktF9zl3A0iMnYwqqtCNRJQfuN8lN0Sjj7ACufww9ROR4RyOtikp2X6icXA0CFIF4RvveKzwNLbYjFnh/3Sq9RaQb2kpa4qGYJvlTwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792278; c=relaxed/simple;
	bh=A7TW6GVOTpbC0YmlX8gwO8b9tsQc/numITWGSE0d1o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2Q8zBWdzQWg+71GCQOvzt4FFnDrTURZcTcDNFylZXmYGC6xxSJMWDWsmxhVp52s/Po3WMPmGg3iBVWjGgXjvvji/nDBDFDIXWpPWQsFMs6QrTOIoD4q94MgGOkEuUypkDy/zbKxYKI5CdL+NWu1yPRAG+xPjE8QjZAnDn9izYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5uzBQTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5uzBQTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C561F000FF;
	Wed, 30 Sep 2026 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792276;
	bh=mF4mWjZOyfDGosz+MJzMqBULrj6iIbeH0n1KelnRmcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5uzBQTjePU4KtCa1478MLUIkoM5IQZUMTj9Qv8wdi2vKqVvlcH1ayF2GCjJvm9es
	 3MeRJhh2HTY7J9RDCChnnl7odFXCPiUyQmXeAH/dPa9F28EUFd/HWA+5ODm6m1Vjo+
	 BdADQ91XKeEgpjEaUMPLdwUMTuLPHJX6F7nG9xBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 596/752] bpf: support access variable length array of integer type
Date: Wed, 30 Sep 2026 17:27:46 +0200
Message-ID: <20260930152411.183645723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Zhou <zhoufeng.zf@bytedance.com>

[ Upstream commit 2569c7b8726fc06d946a4f999fb1be15b68f3f3c ]

After this commit:
bpf: Support variable length array in tracing programs (9c5f8a1008a1)
Trace programs can access variable length array, but for structure
type. This patch adds support for integer type.

Example:
Hook load_balance
struct sched_domain {
	...
	unsigned long span[];
}

The access: sd->span[0].

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Link: https://lore.kernel.org/r/20230420032735.27760-2-zhoufeng.zf@bytedance.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: b0b3dc665296 ("bpf: Fix divide-by-zero in btf_struct_walk()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 27fc64e8be00d..7a233feeac8d6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4960,11 +4960,13 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		if (off < moff)
 			goto error;
 
-		/* Only allow structure for now, can be relaxed for
-		 * other types later.
-		 */
+		/* allow structure and integer */
 		t = btf_type_skip_modifiers(btf, array_elem->type,
 					    NULL);
+
+		if (btf_type_is_int(t))
+			return WALK_SCALAR;
+
 		if (!btf_type_is_struct(t))
 			goto error;
 
-- 
2.53.0



