Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C8720EB;
	Mon, 14 Oct 2024 14:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916222; cv=none; b=l5S+JSx0C8BQXQy48lnOoAz+16kD2Cxadpg6SvCk0Ko2V4fhfNQLbX12zgR6gYzpy9bN5+aA2QQkDm3+T39ST/cMd3EV22/a3ECSDp9OVteFWRLBi+tb6yDpqW1qQD2r5EYoiRNd/MqH/Y9eg7p5Uy8hDpimV0o7CtXt7nfmBpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916222; c=relaxed/simple;
	bh=zOyImEWgYNLE4ecWLGGuroKQw5XAtHAR1CCaJ/FJxeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijK51kiF/qh3qkhWIbPn267qUNZYZjvhQcPBHN8vX7UNR09bBrcn+JTX/1XFjOg5ibr7MtuUNJKy3QWUaolJCq9n0PdRdT6ZPu8STSkjs2y5DJ4+ncByUeUH9s07+tdTesZlpQxpl5rkdrCDy/l5IzGCo2V3ztXf6g95Yp412tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xH7pdIoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH7pdIoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08473C4CEC3;
	Mon, 14 Oct 2024 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916222;
	bh=zOyImEWgYNLE4ecWLGGuroKQw5XAtHAR1CCaJ/FJxeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH7pdIojjW9MjKbieG/v0EebCkjgvwwb19FjdmgE41aGjXRJpUC0YoYpDaMoeAWps
	 3i960Scn8ql0qeDtiIGxl0Fl+iHE+wqyvWQ4/IYf5fDr8zC2OG+BoXk5OPxYLLVMXi
	 +ydOgsmSUbuuFTb9Vbu1yk6jU8HmyZa6AiMxqi2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels Dettenbach <nd@syndicat.com>,
	Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 118/214] x86/xen: mark boot CPU of PV guest in MSR_IA32_APICBASE
Date: Mon, 14 Oct 2024 16:19:41 +0200
Message-ID: <20241014141049.596514959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit bf56c410162dbf2e27906acbdcd904cbbfdba302 ]

Recent topology checks of the x86 boot code uncovered the need for
PV guests to have the boot cpu marked in the APICBASE MSR.

Fixes: 9d22c96316ac ("x86/topology: Handle bogus ACPI tables correctly")
Reported-by: Niels Dettenbach <nd@syndicat.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 2c12ae42dc8bd..d6818c6cafda1 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1032,6 +1032,10 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 	switch (msr) {
 	case MSR_IA32_APICBASE:
 		val &= ~X2APIC_ENABLE;
+		if (smp_processor_id() == 0)
+			val |= MSR_IA32_APICBASE_BSP;
+		else
+			val &= ~MSR_IA32_APICBASE_BSP;
 		break;
 	}
 	return val;
-- 
2.43.0



