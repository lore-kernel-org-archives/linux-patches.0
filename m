Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0767254863;
	Mon, 12 May 2025 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072263; cv=none; b=RWghW76WczTnz5yidGZ4SAntxpYK34/gfgENlSs2431Gn/NMywNbd9PJV+pvkiWTSq6iyYhrD9vI+NWmQuSdT5M6OxY4MAQrZPllFpQak5eY4irbCI+JsyUotK1B7jxadAB16UDdoG92+d0Ayz20Jgh9YNa82kYAlKQa7uasTdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072263; c=relaxed/simple;
	bh=ECy0dK1xZz8qT8ibHyRFqfBfxi8A753ub2FtemXfEuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j044Sx5GSRQvw3hETtX5fkbV4Q4P98TfctNKBc/zaHt1mQfGtcfOklucfT42T6bzsfNThFS2reNtFhAi5Uf8bdTBA4mrQ6Ep7UBSBEw0uNFc9XzlYBE2NbEh1wZk7lTdQAWfKc8gtosslfrCk370Rx/DlPojQZA9jsOnGLD/OoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2Id/WTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2Id/WTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5095FC4CEE7;
	Mon, 12 May 2025 17:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072263;
	bh=ECy0dK1xZz8qT8ibHyRFqfBfxi8A753ub2FtemXfEuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2Id/WTDo670q1Txt8D45rCzYvAVKOBtmhDdwuR59nlTxi7iefgyEzVFljfXZ1vo4
	 0DniinUmCsQJCgl8hxpKr1+kTxT3h3zX4PQFzeKpUGDObL7DeF5MINn8vdUSVqFqLU
	 atJlhA9QdNBTq9uXY31LH9MKoknlsfttyWWTrKio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.14 182/197] arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
Date: Mon, 12 May 2025 19:40:32 +0200
Message-ID: <20250512172051.799075507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -877,6 +877,9 @@ static void __maybe_unused build_bhb_mit
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
+	if (capable(CAP_SYS_ADMIN))
+		return;
+
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
 		emit(aarch64_insn_gen_hint(AARCH64_INSN_HINT_CLEARBHB), ctx);
 		return;


