Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E6C28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE49AC433D2;
	Mon, 30 Jan 2023 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087294;
	bh=kepqTgh3OopwxzKekuIomikExiG95LZVbRkNTzseN5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXy3CKajJwiUucZcEbTbNogaDM0PYa/urYbiIU7edmqqa4EcjOR6XLSnPrQYydV0p
	 ZQGRwI073j75q3OtKnp1U4FGWztf9FURHRculoD1rh++DbWHUl8xd/Fcb7bBRBlcuz
	 mZLGm24KwYl5lfnBlyLssT9Hllsoww9o8Vbo0sCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/313] s390: expicitly align _edata and _end symbols on page boundary
Date: Mon, 30 Jan 2023 14:49:55 +0100
Message-Id: <20230130134344.119117338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 45d619bdaf799196d702a9ae464b07066d6db2f9 ]

Symbols _edata and _end in the linker script are the
only unaligned expicitly on page boundary. Although
_end is aligned implicitly by BSS_SECTION macro that
is still inconsistent and could lead to a bug if a tool
or function would assume that _edata is as aligned as
others.

For example, vmem_map_init() function does not align
symbols _etext, _einittext etc. Should these symbols
be unaligned as well, the size of ranges to update
were short on one page.

Instead of fixing every occurrence of this kind in the
code and external tools just force the alignment on
these two symbols.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 5ea3830af0cc..f81d96710595 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -79,6 +79,7 @@ SECTIONS
 		_end_amode31_refs = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);
 	_edata = .;		/* End of data section */
 
 	/* will be freed after init */
@@ -193,6 +194,7 @@ SECTIONS
 
 	BSS_SECTION(PAGE_SIZE, 4 * PAGE_SIZE, PAGE_SIZE)
 
+	. = ALIGN(PAGE_SIZE);
 	_end = . ;
 
 	/*
-- 
2.39.0



