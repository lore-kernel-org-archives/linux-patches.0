Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217053DD849;
	Wed, 30 Sep 2026 19:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796260; cv=none; b=Y0dXVKjJJxaKKsyd7Rv5AEFkBZ3pf3EhjNvhH0uW9lFUEUMxm5Mz6D7AtSUYOxGkxUjGYdPsNxyvvcgsVv/ywZl/b65g0bOZ806kS69gIBh8H8lBPMJ5X3zCd9P9Sl7iei8nT1xEGM66ny829Itr2HzvwHiLYe0ObTRNWcSG0u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796260; c=relaxed/simple;
	bh=QOwVEvSvryNrcxy6QB8RiHzQiOsqjAgRViJJwlUF46w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSsFf03l8G+kx6JevfBxNtZEeAZwSBo1pTg4sx4Chrq+foShh67IAQT6bDv5z04AuWITd9odxcEkj+7WxhYUo3rg25M7HHAUTUS7fpGVCHcG3K9fuRLg3Zk1ytDpShYu1Q8JVajVFtMSq+Wo3s1+jKEECgoxS8E2kMmMVX4nqm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/BWZLwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/BWZLwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED9D1F000FF;
	Wed, 30 Sep 2026 19:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796259;
	bh=OeNvjjSempPpE1X+WNJdR3wyJ2W5EQnstHPxxZTn5wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/BWZLwqXd9nJOT4JuDO5n5FEAk+bzUhW1apQxalqb+G8zqQU1fiyM0QG69/ssrXI
	 32rPAJlGZSUlPv5xoLt4LSIR2HjPFzdKO7nVbplNiLGas1dN+/uFdeeaL4FD6HaaxN
	 A99u7wOs4hc+cPaC/sl8Z3YG3e2HxJILKYZDni7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 0848/1193] arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc
Date: Wed, 30 Sep 2026 17:25:32 +0200
Message-ID: <20260930152453.077930682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

commit 955d86e5f3b95b731991fdb84966c50b16314629 upstream.

swsusp_arch_suspend_exit() reinstalls the restored kernel's hyp stub
vectors with an hvc, but never passes the arguments. x0 is not set to
HVC_SET_VECTORS and x1 is not set to the vector address, so the stub
dispatch falls through and returns without writing vbar_el2. EL2 is
left pointing at the trans_pgd copy of the vectors, a page that
swsusp_free() releases right after resume.

Set the arguments up the same way __hyp_set_vectors() does.

Without this fix, Vladimir was able to trigger a hang when resuming from
hibernation with CONFIG_PAGE_POISONING=y and page_poison=on.

Fixes: 788bfdd97434 ("arm64: trans_pgd: hibernate: Add trans_pgd_copy_el2_vectors")
Cc: stable@vger.kernel.org
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/hibernate-asm.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/hibernate-asm.S
+++ b/arch/arm64/kernel/hibernate-asm.S
@@ -89,6 +89,8 @@ alternative_insn "dc cvau, x4",  "dc civ
 	isb
 
 	cbz	x24, 3f		/* Do we need to re-initialise EL2? */
+	mov	x1, x24
+	mov	x0, #HVC_SET_VECTORS
 	hvc	#0
 3:	ret
 SYM_CODE_END(swsusp_arch_suspend_exit)


