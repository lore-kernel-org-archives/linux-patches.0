Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A001A76A5;
	Tue, 30 Jul 2024 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359800; cv=none; b=Iip/OO/MH4E9e16ulyHUE40/r3VkPBvX7Lj5qKogxPR45SFsB1dv0UcIXlBYqkjWpI1wkCWNZ+lZ0WqfLKW39pRI6L07yjgybYupnxbEiiyPCsgscZfUduzV9l2A8uCdvfeL5cUs8zqkJjtjI6HUWJ+E//UR/Lk7shhM48dM/+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359800; c=relaxed/simple;
	bh=8v7pgffPjnS12PtuV+eDkGvST1XDgy5L9T7DWMwiPf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxkAtkGyAISUFbA26lDctJFb75kHDnwL5QoS5koYugzU9tSQC4Lv3HKsFZX7iT8s3Gkj9iONWpAxP+9JV6Tvoerk41CSuN9A5Iuuhh9keAYn+Ry5iFgcG4NnlaC7gbP32FwvvntiO6ncMQVgHJO+ZU34xdLS/gRdrI1jYh1QFbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKXQIMbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKXQIMbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF758C4AF11;
	Tue, 30 Jul 2024 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359799;
	bh=8v7pgffPjnS12PtuV+eDkGvST1XDgy5L9T7DWMwiPf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKXQIMbjcsV7nbmlgvSrYZNx2rva4w/QtP+7V+63wRWmu3Bz6p1yY7z59WPaoJk+W
	 5AZ40o9586OUHDCtTuj3o52xMPMp9paXcpzaJG2USAFgWakePgWWyCQstbXA+P2NMU
	 hOde95dIVhcrUSOf/hCzaKZ1oAMOwNfPwtXvqxZ0=
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
Subject: [PATCH 6.10 534/809] mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines
Date: Tue, 30 Jul 2024 17:46:50 +0200
Message-ID: <20240730151745.829576651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -857,7 +857,7 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret, off_sub;
 
-	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
 		return 0;
 
 	if (off_end <= off_align || (off_end - off_align) < size)


