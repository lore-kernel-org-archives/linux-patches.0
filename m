Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335671EA8D;
	Mon, 12 Aug 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479111; cv=none; b=r39tBbC85U/z1VfdDnvq4zCETiuD23+6hfiZyEc54KLmQ93sFVKjVk821ErgD5JTpmnAs5CqDr//RWvBc6yx+cgkm6ZZhbzeRe/FmjN/bHUiDrUWzfZgsgz6GHLefEsPieo0ipH/PLSHqh1We3bMYKMG3PBEh673Nrz7Q0M/cUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479111; c=relaxed/simple;
	bh=LUo+1eoCO4Zu3JjXSksWH99DT/Z4J5+GNqiB0FpOn/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1pV0WhEY3mcsfcSXeB4LHMsCLzImashLbWyM5DUw3pKJyPm7a06M1LhlV6zZVq0rb70/pD9yLVmYCNFngvg/5zD76JNakaZqjyz1QujNOVZDi0y6vlZwAo8PAGbfqM2RTOJLQmMXaN43jVeDBxbRWxByk2BleH41FHtuFDUQ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcPGNba2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcPGNba2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194EC32782;
	Mon, 12 Aug 2024 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479111;
	bh=LUo+1eoCO4Zu3JjXSksWH99DT/Z4J5+GNqiB0FpOn/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcPGNba2ZClynFRkTCLg7OnBrgxpCYmIq+VgbI8Szr2kKHe3xhBnHbZPqo7sOoL4B
	 jv1us50OYp0hfYSwmvFUPZ3FrADGL5D88KdkiyCb8kSZZSzQf/D0JldiVVzljTsIuO
	 35qnzLeTaXMM64NZazd8+kzUMzN8/1SBebwNlhvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Yves-Alexis Perez <corsac@debian.org>,
	David Hildenbrand <david@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Christoph Lameter <cl@linux.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 137/150] mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines
Date: Mon, 12 Aug 2024 18:03:38 +0200
Message-ID: <20240812160130.455908977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit d9592025000b3cf26c742f3505da7b83aedc26d5 upstream.

Yves-Alexis Perez reported commit 4ef9ad19e176 ("mm: huge_memory: don't
force huge page alignment on 32 bit") didn't work for x86_32 [1].  It is
because x86_32 uses CONFIG_X86_32 instead of CONFIG_32BIT.

!CONFIG_64BIT should cover all 32 bit machines.

[1] https://lore.kernel.org/linux-mm/CAHbLzkr1LwH3pcTgM+aGQ31ip2bKqiqEQ8=FQB+t2c3dhNKNHA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240712155855.1130330-1-yang@os.amperecomputing.com
Fixes: 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on 32 bit")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: Yves-Alexis Perez <corsac@debian.org>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>	[6.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -608,7 +608,7 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret;
 
-	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
 		return 0;
 
 	if (off_end <= off_align || (off_end - off_align) < size)


