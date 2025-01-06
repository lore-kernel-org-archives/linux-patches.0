Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848142A9B;
	Mon,  6 Jan 2025 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177514; cv=none; b=OaRytJ3WwczMz8AqxVWlgkewn8Mq1V8Kcn9xooFabh/rZUXBYTyUyRJ5x2+T7gGz8CpORY0Ldx+wea8cixEgdxCVbkegmF3cWjprQ2W7OS33xRQJtpM4zBjfP9oj+4lPdZjmx1x7xLx49hrKCrZKy6GkAomjMR9ZGVVD8s3odPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177514; c=relaxed/simple;
	bh=PyAjhoj7wB9dcQi0zKENVmVaOCXZ6JEAwQbCaUP6fVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpC9qmHdg/4JLyju+uN/t28bMkGdPTcg1o50dAupG0QjlTjqk8U9u+zEeffbelrLY0f0a3MF+dK6qpisdUhrq8+JVle4KsOs6qJ9pD8iIPzT0XwCHiZKSS88OW8lks5P888nVXTvqU1r09z5ePMS+wDoc59JgTPeLfISji5HS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzNBD/ED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzNBD/ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6097C4CED2;
	Mon,  6 Jan 2025 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177513;
	bh=PyAjhoj7wB9dcQi0zKENVmVaOCXZ6JEAwQbCaUP6fVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzNBD/EDAlvl8G3B00kvt5zAKztlu7SkeEvXdIcMGo6L/Q+eL0stoBv8tBAnAdm2u
	 sfpenUFO9NCAPlnquO+jc9z3oHSeaV/uaJi1O3+G760V8yt1Z4wjzXm3dtkbfIdayc
	 NlrMIiJBMAVqYNnOlD65mnPRd5lC2VkCuCmnyN0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/222] bpf: fix potential error return
Date: Mon,  6 Jan 2025 16:16:30 +0100
Message-ID: <20250106151157.806038995@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Anton Protopopov <aspsk@isovalent.com>

[ Upstream commit c4441ca86afe4814039ee1b32c39d833c1a16bbc ]

The bpf_remove_insns() function returns WARN_ON_ONCE(error), where
error is a result of bpf_adj_branches(), and thus should be always 0
However, if for any reason it is not 0, then it will be converted to
boolean by WARN_ON_ONCE and returned to user space as 1, not an actual
error value. Fix this by returning the original err after the WARN check.

Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241210114245.836164-1-aspsk@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 58ee17f429a3..02f327f05fd6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -529,6 +529,8 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 
 int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 {
+	int err;
+
 	/* Branch offsets can't overflow when program is shrinking, no need
 	 * to call bpf_adj_branches(..., true) here
 	 */
@@ -536,7 +538,9 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
 		sizeof(struct bpf_insn) * (prog->len - off - cnt));
 	prog->len -= cnt;
 
-	return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
+	err = bpf_adj_branches(prog, off, off + cnt, off, false);
+	WARN_ON_ONCE(err);
+	return err;
 }
 
 static void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
-- 
2.39.5



