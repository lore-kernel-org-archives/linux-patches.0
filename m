Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF534431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5205FC433A4;
	Wed, 15 Mar 2023 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882811;
	bh=uZJJ94w28hnxDDdGG2axhgXThJmm9k9SF80oSc1F8DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWNZTmUD3D1g35TYDbduYJI3U7jHxHcwLXfyL+L/e3KNa9isQyCaAkx2yJ6KXrpNI
	 u63zlspb1JF3AgOGA72enspvSAV1q8rj/98LG22DA15Tbm3TbB1V62eM6oEm3JCE8g
	 44NScWAV1xwUg2SwmHbEC1aJioSFWBwyszLpZJAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tavis Ormandy <taviso@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.10 003/104] x86/CPU/AMD: Disable XSAVES on AMD family 0x17
Date: Wed, 15 Mar 2023 13:11:34 +0100
Message-Id: <20230315115732.105663915@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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
@@ -932,6 +932,15 @@ void init_spectral_chicken(struct cpuinf
 		}
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
 
 static void init_amd_zn(struct cpuinfo_x86 *c)


