Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAB81E505;
	Mon, 12 May 2025 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073494; cv=none; b=c/V/764L+28BEc9//g1Om+ucUn6dKfZE3D5GfUk3/czB9Dv5LImuufekDO+aumC61VQGrJIn4eIHeyoT/UmVkIJOaYPdaYdbbm3mMjzwm3L+NunHV4WmlCJ53V6cttGJRMpryVGyklHP5l+Wbg3OxDW/v+7trLyq9ntCbqFVGqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073494; c=relaxed/simple;
	bh=FXr29ZrXxAZIlwtL01zsBnXGGUtJ1+IcNVjHfXmqGcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pncPkJ5Wi44JK0vifgl/YezvEtPGg8u8S3XiErg1L0vc2WYvru2/TasLsgGV1UkFWl8eRATAFFpASTyJ2polL09l23dlCMcObLWH8iT3Kw10Hqmt9cwk/FL+G8CzFz+Ui4yTgP5+wChCvZGxnu7EEuTGCZ2n9lSuqrdWpkE1fIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGY2480g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGY2480g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36D4C4CEE7;
	Mon, 12 May 2025 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073494;
	bh=FXr29ZrXxAZIlwtL01zsBnXGGUtJ1+IcNVjHfXmqGcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGY2480g4Au0i6oG804WPiOUQ9ezCNA3PH1G8y1rtcrsRQq3He0K+7rmDY80NVkcV
	 C+HbOXrdnnsU8xhTES+Gys0xpW3/hLMhP0VlS4WBWJ7Ow9jXHYVYC9Q3X5mpg6KB8/
	 t2tdP9M4549JhBv2pb9eDtDHvp0g74R+ljtA5JR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 094/113] arm64: proton-pack: Expose whether the branchy loop k value
Date: Mon, 12 May 2025 19:46:23 +0200
Message-ID: <20250512172031.505630403@linuxfoundation.org>
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
@@ -97,6 +97,7 @@ enum mitigation_state arm64_get_meltdown
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 get_spectre_bhb_loop_value(void);
 bool is_spectre_bhb_fw_mitigated(void);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -998,6 +998,11 @@ bool is_spectre_bhb_affected(const struc
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


