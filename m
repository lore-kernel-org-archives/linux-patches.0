Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878F03515E7;
	Sat, 17 Oct 2026 16:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253359; cv=none; b=c7y0HoDcmIi92ZL6dE9WQzYP1PJE0WnjjDg+Bu1LAZ3ItNGrlh/U4clhUFwvdbxJljR817Gy13hlxcUfs3mTH+nmKGbLs+X7md0wnY66URBV4ouYGTHKmW/b0w2aVZw4MICWKjAyt4Lr1IXx7JnU8qgPXflEz/rQwt/IzhdMIqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253359; c=relaxed/simple;
	bh=Z9CqUdT22Ej3KKZZUkZN7ifCF1YVD7HhK9rjkUrfkoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WseGH8GdcmhRr1qVb+Qw5xIi0GIBmWgVJ+tCUVqJG2hQ7FPGkzLqvPAv+DW2sHFv3Vx4wHBLXBJtpgyipHFh3m2+82K71P2PyIn3c7KwQhn1p7/QYLVrs79Ym4LPxFYZPu71avtN18CeTaKPZh1atjnKk0hm9YnVIa9SiUQsMWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1GykneD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1GykneD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54831F000C4;
	Sat, 17 Oct 2026 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253358;
	bh=WqW/YVkVUSWwAnqZhi+1AGydmyHyBwmoYnjx42nACkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1GykneDHn0yNMb3TyvxP85EQPSuxM1GWiKuGebCvf8lfS8Fg0DSOfoiOsBPPPMSQ
	 ayKBolxLepnG/gh47D/4XZf/Xlwyr0LV4p2jZwxkg/y1gVkGAGgVhXaN7AkN7Pttuv
	 CqrNmf3orM8GxUlLIzEOC+vhwJGggdQ4KcP3Gfvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/869] s390/mm: Simplify get_fault_type()
Date: Sat, 17 Oct 2026 17:48:53 +0200
Message-ID: <20261017160039.394582861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f76901d16008862035265037905fd84364c3d0ac ]

With the gmap code gone get_fault_type() can be simplified:

- every fault with user_mode(regs) == true must be a fault in user address
  space

- every fault with user_mode(regs) == false is only a fault in user
  address space if the used address space is the secondary address space

- every other fault is within the kernel address space

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/r/20241022120601.167009-10-imbrenda@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 11709abccf93 ("s390/mm: Fix in_atomic() handling in do_secure_storage_access()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e48910b0b8169..6e96fc7905fcc 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -68,17 +68,10 @@ static enum fault_type get_fault_type(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
 
-	if (likely(teid.as == PSW_BITS_AS_PRIMARY)) {
-		if (user_mode(regs))
-			return USER_FAULT;
-		return KERNEL_FAULT;
-	}
-	if (teid.as == PSW_BITS_AS_SECONDARY)
+	if (user_mode(regs))
 		return USER_FAULT;
-	/* Access register mode, not used in the kernel */
-	if (teid.as == PSW_BITS_AS_ACCREG)
+	if (teid.as == PSW_BITS_AS_SECONDARY)
 		return USER_FAULT;
-	/* Home space -> access via kernel ASCE */
 	return KERNEL_FAULT;
 }
 
-- 
2.53.0



