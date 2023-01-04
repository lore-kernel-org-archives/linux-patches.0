Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA8AAD4A
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7B1C433EF;
	Wed,  4 Jan 2023 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848924;
	bh=mGSh9eD/uBxDhYwTsygjqT70qM2KkKgmt1JdTkw1AzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cdv0MH3atn3bFBYNTGTwkjAfLA8Tllx0kjolYzInmgd4j9o0WdkYgJFOMRsZzDr+p
	 yi/ujE6q0sLqTIBM3Sl93tPCMg07vyunAMM4+UkZS59v6hLsGxEt5FlAE20JbiM/tl
	 owpWwxLAMZ1vaZ+4RT0DhiY3WmorF+VxUtMw66NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yhs@fb.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 035/177] bpf: Resolve fext program type when checking map compatibility
Date: Wed,  4 Jan 2023 17:05:26 +0100
Message-Id: <20230104160508.725899862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 1c123c567fb138ebd187480b7fc0610fcb0851f5 ]

The bpf_prog_map_compatible() check makes sure that BPF program types are
not mixed inside BPF map types that can contain programs (tail call maps,
cpumaps and devmaps). It does this by setting the fields of the map->owner
struct to the values of the first program being checked against, and
rejecting any subsequent programs if the values don't match.

One of the values being set in the map owner struct is the program type,
and since the code did not resolve the prog type for fext programs, the map
owner type would be set to PROG_TYPE_EXT and subsequent loading of programs
of the target type into the map would fail.

This bug is seen in particular for XDP programs that are loaded as
PROG_TYPE_EXT using libxdp; these cannot insert programs into devmaps and
cpumaps because the check fails as described above.

Fix the bug by resolving the fext program type to its target program type
as elsewhere in the verifier.

v3:
- Add Yonghong's ACK

Fixes: f45d5b6ce2e8 ("bpf: generalise tail call map compatibility check")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221214230254.790066-1-toke@redhat.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 2 +-
 kernel/bpf/core.c            | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 184b957e28ad..1eac74cacc96 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -634,7 +634,7 @@ static inline u32 type_flag(u32 type)
 }
 
 /* only use after check_attach_btf_id() */
-static inline enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
+static inline enum bpf_prog_type resolve_prog_type(const struct bpf_prog *prog)
 {
 	return prog->type == BPF_PROG_TYPE_EXT ?
 		prog->aux->dst_prog->type : prog->type;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c4600a5781de..7d315c94b80a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2088,6 +2088,7 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 bool bpf_prog_map_compatible(struct bpf_map *map,
 			     const struct bpf_prog *fp)
 {
+	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	bool ret;
 
 	if (fp->kprobe_override)
@@ -2098,12 +2099,12 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
-		map->owner.type  = fp->type;
+		map->owner.type  = prog_type;
 		map->owner.jited = fp->jited;
 		map->owner.xdp_has_frags = fp->aux->xdp_has_frags;
 		ret = true;
 	} else {
-		ret = map->owner.type  == fp->type &&
+		ret = map->owner.type  == prog_type &&
 		      map->owner.jited == fp->jited &&
 		      map->owner.xdp_has_frags == fp->aux->xdp_has_frags;
 	}
-- 
2.35.1



