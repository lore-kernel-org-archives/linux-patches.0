Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B76F32A3FD;
	Wed,  8 Apr 2026 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673730; cv=none; b=rnTz1nkGivPECpT+GlO8XHJEiexpJgd6XLWe+TeU/I2alltFTbsrp0heEck0MVIN3A2wC/LxYeebSzvFlS5zASR8nq25WbzPYWR3FPuz7zsmWpB08UhAKAj8o1DsmMMZDEVoRvnYNHCjfTulHmnSkPsbyditrvQoOVOAAGtyrQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673730; c=relaxed/simple;
	bh=w+t9hBl6EFZZGh7J3bqXIIMdz4QSnj23u0IWd7dcMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYzvHWSTA2PoFNkcnNWzmPA91Z6RnQz/1waAdsMzbX4Myqga1D8GG/0+UPW6ZLqGYxMVQooFHNlOCh1lFJZu4YjtdGSe2cDBTI3AnAcs3oWqmVcCWHisZQ2eh0lp6cVLO0Qq/HRjOQ8pyTKdbmTrc8RhDen3DzPYTvqaslhZhjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY5VYY3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY5VYY3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5545C19421;
	Wed,  8 Apr 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673730;
	bh=w+t9hBl6EFZZGh7J3bqXIIMdz4QSnj23u0IWd7dcMUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eY5VYY3ohGUOPUjtglaguzTMl72j1XmPH/ZPCtw9kmYNSiFo2+tj6WQwEQoy0DIdj
	 nTfp92U841HBd9oZHLiHyMrYUTklAfi2ok7LQP467qjg+xurnNf5QpIdlfofvpN/fe
	 83VOaAQL144wb55OCM5rd4U8gdMfCRxzIvGRQfSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amery Hung <ameryhung@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/242] bpf: Fix regsafe() for pointers to packet
Date: Wed,  8 Apr 2026 20:01:46 +0200
Message-ID: <20260408175929.554461261@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit a8502a79e832b861e99218cbd2d8f4312d62e225 ]

In case rold->reg->range == BEYOND_PKT_END && rcur->reg->range == N
regsafe() may return true which may lead to current state with
valid packet range not being explored. Fix the bug.

Fixes: 6d94e741a8ff ("bpf: Support for pointers beyond pkt_end.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260331204228.26726-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 68fa30852051e..9bdc19587948c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17562,8 +17562,13 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		 * since someone could have accessed through (ptr - k), or
 		 * even done ptr -= k in a register, to get a safe access.
 		 */
-		if (rold->range > rcur->range)
+		if (rold->range < 0 || rcur->range < 0) {
+			/* special case for [BEYOND|AT]_PKT_END */
+			if (rold->range != rcur->range)
+				return false;
+		} else if (rold->range > rcur->range) {
 			return false;
+		}
 		/* If the offsets don't match, we can't trust our alignment;
 		 * nor can we be sure that we won't fall out of range.
 		 */
-- 
2.53.0



