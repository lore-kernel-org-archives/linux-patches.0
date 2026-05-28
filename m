Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434102F549F;
	Thu, 28 May 2026 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001347; cv=none; b=lsKGZGTiCJf+lFkS78wtFZ6C4IC3GgRabvI40tLoYg/O/kWXeHJbZjiteQZ5JneEEp/pMBUWUL5sixAeHVblIcjI3ekVk672Bq9CWnoNl9cZehy8eLqH0iE1iECSIiGj7V5knIQ7vLABNUhkJ50W4Idf9t9NIGRqmMzYlzNwfd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001347; c=relaxed/simple;
	bh=QOHG5oYegDifLdw4U11jmubiXazp1BEHXOo4J1kZJUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhMCMiyV1T+8WtQORC3ZR+1upKLWUcpbgR4i9hLnNihdH2A6gtYfLTPyhKDoqUx+2kCWZSeJ/ks/NsZpZOp2yh6m4Zx2VLmkRNfvzmkqpumAR7iTNGdNtIIinaggjvFBON4Tf9vQtAt9RwqMnAEjmeVVErm6zVw4Cad4mWZzRw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6F270U4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6F270U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13161F00A3A;
	Thu, 28 May 2026 20:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001346;
	bh=xkCf01CKnhw1dNxS9C43kCx3bmazgtRH6rK1SUo8UlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6F270U4eNMWgmB90Q6QvicOVplHY2V2baW8QDhJANJmhyfttKn8W0RhHH/nsMi8u
	 LJXFY2r1MALGXs6WwG7xCEZjHhXLXedaDm05ahK2aUylJ1yFmBxo6BFwMJvQI0eBwj
	 GkrtUtR1FyuNBiUQ1zCzTeo0kuzvM8LfIHTMV+IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 068/186] LoongArch: Remove unused code to avoid build warning
Date: Thu, 28 May 2026 21:49:08 +0200
Message-ID: <20260528194930.783146045@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 0ccc9d47cf020994097ff51827cebd04aa2b0bf4 upstream.

After commit feee6b2989165631b1 ("mm/memory_hotplug: shrink zones when
offlining memory"), __remove_pages() doesn't need the "zone" parameter
so the "page" variable is also unused. Remove the unused code to avoid
such build warning:

arch/loongarch/mm/init.c: In function 'arch_remove_memory':
arch/loongarch/mm/init.c:134:22: warning: variable 'page' set but not used [-Wunused-but-set-variable=]
  134 |         struct page *page = pfn_to_page(start_pfn);

Cc: <stable@vger.kernel.org>
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/init.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -106,11 +106,7 @@ void arch_remove_memory(u64 start, u64 s
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn);
 
-	/* With altmap the first mapped page is offset from @start */
-	if (altmap)
-		page += vmem_altmap_offset(altmap);
 	__remove_pages(start_pfn, nr_pages, altmap);
 }
 


