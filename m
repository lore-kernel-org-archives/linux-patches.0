Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D81E1714AE;
	Thu, 15 Aug 2024 13:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728721; cv=none; b=C0gEUsEws1fkAQdFax2tnYmfuLiFZz5xBJL4t5RlxzSXx03fPnwECJUoy4yARQmfmQukmXlry80dk6dNfocxBFDeENWo07STLVjyI5C6VyqhhfDxcvtxHwg8M9NUoLli+NXEdFu7i5GO40hpTdbLASPFm62trcQyWc6V66xhkv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728721; c=relaxed/simple;
	bh=CGCv4LLVMlyPxgtAaiNcFhmLMY7XESAPeS/0wAHDFH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPG0vbnU6+AhZxr//+i63KCN3lEHQ4opIEyCo7Y16wog0q9H2s/kbeocuXhzW+vc6o8RBR7YqWQ6Mp5XibJIRdAj//QuExIJG//eJWTcfAl4Bz/rfgb86axEFqXROCjAUnh/ogBBskGtCNfPDnFmi6W3INJq2QxFPTmnjxJhWFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDCI2Xhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDCI2Xhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C931BC32786;
	Thu, 15 Aug 2024 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728721;
	bh=CGCv4LLVMlyPxgtAaiNcFhmLMY7XESAPeS/0wAHDFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDCI2XhjCyyIEPlx5lPQKRTYuTcL6VHGOEkgSvjiVUH5/8r4wPoT2BuRDnSWT0lXU
	 Ut1eiBaKWUFNsV6SvrIe1/7csUMQgsREr2nsQdBaypwApusqXH/RMWkx71dcLy1Ia2
	 ovvuhGGYIQPlVAByjT8TFzsrBfmkUvK6VdXEdU6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Cavenati <cavenati.marco@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 089/196] perf/x86/intel/pt: Fix topa_entry base length
Date: Thu, 15 Aug 2024 15:23:26 +0200
Message-ID: <20240815131855.487968544@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Cavenati <cavenati.marco@gmail.com>

commit 5638bd722a44bbe97c1a7b3fae5b9efddb3e70ff upstream.

topa_entry->base needs to store a pfn.  It obviously needs to be
large enough to store the largest possible x86 pfn which is
MAXPHYADDR-PAGE_SIZE (52-12).  So it is 4 bits too small.

Increase the size of topa_entry->base from 36 bits to 40 bits.

Note, systems where physical addresses can be 256TiB or more are affected.

[ Adrian: Amend commit message as suggested by Dave Hansen ]

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Signed-off-by: Marco Cavenati <cavenati.marco@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624201101.60186-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/pt.h
+++ b/arch/x86/events/intel/pt.h
@@ -78,8 +78,8 @@ struct topa_entry {
 	u64	rsvd2	: 1;
 	u64	size	: 4;
 	u64	rsvd3	: 2;
-	u64	base	: 36;
-	u64	rsvd4	: 16;
+	u64	base	: 40;
+	u64	rsvd4	: 12;
 };
 
 #define PT_CPUID_LEAVES		2


