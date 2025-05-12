Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C71E505;
	Mon, 12 May 2025 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073500; cv=none; b=c4WE24x3BoBzVdzmjh5J2RNufs8cwvQICXvzNlNZuMF8q+YypSGzeLzxuWmqT16Vsg+W4G16y7vYKc1LV6C379RDTn620D1qc0jv7l5de4PMOasJDQuRP53xezKtLIpTQxy9xguKQtPN2ENUVIDbUUygSqqHyrI2j6H7r9RLkR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073500; c=relaxed/simple;
	bh=cr/poBU0Yexf4tVYd3df5bSF6XSeveTsFE7bJF8dQKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ2F9s5eOMYy8dnXTqXeaBAoM8hnk1qEnjcU2lvx6oPsH++g2Yz+mJYABVjo90xNi63yepfs1XDR9tXPK5PXpMYXyNtjxUTjhOCw8RqlZQd4o1WR7Ix2zcu+6dFn4UKDhHbwV8OjgukeU8NfcJ87NZ8IvcdsqsQRQLUsHyf4N6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViR6sZB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViR6sZB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A077C4CEE7;
	Mon, 12 May 2025 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073500;
	bh=cr/poBU0Yexf4tVYd3df5bSF6XSeveTsFE7bJF8dQKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViR6sZB+J0jT7Pmr6pyHB+553eB+c5Cju5VgB7C17pMY1afvQZ1NnfrubUvU5GtPB
	 U1VoYB5fvXuJ7kstsd3DRbcHzb2zm+c6ahKn1MNabhK8kgy7DZkTEIXrfG3kdWavZR
	 LLH4BibSYSluImvbRk3U7jv5zRWrPAX6fRV0YatU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.6 096/113] arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
Date: Mon, 12 May 2025 19:46:25 +0200
Message-ID: <20250512172031.588213643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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
@@ -666,6 +666,9 @@ static void __maybe_unused build_bhb_mit
 	    arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE)
 		return;
 
+	if (capable(CAP_SYS_ADMIN))
+		return;
+
 	if (supports_clearbhb(SCOPE_SYSTEM)) {
 		emit(aarch64_insn_gen_hint(AARCH64_INSN_HINT_CLEARBHB), ctx);
 		return;


