Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB33413D601;
	Thu, 13 Jun 2024 12:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280626; cv=none; b=hRIFmNnidLKXEHwnnvm7OnWM63p4WpJatfg5JkQ+pshf5pDGQCa/JW1hw8RzQg0TJgX9tU1wIOjnIRsmtPifRCPzVb+rJ0I9NrRt7m2Ef7VJolG3RKKd0f+WjDLAw2wHnNyqjhskXRzfroDT08AwUxh/FgjrJ0FKtcV+Fl5xwkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280626; c=relaxed/simple;
	bh=V0fF25/EgG5ukaV+C5D+GojcK5YNzRE3KSMTGD+fAD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gI6PAIP7LpGJnVFu/9RKdK9kgCJT6KX6QfeNcS3I9KHRYfqs6QCp6dVr/UBRIIx0o30TUWM9vfw5GQCLxB2Nhps0U/LKuPomGa5RYVCX3BsKylFzaHJGnkbajJcUOC4btjj4knZGSzyL1UcPpR2HcoNquUw7YhK3CAG/t/UB3co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARlqxTpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARlqxTpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F50C2BBFC;
	Thu, 13 Jun 2024 12:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280626;
	bh=V0fF25/EgG5ukaV+C5D+GojcK5YNzRE3KSMTGD+fAD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARlqxTpZ5NwpCOivWMNIDZiQI2g6JQOUi6IMKP/ufjXCWEy1pAmhlNe0GrTI13m2o
	 EOg6r55fG7N39qictVw0ia//2a2PcFVFHfBijHr1l9rEBkbRUuLDHVOefcbX9zPv/v
	 QBmut5RZnPmTexEWR//IGs25AIbzkDNxlPkvMHnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>
Subject: [PATCH 6.6 118/137] s390/cpacf: Make use of invalid opcode produce a link error
Date: Thu, 13 Jun 2024 13:34:58 +0200
Message-ID: <20240613113227.878430237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -166,6 +166,13 @@
 
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
@@ -237,7 +244,7 @@ static __always_inline void __cpacf_quer
 		__cpacf_query_rre(CPACF_PRNO, 2, 4, mask);
 		break;
 	default:
-		BUG();
+		__cpacf_bad_opcode();
 	}
 }
 
@@ -262,7 +269,8 @@ static __always_inline int __cpacf_check
 	case CPACF_KMA:
 		return test_facility(146);	/* check for MSA8 */
 	default:
-		BUG();
+		__cpacf_bad_opcode();
+		return 0;
 	}
 }
 


