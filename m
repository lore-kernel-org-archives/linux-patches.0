Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5078D8837;
	Mon, 28 Oct 2024 06:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098361; cv=none; b=aWFI2aamwriIX8fqAfjAdu+Zh6J6JZgpuHPaCiVEYh6JDRsYdztqnI/iq8p08tUhSo0czpUOsrspbsYhVI25jWbki0UiPTdlONWoX3yeoks5KjESHgSujdrupqr9UP66su1LBEhwWXDGL7A65l4j8Mbuw4RuDmonfzN5lByiGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098361; c=relaxed/simple;
	bh=5MMxQU0/BqZz5OrG/7nKrc44FDWoGmpUOTOUlaRXS7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFle67F8+7fevXujF57RncIdgvol15Ld2XFydcEWlqp2ykuBhGIuXjMNn82etaG5DlrXg0K21+7vQA9z6sqd9iYUpV+SaV2UZSmt+7WiyCrjzFDT5VAOFOFln2/WA9sO+qXbWe34aOIN2uOYNqHiGxNN6ip9BSQ72cExnwVSPys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm5iD2a9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm5iD2a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6061C4CEC3;
	Mon, 28 Oct 2024 06:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098361;
	bh=5MMxQU0/BqZz5OrG/7nKrc44FDWoGmpUOTOUlaRXS7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm5iD2a9m0RsTmFmKZsfirfUyz5V7ycKN8AJkXvRHdMmFEA3lBLFl4Usi0mhk8kq7
	 tBZQtZsvwfhD89VzwTO7L3N6NmRB51pznoyFsmegaCqdkGuSQ/jvo3NLHMFfhYo7lD
	 VtnmNHEQkFgpR5fRd7l0pZPOHQUO+flERwmNCb/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 175/261] bpf: fix do_misc_fixups() for bpf_get_branch_snapshot()
Date: Mon, 28 Oct 2024 07:25:17 +0100
Message-ID: <20241028062316.387859903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 9806f283140ef3e4d259b7646bd8c66026bbaac5 ]

We need `goto next_insn;` at the end of patching instead of `continue;`.
It currently works by accident by making verifier re-process patched
instructions.

Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Fixes: 314a53623cd4 ("bpf: inline bpf_get_branch_snapshot() helper")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20241023161916.2896274-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 62efe7f0aa46f..77b60896200ef 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20675,7 +20675,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			delta    += cnt - 1;
 			env->prog = prog = new_prog;
 			insn      = new_prog->insnsi + i + delta;
-			continue;
+			goto next_insn;
 		}
 
 		/* Implement bpf_kptr_xchg inline */
-- 
2.43.0



