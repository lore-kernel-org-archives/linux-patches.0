Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A8D446C9;
	Tue, 20 Feb 2024 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464823; cv=none; b=NJOIyneiZ35YZx/GEFFtj0arI+6fRxjKAg3L3Eq8cC8c+6qjE2zPOQ7PCD9840oB+PiCPv7iuwotDI9FR97/Ku2izM7jMI6P/8X6rIt6C/Wrlporav/uD9Y12AsIipfRELDDSEISOZqw93m9zj28xbMSfisBUfdP9pB1xBojqAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464823; c=relaxed/simple;
	bh=LPPbjdammpKnjaSuLLwOZwN7jmR90/ky+pROkXPr/vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAi1eE8ph+gxIEPp8cfO7hTvcZnwOgsZ8LC1D1c+U9djIcSWfzeHidthASfoOhViG+BO+GgXORzZBlD7pnHO8aIPuMuh7iWiUJUQnKBsf65vA6sdbLr0sXLr1QhObpsK4wfQZkkNvEMjWnh3hUozU79+FkF80fhhPIiS5MIFx9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTQ3V7nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTQ3V7nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E9DC433F1;
	Tue, 20 Feb 2024 21:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464823;
	bh=LPPbjdammpKnjaSuLLwOZwN7jmR90/ky+pROkXPr/vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTQ3V7njizZptY/CbxxOjgHvWhN9pI4Us/V0VHzdEcTALe8nMCnAZIFt802a3Bhe2
	 1waci5llKvw4LomzmhNLlyoZMFw9R/eKICdYqK4tsnUNQT/WLhhLYTMdIJCQAbMf9O
	 Rawvng9eHlvVovzCmPBsB8shrfYwMnmEvt2XtZoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.7 148/309] parisc: BTLB: Fix crash when setting up BTLB at CPU bringup
Date: Tue, 20 Feb 2024 21:55:07 +0100
Message-ID: <20240220205637.807667437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 913b9d443a0180cf0de3548f1ab3149378998486 upstream.

When using hotplug and bringing up a 32-bit CPU, ask the firmware about the
BTLB information to set up the static (block) TLB entries.

For that write access to the static btlb_info struct is needed, but
since it is marked __ro_after_init the kernel segfaults with missing
write permissions.

Fix the crash by dropping the __ro_after_init annotation.

Fixes: e5ef93d02d6c ("parisc: BTLB: Initialize BTLB tables at CPU startup")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -58,7 +58,7 @@ int pa_serialize_tlb_flushes __ro_after_
 
 struct pdc_cache_info cache_info __ro_after_init;
 #ifndef CONFIG_PA20
-struct pdc_btlb_info btlb_info __ro_after_init;
+struct pdc_btlb_info btlb_info;
 #endif
 
 DEFINE_STATIC_KEY_TRUE(parisc_has_cache);


