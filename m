Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C81DFEF;
	Wed, 20 Nov 2024 12:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107541; cv=none; b=LDf9KyBv5r6L481WgGkigj/bVKx6ySIYZE9gFM7YCpRkcncpth6EEp+F4RT+1iRe9SIk2ZibFd0reDVJvn7/MZxJuqeNnzvkBW8Jyg+eFpZCfujQkImKsCcut/4bvSRQx0KY8OuFO5NHCu4fvHk52CosvmXJhxyyUTbYw6O/4oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107541; c=relaxed/simple;
	bh=LemcfKD68W02ZBO17DIuRgVsk24TgtYr1BCdleKiXQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9qgH88ePhrXvox2oks7tWpWGaZUQYg5ATf1i0q1Muu5TYi4MCyJkak7030zveKS9rmvBshcNkuln/w/htti18KRQEdy5ZSRC7nL+0tI69vPx/x2fIKi44VbIBkTMapTLwko8HFAJSidEWUFNLyiY/XHuU8VIBzYk7+R7fI3kl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QN0rWmYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QN0rWmYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6431DC4CECD;
	Wed, 20 Nov 2024 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107541;
	bh=LemcfKD68W02ZBO17DIuRgVsk24TgtYr1BCdleKiXQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QN0rWmYWpA8mdPN6DQvhA8FOi1x3CsAuI+28lma86CqEJhozNnhI7AVYrimozlQN5
	 xdVHQpqwxjbQp+MyS4wSu4LGvn+0uiKzHEPvDHbfKZBNIvcapkXMLePjmy6dgGhkT5
	 e51cb19cEpHVUpxyJW4qdR1TehGH5+VDe0l/PUC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.11 039/107] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client
Date: Wed, 20 Nov 2024 13:56:14 +0100
Message-ID: <20241120125630.559920968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit a5ca1dc46a6b610dd4627d8b633d6c84f9724ef0 upstream.

A number of Zen4 client SoCs advertise the ability to use virtualized
VMLOAD/VMSAVE, but using these instructions is reported to be a cause
of a random host reboot.

These instructions aren't intended to be advertised on Zen4 client
so clear the capability.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -924,6 +924,17 @@ static void init_amd_zen4(struct cpuinfo
 {
 	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
 		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
+
+	/*
+	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
+	 * in some BIOS versions but they can lead to random host reboots.
+	 */
+	switch (c->x86_model) {
+	case 0x18 ... 0x1f:
+	case 0x60 ... 0x7f:
+		clear_cpu_cap(c, X86_FEATURE_V_VMSAVE_VMLOAD);
+		break;
+	}
 }
 
 static void init_amd_zen5(struct cpuinfo_x86 *c)


