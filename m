Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D88D1DE885;
	Thu, 17 Apr 2025 18:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916010; cv=none; b=OrgiprsJhsv3eqhBX45BaMA9fzWRDXvlRe0cRKvgQQvJ9m7xrUqphAwrQ277k7/q2yr07vJJxrybRTzPJ4/LT+PS3+Dg7fpTzuaUaRJT0doSmyzLSNQbwvS7w5Hn5WUqiP6i8QR/rURWYJLmRE8CvasRymnrieMV7+cLUnU6mlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916010; c=relaxed/simple;
	bh=vQqopDpQinO6z/KRO3Bk1MBVrdY+4JG5UNeQJwMFJdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuqJjIXxhzDcYStkoHGAAVJSgyxH8hd8lTGw5jxAXghO3mFbznLA4WbogSgdMvVb9e6QDbbhWsQQCUTOFu5MH3OKXPBncHR4aKIvGpqc4L48H4uY7KWwnXKu9nWmF1sH3CvcQT8VGVN1ZbSo9WtwpwQsdpf3A5WR4BTqGaejsbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZQYEbMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZQYEbMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EEBC4CEE4;
	Thu, 17 Apr 2025 18:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916010;
	bh=vQqopDpQinO6z/KRO3Bk1MBVrdY+4JG5UNeQJwMFJdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZQYEbMvL1UavJ39rx7fzeFpfj4av0IK9GvqvRriFrISPFi57/7Ab9DSjmncJrB00
	 HR63CZ0bT5ySJnqJP2Z0dsOqtpcZNb0e4e+06/yKK0XgML+1kfFWPd/6RUxtbsHRoY
	 h02i82muyQyynLdo2EDMec9lpjNIGP5ZntjBPKj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 286/393] arm64: mm: Correct the update of max_pfn
Date: Thu, 17 Apr 2025 19:51:35 +0200
Message-ID: <20250417175119.118962696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1360,7 +1360,8 @@ int arch_add_memory(int nid, u64 start,
 		__remove_pgd_mapping(swapper_pg_dir,
 				     __phys_to_virt(start), size);
 	else {
-		max_pfn = PFN_UP(start + size);
+		/* Address of hotplugged memory can be smaller */
+		max_pfn = max(max_pfn, PFN_UP(start + size));
 		max_low_pfn = max_pfn;
 	}
 


