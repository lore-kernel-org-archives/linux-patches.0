Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346161A08CA;
	Mon, 12 May 2025 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072544; cv=none; b=rYyAJYgdRy0Jug7Pu1GFxPyQMJAT4lrBiCbsUMzDFXFdkrvN6TrJOmB9JNKLF5XEnNLOPNNvja1ROFF/v4I/VMrkujTGAQ2vh0/Jumpo5LTO3tVSG8wRiTW/fTwzC7JZbj9H/0KbaUMOgh4an9l32B8/KwJg+mgd+dFXqcgJnKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072544; c=relaxed/simple;
	bh=s9hkXwBICcsWSrYh0ngdtvoT3rzRPLw78lnkBLUC6cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPZyBFhJ3d1U9M4b0c9TyUoUrVLNZU2F4jWs2HPbLIVIPP9rfb5GIAUgEkJ6oKGSQ0R8PuxKhSScgMKTSRlFriS0nZscaellfLm4HkmFnl92S9KhNTzbZjT/x9aw0EOrfqwU85Zv2AyreLZCBmrVOxRUfdVosSWj6AaEKGEzSjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nwx5+vVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nwx5+vVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8D3C4CEE9;
	Mon, 12 May 2025 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072544;
	bh=s9hkXwBICcsWSrYh0ngdtvoT3rzRPLw78lnkBLUC6cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nwx5+vVoZ04hffPfAcfl8WRas7dZ9QiXvmwEdNc/TrHTaJH7nsc3LGdbYvpeM+rBJ
	 h7BsfHFx/O0cZ9Lns1jFbMLCw8M7BO42meMI0f2LFgG1qstoSKW1bslZGw61idP1PV
	 Rzu3w+s4AnIXAX33v4blr8eQ8Os1VJKYPxaawrP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 74/92] arm64: proton-pack: Expose whether the branchy loop k value
Date: Mon, 12 May 2025 19:45:49 +0200
Message-ID: <20250512172026.137668414@linuxfoundation.org>
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

commit a1152be30a043d2d4dcb1683415f328bf3c51978 upstream.

Add a helper to expose the k value of the branchy loop. This is needed
by the BPF JIT to generate the mitigation sequence in BPF programs.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    1 +
 arch/arm64/kernel/proton-pack.c  |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -96,6 +96,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 get_spectre_bhb_loop_value(void);
 bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 #endif	/* __ASSEMBLY__ */
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1010,6 +1010,11 @@ bool is_spectre_bhb_affected(const struc
 	return true;
 }
 
+u8 get_spectre_bhb_loop_value(void)
+{
+	return max_bhb_k;
+}
+
 static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
 {
 	const char *v = arm64_get_bp_hardening_vector(slot);


