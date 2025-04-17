Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AEC18C034;
	Thu, 17 Apr 2025 18:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913427; cv=none; b=Kiv6FtGQYmnJvUc5J0kwxoWKhUZoWWFncwYYSPdRHQVCpMSlBP+Eamr2CHMKdP6TQmSGJgWONjSHgWDzBoCOGv3R9bDWWY+ZMOPqD4hAsKJpE/j3RzmM3LW5oGBxO0CPGdc82aMK23iSwYGijDXg0vfbHGKU5g5K8QoARhYk8Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913427; c=relaxed/simple;
	bh=RP0f8/JQHnfBJstUic2tTIgn0oNlYCzPuSjPxEXZCc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7yEImFBlHMQXsNNWLv6He+ipun6dTKTbsuZSJq07mG9vFWxUK734um71loqnunAxVr09WBKvWEYItEZ8M61mfprGnup4mg8xfxonPaoxirvlxjehu2orgLNTSIK0i8dHvaAKCiwqz3mlh2ca6gwaEWDfytJV7Oj8s2gtjquIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snRf48rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snRf48rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225CDC4CEEA;
	Thu, 17 Apr 2025 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913427;
	bh=RP0f8/JQHnfBJstUic2tTIgn0oNlYCzPuSjPxEXZCc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snRf48rnXKLEogIEjOmrlZ9T7Z2wX1IAezko38OOp7E0c+xXMrjCNY1AyYT9fJNm+
	 R0TBGK8iXC7qQBAwduHvwou4mW8UiYY6A+lVvV+lj5lpH+WJlqWzw4UAjlF1MqZih7
	 EyTGRupAAVla2YgQtrP2dBpncCsc8+lXQJ0aiU7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.14 336/449] arm64: mm: Correct the update of max_pfn
Date: Thu, 17 Apr 2025 19:50:24 +0200
Message-ID: <20250417175131.709220831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1361,7 +1361,8 @@ int arch_add_memory(int nid, u64 start,
 		__remove_pgd_mapping(swapper_pg_dir,
 				     __phys_to_virt(start), size);
 	else {
-		max_pfn = PFN_UP(start + size);
+		/* Address of hotplugged memory can be smaller */
+		max_pfn = max(max_pfn, PFN_UP(start + size));
 		max_low_pfn = max_pfn;
 	}
 


