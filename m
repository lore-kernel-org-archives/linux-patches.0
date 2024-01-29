Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F56166D;
	Mon, 29 Jan 2024 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548068; cv=none; b=ZELuwXy+4kepJdxVgaeSSAmRt8Tmd2YkRCgOBBzrfJRwOPKoHgcJo4FVuTvNsWnZLtu9mwCPmQmT5XuZAIj1qvmsWafuTmKlDbB3rJ12dTMMqI+YxgL22O6FuMDxpjx5nM5nFZ9wR2qGvQC6TItEdXspNIyItMt2HuuzPW3Cyk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548068; c=relaxed/simple;
	bh=nEsdTO+fvEaW0AKAjHLZHsn178KAY5QEIhKTZLVo7L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGsSKZKrG5+kkS89i7ybUfIod7e9DpSZ6XN0mOswW9Lx29maKCa4oH7IJM4XV2I2X06cZJ4Om4dpD02vzwXAP8EqgFe/git8HLi73m7ao9asLuTSOYMiQYoNDqgeqkH6YWv/rTjDUib9q2wYUub+ibgLoXOUwrMQa4ktBxS+ooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qiqj4ipx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qiqj4ipx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515E4C433F1;
	Mon, 29 Jan 2024 17:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548067;
	bh=nEsdTO+fvEaW0AKAjHLZHsn178KAY5QEIhKTZLVo7L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qiqj4ipxNEYGP1zl8FWh5J/kIbiX2rAQ9XBXMLOf1bmPB3JFo755bZvz0SS1YTk2J
	 AQCZ/oLe+jr+JAtYec66EKueMIUCk58r6HDePL6Gwa0Q1zC7RK+icMJN/WQD4fghiT
	 PMnjhIl+2scXKKEUK2g2HLcwdcqegl/9kP3U+eAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Julia Lawall <julia.lawall@inria.fr>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 057/346] riscv: Correctly free relocation hashtable on error
Date: Mon, 29 Jan 2024 09:01:28 -0800
Message-ID: <20240129170018.077725448@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

[ Upstream commit 4b38b36bfbd83b23e20c172d08dd85773791e3bd ]

When there is not enough allocatable memory for the relocation
hashtable, module loading should exit gracefully. Previously, this was
attempted to be accomplished by checking if an unsigned number is less
than zero which does not work. Instead have the caller check if the
hashtable was correctly allocated and add a comment explaining that
hashtable_bits that is 0 is valid.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Fixes: d8792a5734b0 ("riscv: Safely remove entries from relocation list")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202312132019.iYGTwW0L-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202312120044.wTI1Uyaa-lkp@intel.com/
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240104-module_loading_fix-v3-2-a71f8de6ce0f@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 5cf3a693482d..91f7cd221afc 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -747,6 +747,10 @@ initialize_relocation_hashtable(unsigned int num_relocations,
 {
 	/* Can safely assume that bits is not greater than sizeof(long) */
 	unsigned long hashtable_size = roundup_pow_of_two(num_relocations);
+	/*
+	 * When hashtable_size == 1, hashtable_bits == 0.
+	 * This is valid because the hashing algorithm returns 0 in this case.
+	 */
 	unsigned int hashtable_bits = ilog2(hashtable_size);
 
 	/*
@@ -763,7 +767,7 @@ initialize_relocation_hashtable(unsigned int num_relocations,
 					      sizeof(*relocation_hashtable),
 					      GFP_KERNEL);
 	if (!*relocation_hashtable)
-		return -ENOMEM;
+		return 0;
 
 	__hash_init(*relocation_hashtable, hashtable_size);
 
@@ -789,8 +793,8 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	hashtable_bits = initialize_relocation_hashtable(num_relocations,
 							 &relocation_hashtable);
 
-	if (hashtable_bits < 0)
-		return hashtable_bits;
+	if (!relocation_hashtable)
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&used_buckets_list);
 
-- 
2.43.0



