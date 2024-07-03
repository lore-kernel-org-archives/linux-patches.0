Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D62183093;
	Wed,  3 Jul 2024 11:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004853; cv=none; b=ohkXhi57mvusqa/PsfVh82Yoa5psvxQdBmySl4mId4MXk69VLj3MAKpBetVYMHtQ6Bt+0qUYoI2Dl+nRYfM+h0Q8GuVysxHtBpLA5RjCdp1eXNcJ5LfXV2q7c/5wZD0eIvG0YO27iCYWNm+JWQtZGrRe5DwvBu86wT492yeMv1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004853; c=relaxed/simple;
	bh=1O+r/6Un7zIPqbvoU0pzm2rrtuXRO8mEvdE8RssG164=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVliqC+/tUoRtp4JcfDWIg3j8oUkrHheUNs0d0H8cAkP+Yg73HsFhfYfzlmKS7LUdYCi0JqcQfP4Vpg33Zk8oJaDmdNg25+eFm+RdCAv4Y6/7RN8eYPBr/sGfrt6Frrjc1RgeZutU1pzrHbzoEZjeVsj3At/XufrYU2YBRWk4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5g0pwZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5g0pwZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E09AC2BD10;
	Wed,  3 Jul 2024 11:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004853;
	bh=1O+r/6Un7zIPqbvoU0pzm2rrtuXRO8mEvdE8RssG164=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5g0pwZJmkvGRHr0LEZ5a3px+yVVVcCP4nsVoHBr2lzrNAHflrzRwJOHNUSKjeE8r
	 lJVq2LEX/3VbGom3fzeW9OCO18iMeUnbn3g8zWaIOMti88h5JpJKm61gHZJxp3JGRv
	 hM56gX9kfu7EfxcJ8wjwQabCEPBRCVHKBo5dMcDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/290] s390/cpacf: Make use of invalid opcode produce a link error
Date: Wed,  3 Jul 2024 12:39:21 +0200
Message-ID: <20240703102910.971417907@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



