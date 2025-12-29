Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD71B6D08;
	Mon, 29 Dec 2025 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025526; cv=none; b=CzJzUOAXy8NGg+7ryJ/0kpdhuHlQkxz+GmzcfoDhtfgiHEc3+S1dXddzaRiX4o9mrXxfo6yYybTbOD40TfzI6vN3h9BIMSJ3k/EinYgpZyGlZTEayewoQ8lY+jfyoejHGDyuswtv+wAXx63qDXhv9WzGrP3j4j5v3QJ35XPvxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025526; c=relaxed/simple;
	bh=Q5DI3ogdEJUMHv1qdhiV71H0+D1lxagZWk5mqkg8Hdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6Gf3FEScwDog7c6YV99xnknHpJs3cjQublY6qWv+Pm5UnF8DUmNR8WoC+kYK1XS1z4miGbNrJ0f8X4FNyyjhE6hTPEU4G0zfa0mEqwf930VRPsF67d4qYL2FNYM5tzbnjDPI26NlSHQQaiKRxHss3yfLF9LmGrSfkXKu4o9T1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLk6xBkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLk6xBkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6587DC4CEF7;
	Mon, 29 Dec 2025 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025525;
	bh=Q5DI3ogdEJUMHv1qdhiV71H0+D1lxagZWk5mqkg8Hdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLk6xBkMX/RLUmb0tR1kGAj1GE7cpGZ8QFk73rzry1oLgpYqI4SK7Pi0HtPpszdhY
	 D6JtMO6bTUb8I4aZ8WW75GqybHBOSodypJ6VB6eX8vbyArMZCHF0oNGL3RK0bZXGcf
	 wfNnO99ac+KPdKrihg3MzNmM074hMWRbwuNNmgjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 237/430] x86/mce: Do not clear banks poll bit in mce_poll_banks on AMD SMCA systems
Date: Mon, 29 Dec 2025 17:10:39 +0100
Message-ID: <20251229160733.076855881@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avadhut Naik <avadhut.naik@amd.com>

commit d7ac083f095d894a0b8ac0573516bfd035e6b25a upstream.

Currently, when a CMCI storm detected on a Machine Check bank, subsides, the
bank's corresponding bit in the mce_poll_banks per-CPU variable is cleared
unconditionally by cmci_storm_end().

On AMD SMCA systems, this essentially disables polling on that particular bank
on that CPU. Consequently, any subsequent correctable errors or storms will not
be logged.

Since AMD SMCA systems allow banks to be managed by both polling and
interrupts, the polling banks bitmap for a CPU, i.e., mce_poll_banks, should
not be modified when a storm subsides.

Fixes: 7eae17c4add5 ("x86/mce: Add per-bank CMCI storm mitigation")
Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251121190542.2447913-2-avadhut.naik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/threshold.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/threshold.c
+++ b/arch/x86/kernel/cpu/mce/threshold.c
@@ -85,7 +85,8 @@ void cmci_storm_end(unsigned int bank)
 {
 	struct mca_storm_desc *storm = this_cpu_ptr(&storm_desc);
 
-	__clear_bit(bank, this_cpu_ptr(mce_poll_banks));
+	if (!mce_flags.amd_threshold)
+		__clear_bit(bank, this_cpu_ptr(mce_poll_banks));
 	storm->banks[bank].history = 0;
 	storm->banks[bank].in_storm_mode = false;
 


