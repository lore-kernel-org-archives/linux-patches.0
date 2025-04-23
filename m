Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53728B4FF;
	Wed, 23 Apr 2025 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421327; cv=none; b=mzJr/DINxi9d+6K4X5HwyROriskPAme8U2pWd0wZAWuan3cmLTYSGXZiv0xMuwqNqUJ028PnHU9LtRM3DZdfR+C3uiPgEmJ2sx5qlgwEC3wCEXHI1pvG6/8WYhO8o15URIMrG8RzUOGRKkHwKd5MfqpRNemroZ1Xn5JVvQsbHcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421327; c=relaxed/simple;
	bh=fUGVUpE/4joO9VilTlofKxQGM/q1L0OBAExAG7V7wM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF9KJ2uezRP866TCPL2DLiYgYyAaafiCX0H5Xa8xEf93C2yyW2zirKGQdl2cLGyfsv46bhJY1diAa5YluDFHEZgPvEM875BBu/aPP2DR0zlDlgm3unvZLxD5gy8m5/688kAXEFAj6KgLnPoilRROnq7Rg+lBkr1eXk8god0Oosg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrjtR7//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrjtR7//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0081DC4CEE8;
	Wed, 23 Apr 2025 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421327;
	bh=fUGVUpE/4joO9VilTlofKxQGM/q1L0OBAExAG7V7wM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrjtR7//p8ylCCKO0UOEW8gwFpXmWQ68iPqzS840nKTnOrazD+eN5OW1ntvP0ZDOA
	 3YDOdaV1mUBsykl+OfnFo7JexAkvE8JGxbbHEnr1PPOg0eNKLtvQFcpNu36q0+0IiB
	 J24yerWNbWaKPho5sl7y12bYuMbDLJuNT7zqgaIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 127/291] arm64: mm: Correct the update of max_pfn
Date: Wed, 23 Apr 2025 16:41:56 +0200
Message-ID: <20250423142629.590228534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhua Huang <quic_zhenhuah@quicinc.com>

commit 89f43e1ce6f60d4f44399059595ac47f7a90a393 upstream.

Hotplugged memory can be smaller than the original memory. For example,
on my target:

root@genericarmv8:~# cat /sys/kernel/debug/memblock/memory
   0: 0x0000000064005000..0x0000000064023fff    0 NOMAP
   1: 0x0000000064400000..0x00000000647fffff    0 NOMAP
   2: 0x0000000068000000..0x000000006fffffff    0 DRV_MNG
   3: 0x0000000088800000..0x0000000094ffefff    0 NONE
   4: 0x0000000094fff000..0x0000000094ffffff    0 NOMAP
max_pfn will affect read_page_owner. Therefore, it should first compare and
then select the larger value for max_pfn.

Fixes: 8fac67ca236b ("arm64: mm: update max_pfn after memory hotplug")
Cc: <stable@vger.kernel.org> # 6.1.x
Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250321070019.1271859-1-quic_zhenhuah@quicinc.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1578,7 +1578,8 @@ int arch_add_memory(int nid, u64 start,
 		__remove_pgd_mapping(swapper_pg_dir,
 				     __phys_to_virt(start), size);
 	else {
-		max_pfn = PFN_UP(start + size);
+		/* Address of hotplugged memory can be smaller */
+		max_pfn = max(max_pfn, PFN_UP(start + size));
 		max_low_pfn = max_pfn;
 	}
 


