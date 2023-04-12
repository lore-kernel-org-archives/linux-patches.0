Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D8C2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7223DC433EF;
	Wed, 12 Apr 2023 08:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289433;
	bh=fEOFi/Fl8HVNL7NhrdGFNEhg55LDFI/anV72b7N0fM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAKOiPFX73LbZqMWZsW3xhu6uNIpxATnTCvD//JNgOLeKkQhtHhEe1XmJCeoiTf42
	 x6rcCcftCrvwbrkIUsKqTh6JgZzOJdQKHa4LRwKinDce2t5NtkJEnZlX7o0tJrVq+k
	 /eABDnQAZuny+5Rtg9N9NCP2QNfgOPtnMLCf1B1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric DeVolder <eric.devolder@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.2 098/173] x86/ACPI/boot: Use FADT version to check support for online capable
Date: Wed, 12 Apr 2023 10:33:44 +0200
Message-Id: <20230412082842.034279226@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit a74fabfbd1b7013045afc8cc541e6cab3360ccb5 upstream.

ACPI 6.3 introduced the online capable bit, and also introduced MADT
version 5.

Latter was used to distinguish whether the offset storing online capable
could be used. However ACPI 6.2b has MADT version "45" which is for
an errata version of the ACPI 6.2 spec.  This means that the Linux code
for detecting availability of MADT will mistakenly flag ACPI 6.2b as
supporting online capable which is inaccurate as it's an ACPI 6.3 feature.

Instead use the FADT major and minor revision fields to distinguish this.

  [ bp: Massage. ]

Fixes: aa06e20f1be6 ("x86/ACPI: Don't add CPUs that are not online capable")
Reported-by: Eric DeVolder <eric.devolder@oracle.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/943d2445-84df-d939-f578-5d8240d342cc@unsolicited.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -146,7 +146,11 @@ static int __init acpi_parse_madt(struct
 
 		pr_debug("Local APIC address 0x%08x\n", madt->address);
 	}
-	if (madt->header.revision >= 5)
+
+	/* ACPI 6.3 and newer support the online capable bit. */
+	if (acpi_gbl_FADT.header.revision > 6 ||
+	    (acpi_gbl_FADT.header.revision == 6 &&
+	     acpi_gbl_FADT.minor_revision >= 3))
 		acpi_support_online_capable = true;
 
 	default_acpi_madt_oem_check(madt->header.oem_id,


