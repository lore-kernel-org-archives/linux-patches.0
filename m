Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C4159583;
	Mon, 16 Sep 2024 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488299; cv=none; b=IhwuWU33jIjZuzCRNC6SoofqvONVAF9eJLRi2vKI9IgycQ+bdGEEWnI7Lr9ZDhU9c/aGFsanuZj5SOubP9HmsjCn8ynX9XqJM+e612RhIPlyF5oYgN3c6gz4bPM8Zzp+cuaxykGCQ2oWlpAkCt3bPpmzguI+5Sg9R4LemLJ+gE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488299; c=relaxed/simple;
	bh=xr8nqEXk+HGhNH/jQ96b1czQQepI7DaEqZvny0qkwos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReUhMyuDacXOlsUU/vzV3X6zYNXZyT3sSNP4sWjeskY2LjK8FY24oKabfKppZbdGkAygMQQ2Q9n08NPSxYhfzd1T2b4tMwPrXWZfuYo8H3jxwJmCBrhoeBQcE8Rj9/z936g4CnKfQ5NBWdvQvYkKZSC5L2TssU7jSpfP8XKslsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzW6pW9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzW6pW9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76844C4CEC4;
	Mon, 16 Sep 2024 12:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488298;
	bh=xr8nqEXk+HGhNH/jQ96b1czQQepI7DaEqZvny0qkwos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzW6pW9v6CUwBRGyNsbDeuUJfynRYmjdJgK8CMsQOzDJlLPtFwSRzg0A0ocAiosen
	 gVwaUi0KRXbGcU98wz1N/MrLAENhDFFtn7PAlYp0Kt8rSJ98mMB0y5enXWP7fkQSdA
	 jkTJYR2jXRz+G8NZvgwXhVqQcMHK8mym25JKheiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/121] s390/mm: Prevent lowcore vs identity mapping overlap
Date: Mon, 16 Sep 2024 13:43:32 +0200
Message-ID: <20240916114230.385496328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit a3ca27c405faad584af6e8e38cdafe5be73230a1 ]

The identity mapping position in virtual memory is randomized
together with the kernel mapping. That position can never
overlap with the lowcore even when the lowcore is relocated.

Prevent overlapping with the lowcore to allow independent
positioning of the identity mapping. With the current value
of the alternative lowcore address of 0x70000 the overlap
could happen in case the identity mapping is placed at zero.

This is a prerequisite for uncoupling of randomization base
of kernel image and identity mapping in virtual memory.

Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 610e6f794511..4b1afd8ac3ee 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -734,7 +734,23 @@ static void __init memblock_add_physmem_info(void)
 }
 
 /*
- * Reserve memory used for lowcore/command line/kernel image.
+ * Reserve memory used for lowcore.
+ */
+static void __init reserve_lowcore(void)
+{
+	void *lowcore_start = get_lowcore();
+	void *lowcore_end = lowcore_start + sizeof(struct lowcore);
+	void *start, *end;
+
+	if ((void *)__identity_base < lowcore_end) {
+		start = max(lowcore_start, (void *)__identity_base);
+		end = min(lowcore_end, (void *)(__identity_base + ident_map_size));
+		memblock_reserve(__pa(start), __pa(end));
+	}
+}
+
+/*
+ * Reserve memory used for absolute lowcore/command line/kernel image.
  */
 static void __init reserve_kernel(void)
 {
@@ -915,6 +931,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Do some memory reservations *before* memory is added to memblock */
 	reserve_pgtables();
+	reserve_lowcore();
 	reserve_kernel();
 	reserve_initrd();
 	reserve_certificate_list();
-- 
2.43.0



