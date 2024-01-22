Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0BE634F8;
	Tue, 23 Jan 2024 00:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971262; cv=none; b=F9XnyY7LUsdZB9HFL7oPTnwI3qH6YXVjT9FFF7sX/C6qz+Tq651VaJKW3BPxbQU2u2CPgcr1pbg3CYh7o/iQC0OcTlTTMH1uoeoqZUr2m5FheKmYmsRaAIoqpquU2GOWp/hBMxQODD5DW3uzxr2h33wINCysn0dpPWCbdNLFpgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971262; c=relaxed/simple;
	bh=7F7EouEGhJtKZCMCPtmnN9eKkHm7zvO07RxMgrPMti4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFxibD/fUOV7Ia0+YeidHlQAmLZbskBv4urT+LxSBP2l7RVCGCoEpTi/Xh5ID6bntgJqu/dZ+Y0HM964erYG7+W/Y+Rf5a0cfqDXcvKNFgrpvZpd76i1dfD9LFkP1SAY3Yg9sEiaLIEi/7cDL6ZtYpfVzXuHbG3XZSasrO+7E5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P64VGROx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P64VGROx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AD6C433F1;
	Tue, 23 Jan 2024 00:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971261;
	bh=7F7EouEGhJtKZCMCPtmnN9eKkHm7zvO07RxMgrPMti4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P64VGROx3pupNOJQ/NyVzCK6WvZ8ROBHTFfIK8EfDC9w+pumofblnmBUlmilFYhVC
	 tJ8SA6ZmANPTzEArSzyMB2Lvu+7KinSUBbXcM3/E2yhcXh99kDJ56KclKPQt6AcE81
	 Rbcf6ba0mlVyCD/MWwLoBGBxUExO4c2b6Fwek/U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/286] bpf: fix check for attempt to corrupt spilled pointer
Date: Mon, 22 Jan 2024 15:57:06 -0800
Message-ID: <20240122235736.753139278@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit ab125ed3ec1c10ccc36bc98c7a4256ad114a3dae ]

When register is spilled onto a stack as a 1/2/4-byte register, we set
slot_type[BPF_REG_SIZE - 1] (plus potentially few more below it,
depending on actual spill size). So to check if some stack slot has
spilled register we need to consult slot_type[7], not slot_type[0].

To avoid the need to remember and double-check this in the future, just
use is_spilled_reg() helper.

Fixes: 27113c59b6d0 ("bpf: Check the other end of slot_type for STACK_SPILL")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-4-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 45c50ee9b037..ddfd33703f4d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2493,7 +2493,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	 * so it's aligned access and [off, off + size) are within stack limits
 	 */
 	if (!env->allow_ptr_leaks &&
-	    state->stack[spi].slot_type[0] == STACK_SPILL &&
+	    is_spilled_reg(&state->stack[spi]) &&
 	    size != BPF_REG_SIZE) {
 		verbose(env, "attempt to corrupt spilled pointer on stack\n");
 		return -EACCES;
-- 
2.43.0



