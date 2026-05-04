Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679883DEAC0;
	Mon,  4 May 2026 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904175; cv=none; b=WG1QBjJou6UkuKAWqqrCkcwTbER7otpmxQ3jUhtoe2KCTRzwRI5Rca91QcJeGQ0rQSZW+sCnjU9rNgTm2G50OZVkApLUhl8UJARW3r06CReOcbWclFssOcPpQds0qL0+VAyUqj2VWRdwVssGqXG0tXV6aHjPB3PaA68i4Pe6GT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904175; c=relaxed/simple;
	bh=8N1p3VMbzMU3hZaAIvyZdjLDs5uT0hKWxl36PSaPyyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2lkIWs7PBKQ88QwbaIfYuS2xVYSiWGBQrGfTHlH48HVaIZ/NxI9ROg2UZ4vcnWnY8oNEBJpWQGx19EJrnrlKZRHkVoY/8or+MJ8KiQv/DMs5kMVbwLHY8CPWm1+IOBW0pCRZbevo/MthLHaOoOwZk3Y/F2a8piuYfvkz590NqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTKkUZPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTKkUZPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CA3C2BCF4;
	Mon,  4 May 2026 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904175;
	bh=8N1p3VMbzMU3hZaAIvyZdjLDs5uT0hKWxl36PSaPyyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTKkUZPisXMA2B7j43UBADiTLenDOXkN/6wNvuOO7b03RwAS/jcpTu0Ye3xTjTyz6
	 kqabZDeV/0eNXHCjekGkv54XdgoDT9WGAUH3IFhzpB3Ktx9GpnZbmfDKnrPgN6oSnC
	 +XL39IvFG9acOYUsEdzD6d707/DflEOKvOmAarxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Ruley <brian.ruley@gehealthcare.com>,
	Will Deacon <will@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.18 195/275] ARM: 9472/1: fix race condition on PG_dcache_clean in __sync_icache_dcache()
Date: Mon,  4 May 2026 15:52:15 +0200
Message-ID: <20260504135150.320893531@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Ruley <brian.ruley@gehealthcare.com>

commit 75f9a484e817adea211c73f89ed938a2b2f90953 upstream.

This bug was already discovered and fixed for arm64 in
commit 588a513d3425 ("arm64: Fix race condition on PG_dcache_clean in
__sync_icache_dcache()").

Verified with added instrumentation to track dcache flushes in a ring
buffer, as shown by the (distilled) output:

  kernel: SIGILL at b6b80ac0 cpu 1 pid 32663 linux_pte=8eff659f
          hw_pte=8eff6e7e young=1 exec=1
  kernel: dcache flush START   cpu0 pfn=8eff6 ts=48629557020154
  kernel: dcache flush SKIPPED cpu1 pfn=8eff6 ts=48629557020154
  kernel: dcache flush FINISH  cpu0 pfn=8eff6 ts=48629557036154
  audisp-syslog: comm="journalctl" exe="/usr/bin/journalctl" sig=4 [...]

Discussions in the mailing list mentioned that arch/arm is also affected
but the fix was never applied to it [1][2]. Apply the change now, since
the race condition can cause sporadic SIGILL's and SEGV's especially
while under high memory pressure.

Link: https://lore.kernel.org/all/adzMOdySgMIePcue@willie-the-truck [1]
Link: https://lore.kernel.org/all/20210514095001.13236-1-catalin.marinas@arm.com [2]
Signed-off-by: Brian Ruley <brian.ruley@gehealthcare.com>
Reviewed-by: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: 6012191aa9c6 ("ARM: 6380/1: Introduce __sync_icache_dcache() for VIPT caches")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/flush.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -304,8 +304,10 @@ void __sync_icache_dcache(pte_t pteval)
 	else
 		mapping = NULL;
 
-	if (!test_and_set_bit(PG_dcache_clean, &folio->flags.f))
+	if (!test_bit(PG_dcache_clean, &folio->flags.f)) {
 		__flush_dcache_folio(mapping, folio);
+		set_bit(PG_dcache_clean, &folio->flags.f);
+	}
 
 	if (pte_exec(pteval))
 		__flush_icache_all();


