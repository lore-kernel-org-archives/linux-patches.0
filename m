Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207742951D9;
	Mon, 12 May 2025 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073219; cv=none; b=GoHfgctkbcvIm26R03o9g+q33qhyldANMGgwWHpb9RDQEPoSf41lWvJOQ3ugz43BumT1oA3LNAQCbu/EdxSnYRBEEv9z/oBe+pytbCK0iG4oN+BqkIEtpV5NwvWCOP06zmveDgD2rBdJQVEf3QqLE+8nfyQx/rEAjCHXOaSwZYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073219; c=relaxed/simple;
	bh=KUiMOMr3ZlT0HvkvAmnwDBkzJ1hu2HZCcRsRUrtWM18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmvFlA8x+cxNChUtY+xU2Hece7oTk9faIvPSck/GtbUpt1aJ6w0oQWZvRChHfywjF3T8cUUwrOidO0nyeCRwMGOx+XhpAIZUMb2iv50bQTJGfsIgVqZnV5XKNC8ngU49onc6myj1iwVBZAKanT438PAtwJXYb76/B4y5PSwn5KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AI4dptCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AI4dptCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EFDC4CEE7;
	Mon, 12 May 2025 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073219;
	bh=KUiMOMr3ZlT0HvkvAmnwDBkzJ1hu2HZCcRsRUrtWM18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AI4dptCbKoTu4JLwvFsP4jQUvJx3+rnqZMlVJ2kGneKYr6Lf9hJoeZOSp2ilu/CU4
	 2YP9qyLtGfmw+UsvjrNTp+DYoeMgTr2pJ8Rdb5GiBas2q9dxGayc42sllJ0E5dYp7O
	 BCgA9Hccbgk5NW9tCKKx9cvwRplItxv+Yt7hesUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.12 166/184] arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
Date: Mon, 12 May 2025 19:46:07 +0200
Message-ID: <20250512172048.573634993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit f300769ead032513a68e4a02e806393402e626f8 upstream.

Support for eBPF programs loaded by unprivileged users is typically
disabled. This means only cBPF programs need to be mitigated for BHB.

In addition, only mitigate cBPF programs that were loaded by an
unprivileged user. Privileged users can also load the same program
via eBPF, making the mitigation pointless.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -870,6 +870,9 @@ static void __maybe_unused build_bhb_mit
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
+	if (capable(CAP_SYS_ADMIN))
+		return;
+
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
 		emit(aarch64_insn_gen_hint(AARCH64_INSN_HINT_CLEARBHB), ctx);
 		return;


