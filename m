Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF282820D8;
	Wed, 23 Apr 2025 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420384; cv=none; b=S9C2Hifx/cWtz1i2+zYYXqP6dBMPrY5lVVVU4VV+n877TResBJmRDFAwJ6QChWFlq8BrdHg+MQXc3ytm+Sm7vvEb5j2Zzv3N6Z4rDkjI6mmpfh3OnQn5x7bjmE/zkgRoR4FVdeW5AgnzsOOZK6Dds0z6gLX/LUZQ7h5NrAI518c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420384; c=relaxed/simple;
	bh=9R+zCwnrL4f+QCKOT1SfgH6B7ExxwkFC2Lnlf+w5eVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lI7F6f8Q9R3QTS8iWmZfcMF5cLTWyp4m4KsAx0mdvkXLD9tm+SOphDfSBGnyy1AzFqISEX8361SLK8VGQ3Cg3QCFZOxWiHxBB+zlWFrPzKxw7EyIUONuRjr/fu5AAeKoIULkBxSogdCfv/trHCWiRYb/GQBb7bCc1JZWa4fWaDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3VMOZc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3VMOZc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E90C4CEE3;
	Wed, 23 Apr 2025 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420384;
	bh=9R+zCwnrL4f+QCKOT1SfgH6B7ExxwkFC2Lnlf+w5eVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3VMOZc3sfJfTYmeTWZw7z7LtMo+2bTHSF5dEo16PQsq1wyR0z+S//3or53okwN4L
	 HRQEkEs1bq1CrMnYpq+7MPkGD4KhUejwnuSbrHmHt9VBgenNIoS5AicZm4QC0Opx8w
	 +AMokfIqnSyppdAuAiWyGn/aYBA0h9R38R/aKvXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Will Pierce <wgpierce17@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 087/241] riscv: Use kvmalloc_array on relocation_hashtable
Date: Wed, 23 Apr 2025 16:42:31 +0200
Message-ID: <20250423142624.137079785@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Pierce <wgpierce17@gmail.com>

[ Upstream commit 8578b2f7e1fb79d4b92b62fbbe913548bb363654 ]

The number of relocations may be a huge value that is unallocatable
by kmalloc. Use kvmalloc instead so that it does not fail.

Fixes: 8fd6c5142395 ("riscv: Add remaining module relocations")
Suggested-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Will Pierce <wgpierce17@gmail.com>
Link: https://lore.kernel.org/r/20250402081426.5197-1-wgpierce17@gmail.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 47d0ebeec93c2..0ae34d79b87bd 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -648,7 +648,7 @@ process_accumulated_relocations(struct module *me,
 		kfree(bucket_iter);
 	}
 
-	kfree(*relocation_hashtable);
+	kvfree(*relocation_hashtable);
 }
 
 static int add_relocation_to_accumulate(struct module *me, int type,
@@ -752,9 +752,10 @@ initialize_relocation_hashtable(unsigned int num_relocations,
 
 	hashtable_size <<= should_double_size;
 
-	*relocation_hashtable = kmalloc_array(hashtable_size,
-					      sizeof(**relocation_hashtable),
-					      GFP_KERNEL);
+	/* Number of relocations may be large, so kvmalloc it */
+	*relocation_hashtable = kvmalloc_array(hashtable_size,
+					       sizeof(**relocation_hashtable),
+					       GFP_KERNEL);
 	if (!*relocation_hashtable)
 		return 0;
 
-- 
2.39.5



