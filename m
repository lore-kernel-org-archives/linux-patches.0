Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AFA155A4E;
	Mon, 16 Sep 2024 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488553; cv=none; b=CxVa3G1flGHAkg1IVTwp5a0Zd8UoJ2OW2dGUtQiMzrdEFob6MBhXPIP9VC/utDcVC+TfH7K1GA2dO+FtTLXQ6sVIOqy9v6ercz56rCmftUE7qqVd20QpPFhnKcVyj1CwwiH/G7JMIUAgVDIwf/9WtiXs1tsCOpme07XNexQOyVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488553; c=relaxed/simple;
	bh=rHrGDHhdH+oCybKV5VaZxH4OYzrgMfTsYTnP3MhA6w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di+t1JbJfMufVvQL+RZQgx7dbDGCE5Kq2dnQlQtMhqbMdYWtGZBvKNlL32SmYjtLcNADbqHobv4hewsXZMW8CPR3GdhZwh+BnpUaeAGmyCoLM6LxXzfEyVL2RlYCerwzk6H/0SeuZotJEd3eRi+K7A/FJwXvwmxxkjVWDXR1Hx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4ErDFe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4ErDFe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88E6C4CEC4;
	Mon, 16 Sep 2024 12:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488553;
	bh=rHrGDHhdH+oCybKV5VaZxH4OYzrgMfTsYTnP3MhA6w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4ErDFe3ERjzYKL6+ZNsm5RRm8fBcgh7M2jV37CH4gCBDobDoDD34+TWzkzccTpBL
	 NJaQLCHOb80C+SM9P+wt7UJkuLt3vsYM2hHXM/iVBxxhMa8g961COUX8UcrhQQhMWV
	 sfZ6sKOA1ToFvk68u03Tqzfmg7ReQHqa/NggTVLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/91] s390/mm: Prevent lowcore vs identity mapping overlap
Date: Mon, 16 Sep 2024 13:44:08 +0200
Message-ID: <20240916114225.569160063@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
index d48c7afe97e6..89fe0764af84 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -741,7 +741,23 @@ static void __init memblock_add_physmem_info(void)
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
@@ -939,6 +955,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Do some memory reservations *before* memory is added to memblock */
 	reserve_pgtables();
+	reserve_lowcore();
 	reserve_kernel();
 	reserve_initrd();
 	reserve_certificate_list();
-- 
2.43.0



