Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CAF183CA6;
	Mon, 12 Aug 2024 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479726; cv=none; b=maJAF/jiVmmw+Lj6d4nrFBk+c6Xn4dxGrFTVNe90klUMRlnwqJ9d6xGPlMGRXHenwDfeY9sKV9JGbf6jBH1SwgHVOzP4cGBOwxatJ558DdV1Fc1ErH+2q6iNL89Dd+6+Vvhop1DF6H48wrS+3fvYvPqHnRFHLiZRGuXh0X190Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479726; c=relaxed/simple;
	bh=x+UpDxw4qVHUXvNgdWu9ZGGCjgh0HoIoIdVRpM7UyEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pd/A6h0brrRXt4SVFiz87gVtfR76ea5A53H7vlGDLouRz4OMXTXSiVgt03ZVU39REdom0PxnKqV7jt7MVUAs3Q4C6Nnaw1nlaxDyZCQfd8O038BHGZjdqbHLu+9Rc8/q3TNf290oXUEMacD1X+xc+FPRGnQmoqOXCDR/4EgPrnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/WK0+QD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/WK0+QD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77614C32782;
	Mon, 12 Aug 2024 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479726;
	bh=x+UpDxw4qVHUXvNgdWu9ZGGCjgh0HoIoIdVRpM7UyEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/WK0+QDJXvZ3qC7SJFox0e7I9IRA3pvOkJ2r5cocYRJKs1Kij7lqOVHqRAdXrjAr
	 kJ09YgkQf3TMlKoYiB3lvcgQTPBHPXav13bJ0wxjYqoO2JuhxOZ9P/2UutZjLyB6RW
	 w4MCiOyqPNzYtAs371OVIGm/WJgc6kE6h+nGv1qU=
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
Subject: [PATCH 6.6 174/189] mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines
Date: Mon, 12 Aug 2024 18:03:50 +0200
Message-ID: <20240812160138.843629478@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
@@ -602,7 +602,7 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret;
 
-	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
 		return 0;
 
 	if (off_end <= off_align || (off_end - off_align) < size)


