Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F5A151CC3;
	Tue, 20 Feb 2024 21:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463723; cv=none; b=Qh1Zd+C8cwRr+2qNKLmoUebY2W8f+aWCp3BdAKSv1/75a6axCAsLBh1lvnElp4P3my5+oBQXvyU9qbMOZSoHVRwjvrvd7qffPmOKVQMnkUdUMDCVU70USTJMWyO9P9qs4GVBz/tJ1WyQqpNrgPQs8nwZnb5gevO3xStTsGkdgqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463723; c=relaxed/simple;
	bh=Zbe4/cNyd3lrF8Kg6t4bKK95dhsm0rEQ8BbSRFDdxNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqnnWKI7YCF9hBHhoJDKj9TyIPtDaMchARderMyIqYd/3MzG98rFvb5KLlU73bIZ0Ha8wcf2qScJdwKhpCJiLjuj6KEOO5xgeaYB1lh43yb3POItdSanG1Cj0lfTIxrn4YZ/tKsPhqp8lrgnPxHUCgWDUwVGfnoiG3ZHdbU6uF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kqb2p+3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kqb2p+3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF523C433F1;
	Tue, 20 Feb 2024 21:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463723;
	bh=Zbe4/cNyd3lrF8Kg6t4bKK95dhsm0rEQ8BbSRFDdxNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kqb2p+3rmTJnP5pLEQCNJn/UVmFKMs32H+ukZnlIj3/HB1co/1rgyv3QLCX45qnIx
	 9P6NcOZJoVjOoHSfXafRymuTRDQPM6t1L9OJQURufi/zJe9QDDPoxnycZNDJM35Azs
	 0a0GnavHHqFBYTm+cueOsLrTaNgJn3NRUbBo1T5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 133/331] parisc: BTLB: Fix crash when setting up BTLB at CPU bringup
Date: Tue, 20 Feb 2024 21:54:09 +0100
Message-ID: <20240220205641.750983993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
 arch/parisc/kernel/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 5552602fcaef..422f3e1e6d9c 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -58,7 +58,7 @@ int pa_serialize_tlb_flushes __ro_after_init;
 
 struct pdc_cache_info cache_info __ro_after_init;
 #ifndef CONFIG_PA20
-struct pdc_btlb_info btlb_info __ro_after_init;
+struct pdc_btlb_info btlb_info;
 #endif
 
 DEFINE_STATIC_KEY_TRUE(parisc_has_cache);
-- 
2.43.2



