Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF474431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A38C433EF;
	Wed, 15 Mar 2023 12:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882538;
	bh=fR0EYdQCzK7Y1H45+mzqlcr/kpgTUvWC1LVmvfM9ayQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRLrORDLQfto1kL67LUzO/p3Q2RXqwOfvcv21yHX57B4LqbL3FTdvzeeQ+0E+a6Yz
	 tXLI4tJUlr5ad+PrqJ7fsWGt4KMMdjlzvoeje4vdyzFP9kA9r8U0EMsmIEV+2P7IIu
	 coZVzK7VNSb1awm0vA197N5ds9/fG/Kpx+CctNd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tavis Ormandy <taviso@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 4.19 02/39] x86/CPU/AMD: Disable XSAVES on AMD family 0x17
Date: Wed, 15 Mar 2023 13:12:16 +0100
Message-Id: <20230315115721.329362992@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit b0563468eeac88ebc70559d52a0b66efc37e4e9d upstream.

AMD Erratum 1386 is summarised as:

  XSAVES Instruction May Fail to Save XMM Registers to the Provided
  State Save Area

This piece of accidental chronomancy causes the %xmm registers to
occasionally reset back to an older value.

Ignore the XSAVES feature on all AMD Zen1/2 hardware.  The XSAVEC
instruction (which works fine) is equivalent on affected parts.

  [ bp: Typos, move it into the F17h-specific function. ]

Reported-by: Tavis Ormandy <taviso@gmail.com>
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230307174643.1240184-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -199,6 +199,15 @@ static void init_amd_k6(struct cpuinfo_x
 		return;
 	}
 #endif
+	/*
+	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
+	 * certain circumstances on Zen1/2 uarch, and not all parts have had
+	 * updated microcode at the time of writing (March 2023).
+	 *
+	 * Affected parts all have no supervisor XSAVE states, meaning that
+	 * the XSAVEC instruction (which works fine) is equivalent.
+	 */
+	clear_cpu_cap(c, X86_FEATURE_XSAVES);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)


