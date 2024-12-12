Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FAC2135C1;
	Thu, 12 Dec 2024 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017919; cv=none; b=SgRRKkDDx1OS7BLCSCADlgt7jQSaE7LI2WmV2IrfqtlIh+Xxhevb52fBT+xv6kBiu/BWt4bBXh9ReXZ3S5Y3uOwIbXCbD5GS7eGZfko5D3KOIr4eL2WcHr4p8oM46G9q/ikUWWWLhw9IWs8r12E0zmRB6wZolrsuE5ZzhapFU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017919; c=relaxed/simple;
	bh=09GIPPN9YC2Az21L8J/mjl9yRoeTsShg5o7dAmKAP+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo+G3HtAhNhR+pclMP3INS+n83Bsr3zzkxfaLu92glCrEriao7hBcz8xjCHuDpYlJUhoUqQm2b9NFQinbyi0HVWI43sOgoT08N3f1hU7yratCNiGhKOJT+TLa6hE9cC7joZSQ7/SLRItwMpE6zJxX1hrBl/Cap3p3QT+0qppXUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DASj1/H2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DASj1/H2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FD6C4CED0;
	Thu, 12 Dec 2024 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017919;
	bh=09GIPPN9YC2Az21L8J/mjl9yRoeTsShg5o7dAmKAP+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DASj1/H2eq/DvuXwhWCnzoGBh+HJq8RtbzB7SK8Cp5n8e3sf5wbSG3GwWH1TcvkTd
	 WrWSzH+KPttTj6XZU8C5siBOBY2HEBQifLNXJTsofXofEBTgCref6XNsS4xr3CA/Y3
	 UdxHqm+yBwAz3bLj0ijUuIpEPPNPTgMY6iEB25AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 147/356] arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs
Date: Thu, 12 Dec 2024 15:57:46 +0100
Message-ID: <20241212144250.447211980@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit c0900d15d31c2597dd9f634c8be2b71762199890 upstream.

Linux currently sets the TCR_EL1.AS bit unconditionally during CPU
bring-up. On an 8-bit ASID CPU, this is RES0 and ignored, otherwise
16-bit ASIDs are enabled. However, if running in a VM and the hypervisor
reports 8-bit ASIDs (ID_AA64MMFR0_EL1.ASIDBits == 0) on a 16-bit ASIDs
CPU, Linux uses bits 8 to 63 as a generation number for tracking old
process ASIDs. The bottom 8 bits of this generation end up being written
to TTBR1_EL1 and also used for the ASID-based TLBI operations as the
upper 8 bits of the ASID. Following an ASID roll-over event we can have
threads of the same application with the same 8-bit ASID but different
generation numbers running on separate CPUs. Both TLB caching and the
TLBI operations will end up using different actual 16-bit ASIDs for the
same process.

A similar scenario can happen in a big.LITTLE configuration if the boot
CPU only uses 8-bit ASIDs while secondary CPUs have 16-bit ASIDs.

Ensure that the ASID generation is only tracked by bits 16 and up,
leaving bits 15:8 as 0 if the kernel uses 8-bit ASIDs. Note that
clearing TCR_EL1.AS is not sufficient since the architecture requires
that the top 8 bits of the ASID passed to TLBI instructions are 0 rather
than ignored in such configuration.

Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241203151941.353796-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/context.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -32,9 +32,9 @@ static unsigned long nr_pinned_asids;
 static unsigned long *pinned_asid_map;
 
 #define ASID_MASK		(~GENMASK(asid_bits - 1, 0))
-#define ASID_FIRST_VERSION	(1UL << asid_bits)
+#define ASID_FIRST_VERSION	(1UL << 16)
 
-#define NUM_USER_ASIDS		ASID_FIRST_VERSION
+#define NUM_USER_ASIDS		(1UL << asid_bits)
 #define ctxid2asid(asid)	((asid) & ~ASID_MASK)
 #define asid2ctxid(asid, genid)	((asid) | (genid))
 


