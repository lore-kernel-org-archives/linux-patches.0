Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5892F2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57CBC433EF;
	Wed, 12 Apr 2023 08:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289431;
	bh=mXPxwdqctaWuvNo3Mr/rvXBuSKg6oqk9IDTnsDFszDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktIdVB/emozLCgvjYkzoeWgnZmvMrMQg0Pu6kvc3OIdLN/RHEKZA4tjtO6rDCc+oM
	 uNB7ep6eOV3f04qpmdsmhoa1iBamhAVJFV11ySvmqkT4t5SKRBXht5x1PwIGQ9V21Y
	 j3acj9payoA/x+MPO2BK4cBoUZTUSwDv9hjf8ru0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Luis <miguel.luis@oracle.com>,
	Boris Ostrovsky <boris.ovstrosky@oracle.com>,
	Eric DeVolder <eric.devolder@oracle.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	David R <david@unsolicited.net>,
	stable@kernel.org
Subject: [PATCH 6.2 097/173] x86/acpi/boot: Correct acpi_is_processor_usable() check
Date: Wed, 12 Apr 2023 10:33:43 +0200
Message-Id: <20230412082841.994927947@linuxfoundation.org>
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

From: Eric DeVolder <eric.devolder@oracle.com>

commit fed8d8773b8ea68ad99d9eee8c8343bef9da2c2c upstream.

The logic in acpi_is_processor_usable() requires the online capable
bit be set for hotpluggable CPUs.  The online capable bit has been
introduced in ACPI 6.3.

However, for ACPI revisions < 6.3 which do not support that bit, CPUs
should be reported as usable, not the other way around.

Reverse the check.

  [ bp: Rewrite commit message. ]

Fixes: e2869bd7af60 ("x86/acpi/boot: Do not register processors that cannot be onlined for x2APIC")
Suggested-by: Miguel Luis <miguel.luis@oracle.com>
Suggested-by: Boris Ostrovsky <boris.ovstrosky@oracle.com>
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: David R <david@unsolicited.net>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230327191026.3454-2-eric.devolder@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -193,7 +193,8 @@ static bool __init acpi_is_processor_usa
 	if (lapic_flags & ACPI_MADT_ENABLED)
 		return true;
 
-	if (acpi_support_online_capable && (lapic_flags & ACPI_MADT_ONLINE_CAPABLE))
+	if (!acpi_support_online_capable ||
+	    (lapic_flags & ACPI_MADT_ONLINE_CAPABLE))
 		return true;
 
 	return false;


