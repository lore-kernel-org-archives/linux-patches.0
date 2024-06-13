Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309A117FD;
	Thu, 13 Jun 2024 12:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283040; cv=none; b=ORxNuj3Q/R1kntJJUdIIb5XlHWG+JgGYb+390wkDRfvEoTuOnY/iMRfaex81ejT9/s14tix40TeNhR6quaPdEjhdmk/oa/p7qwGK7mjpzF5vfCkkBeg6dLwUSruuClew4TgtH99c4PrE4wUQnP4exBBm0X6QM0MiwrF2pPZx6hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283040; c=relaxed/simple;
	bh=FmGvu89IfLX7eckNISorigGxMaGKJT1ujiuMnNwfwbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APmpdJo0QanMVWcbqfbxwZPv2iQLNax9Po4YhyaYIVv6I8jQagUFD05WPR3wY9zMADcTFXCyGDfeiAsqr7L10Q9yysVG2LFdGdGuVKnvIocoYt9sLOwkpEmRJhCk4/iCNnn4dgfflDdyj97C8akda6fjQ33yeC4iJQgXFtzG784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sJWK6SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sJWK6SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA68FC2BBFC;
	Thu, 13 Jun 2024 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283040;
	bh=FmGvu89IfLX7eckNISorigGxMaGKJT1ujiuMnNwfwbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sJWK6SY+2QeRaeZNC+aCh/LEUxtHMUM2ja3hIAxoMd4bjvsCTB/wrrxGMJ1a/yDD
	 gkJ2XIlgd1QqrDtPifJnDcg2UvzhvhgKgLjLd5ncrBDAivWZy81XNJ825f85wQ/1M/
	 LlzPTOTW7/Kde1f7kudF/X0XFSCf+wQQfwDam5i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>
Subject: [PATCH 6.1 78/85] s390/cpacf: Make use of invalid opcode produce a link error
Date: Thu, 13 Jun 2024 13:36:16 +0200
Message-ID: <20240613113217.145941276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 32e8bd6423fc127d2b37bdcf804fd76af3bbec79 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/cpacf.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

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
@@ -232,7 +239,7 @@ static __always_inline void __cpacf_quer
 		__cpacf_query_rre(CPACF_PRNO, 2, 4, mask);
 		break;
 	default:
-		BUG();
+		__cpacf_bad_opcode();
 	}
 }
 
@@ -257,7 +264,8 @@ static __always_inline int __cpacf_check
 	case CPACF_KMA:
 		return test_facility(146);	/* check for MSA8 */
 	default:
-		BUG();
+		__cpacf_bad_opcode();
+		return 0;
 	}
 }
 


