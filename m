Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9E52528E6;
	Mon, 12 May 2025 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072553; cv=none; b=qxjItNTybBQhAo/mM75J7noXFm4Tl3LV79572bYrIyR6mYord1qIET/20KcvtjkGt+4CQbuNkzfcnhuXPki+hay4TFkqj6cyKXPHsjQCc7ONhfS4zS9yvarEthgRQJefXNLaEXZRpuvwKyRRb2Jq9LsHehkw++ayoszXVRZ8MIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072553; c=relaxed/simple;
	bh=I9S35SyQi9tcA43V/CIz05mmkMh+sx1AYfaLvfZ/1eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4knYqOxudRPHB6Pff5EY9nRcK36y6jh5qwwFcZYMXEb6T0QFJr7ezmoIEfAprty8uqLvrmkV/NVAODcBzAzTM+EQo1rw965Rks3uRR/HrPEij8QJcJfSwL4P0hlV4OAiFnoWQz3V17gS3cYvW0FnQ/6sYHmhuX23krEawG9f+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYDYeBc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYDYeBc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D52C4CEE7;
	Mon, 12 May 2025 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072553;
	bh=I9S35SyQi9tcA43V/CIz05mmkMh+sx1AYfaLvfZ/1eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYDYeBc88GcknzsVAggcr2w4NhvhL6p39dsIRh3cdhCjX4CWoJmAN4qmmz7rWGXo8
	 RKFntNku6R8jTjIOGS0TicyEdWWFSO5Y4fk392Tz2s3yG3JjbGzuPZmFsHLDwD64V/
	 9NqOLjngRGVp1yVNrH14jWShe5DiREMAo581cLQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.1 76/92] arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
Date: Mon, 12 May 2025 19:45:51 +0200
Message-ID: <20250512172026.221025348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


