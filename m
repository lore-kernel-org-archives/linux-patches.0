Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AC21C860D;
	Wed,  5 Mar 2025 18:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197902; cv=none; b=XJsn6fwYTTaqH+lEe+TIStMZMUC9mHUp7YvZM9V9rwaQFHki/XnvYCxsyncMTNqS5ZuSOeO1Q6qCIt9n9rf/N+q5JhRhhsCqhY0/AJNfXIrHmQj0ZpBxmJ7HdlxrMT1y+HBfSsRfJfB4SK+CBDa7SgKElwqV4XRGINLXjVV7WI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197902; c=relaxed/simple;
	bh=rnoAV4f22txhHib+jNdlECFs3CYdI1eAMl1Y9P/5C0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4OlVca4o7FpCIVLIbI/MAz3sPVLVya5X0L8X5MSooAHenr47nzfv3wRoEj11BxhtHh/+Xm2jcdeG5cxkQ/l13EtIl5iSPhnOAGH8qECttTLsKFlXAaJY96q5AQpql/TVfGgPvw9NPS8R4btu7iDD8om2+x1meF6dsPlmJtPaW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lflEs4Sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lflEs4Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB208C4CED1;
	Wed,  5 Mar 2025 18:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197902;
	bh=rnoAV4f22txhHib+jNdlECFs3CYdI1eAMl1Y9P/5C0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lflEs4SgvMYXhy35Q5BxHe2CwXZ/4IO3uW4qEfwQlX4ZS0d40seB5Gpdfqly80QxD
	 ZStk+W6Nul6IvA4sZuda0y/xOSv8RWFsTRIIF8b2tcTUYVzVkUhjwsmjjsZYgmTqV1
	 SfiiYEz3CCv3okQpiXprO+tXh7uZgKQ1wKazydUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 107/142] x86/microcode/intel: Reuse intel_cpu_collect_info()
Date: Wed,  5 Mar 2025 18:48:46 +0100
Message-ID: <20250305174504.629650348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 11f96ac4c21e701650c7d8349b252973185ac6ce upstream

No point for an almost duplicate function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115902.741173606@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -435,21 +435,7 @@ void reload_ucode_intel(void)
 
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	unsigned int val[2];
-
-	memset(csig, 0, sizeof(*csig));
-
-	csig->sig = cpuid_eax(0x00000001);
-
-	if ((c->x86_model >= 5) || (c->x86 > 6)) {
-		/* get processor flags from MSR 0x17 */
-		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		csig->pf = 1 << ((val[1] >> 18) & 7);
-	}
-
-	csig->rev = c->microcode;
-
+	intel_collect_cpu_info(csig);
 	return 0;
 }
 


