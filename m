Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC382263F54;
	Wed, 23 Apr 2025 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419881; cv=none; b=TGUtBX0gfDpHl6y+65mH6jDHte8k2NPjcWggMHOGpBMxmZPNEUlaPHRwPrEjf5/BW52vcgP65mWgnwLYfqobD7RDzoAUcmQsrpPYdng3bu2XKkielz/qWoaNQR61ZXjGI5BmC/ZKuu2jxwUUzM3toZeMaZLYEKFZQbOUm2CiDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419881; c=relaxed/simple;
	bh=C72fxhGyFQ0qcDqt9FiVUKq/CCXhPf0cH5oadzxNZ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5zlG+/FoyuuKLj5Pjy7cKBvVYZqGiCNhW5RD4flQDBkpYr8t3ZeW/44Fl8JgFOSV+MAJ5WnP4q69mn+lKXM3YM4LiDcPZWwv4NOCMZSwmTa3GoEecFOgMsQi3/QjvgYXTJUD05W3tTsKRNGVS6TJnrGxc/Sh31Ch5HQE7uRzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWm7jQ4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWm7jQ4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61961C4CEE2;
	Wed, 23 Apr 2025 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419881;
	bh=C72fxhGyFQ0qcDqt9FiVUKq/CCXhPf0cH5oadzxNZ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWm7jQ4fSP7qL/J96Pavh/zUJr1PQ7Jxc+6fXd5R3XRzirQdY5Ky68gus/yYVqkS1
	 qrh3Rws9f8ceDNChjh9nxXMbVKRIWHX0ds8btqDBpIsUSEUYmPKZk24HiiThbYWVkO
	 c6h5Pex7mCcHb6BvhKdStcEp2mEsLXhu9WMmMXNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Will Pierce <wgpierce17@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/223] riscv: Use kvmalloc_array on relocation_hashtable
Date: Wed, 23 Apr 2025 16:42:27 +0200
Message-ID: <20250423142620.181031724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



