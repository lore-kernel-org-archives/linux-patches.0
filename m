Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F254173348;
	Wed,  3 Jul 2024 10:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004133; cv=none; b=HFfyWWrvyGRAxeJccLkVaZqtZiWsfpjOmoSR4G/N3/IJz7+OucXs59DeDdWhWZsGVx5if/ppeP9v5KwjHM/SOYjpGMnoyFu9m8CPsWL2+0cGvfGVMtkN4anak+w/6NiowEf0vGi6/HLz94xIU3rpNsG+eTMzBcBMw/L/1uv6sIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004133; c=relaxed/simple;
	bh=iAZ+yqHMCpUevtlYvjPWysY+vGxskdyCGon7vC/ElUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijYhux5W9dxW9Kw0NjthFu2OscxwG2ux0J/kxjwgIR8Z51xbifg0Y4cQ4SV59iMEZCXPgRxeWA52Y1deA6drQRbWBElIBnu1M8THuDbaRctI65OfqpvG7BbPgYGwrsD7idcnzwjxM5mGhvBgWdd3AaX9Bv/IV5x0daxn3j/+SDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe62kuVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe62kuVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88995C2BD10;
	Wed,  3 Jul 2024 10:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004133;
	bh=iAZ+yqHMCpUevtlYvjPWysY+vGxskdyCGon7vC/ElUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pe62kuVThHDlT3yVvxo5QYKnlXC6KHnR1ZDERa4CY7HMX51RONv+GBqtOqQt2Zuad
	 gbAXd9K+ZdXsd+qTW3mnP+wmGJ226r7R38i5BFE1Co/magaEHwuw0tNpr8HraM+uy0
	 3Ff76Q1h0Nr4vkV6OSQWFtzm6ZBIfuLg0+2VLVD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/189] s390/cpacf: Make use of invalid opcode produce a link error
Date: Wed,  3 Jul 2024 12:39:45 +0200
Message-ID: <20240703102846.175355179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 32e8bd6423fc127d2b37bdcf804fd76af3bbec79 ]

Instead of calling BUG() at runtime introduce and use a prototype for a
non-existing function to produce a link error during compile when a not
supported opcode is used with the __cpacf_query() or __cpacf_check_opcode()
inline functions.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/cpacf.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index fa31f71cf5746..0f6ff2008a159 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -161,6 +161,13 @@
 
 typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
 
+/*
+ * Prototype for a not existing function to produce a link
+ * error if __cpacf_query() or __cpacf_check_opcode() is used
+ * with an invalid compile time const opcode.
+ */
+void __cpacf_bad_opcode(void);
+
 static __always_inline void __cpacf_query_rre(u32 opc, u8 r1, u8 r2,
 					      cpacf_mask_t *mask)
 {
@@ -232,7 +239,7 @@ static __always_inline void __cpacf_query(unsigned int opcode,
 		__cpacf_query_rre(CPACF_PRNO, 2, 4, mask);
 		break;
 	default:
-		BUG();
+		__cpacf_bad_opcode();
 	}
 }
 
@@ -257,7 +264,8 @@ static __always_inline int __cpacf_check_opcode(unsigned int opcode)
 	case CPACF_KMA:
 		return test_facility(146);	/* check for MSA8 */
 	default:
-		BUG();
+		__cpacf_bad_opcode();
+		return 0;
 	}
 }
 
-- 
2.43.0



