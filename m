Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4667E17FD;
	Thu, 13 Jun 2024 12:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282790; cv=none; b=oOHroIcTVTGNOzE4kR8LFQhqac53VLyAsyDZA4MX2LxuGJc2l/el2qcCMAZe4au0ywntGNMZnBh8IRoPnH2oDvPVwFK3gqJwIHO9UN+VKB3/PGA/5fSlIG8v8Zgj5wTX40GBTvNJgG/SjT2Ke0CeGXU60086MVgLRMNzV35u94o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282790; c=relaxed/simple;
	bh=V1n5j364mo94KAzBTa3YrUr0sxhagO1xy5+EnHiJnyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk8WdwQqTYiM72T4XUol8veco4ubETqKslcbq9lQwobz8ZojSSMVqxXWCUwTy0R2FlOj9rAd6IBocQsnH2QbEeNXg+/W9+pYVXaOrJo4Uno4FqpxT0gJySHL3hN9G4FPkVTKxnlp8ergJOhD+sLK74dvHm3nz5DsMz2dOKBN898=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsOjILWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsOjILWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2623C4AF1A;
	Thu, 13 Jun 2024 12:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282790;
	bh=V1n5j364mo94KAzBTa3YrUr0sxhagO1xy5+EnHiJnyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsOjILWke8UJVPZLIIhZmv2zDzX5+Gjtpd9gCgKK34xpKJS85o9uupOmyaO1d8X8u
	 iEZ1xTfRpI9KW+gLqcvCN+ipXdJNvnOMDuPXf8wlkfiqPX2/kQAy8pHZvDVlHk2ojz
	 b9Ma/IKa039AxTQrj/PmWq4Zr8s9xMTIE7rHTQX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>
Subject: [PATCH 5.15 397/402] s390/cpacf: Make use of invalid opcode produce a link error
Date: Thu, 13 Jun 2024 13:35:54 +0200
Message-ID: <20240613113317.639723973@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


