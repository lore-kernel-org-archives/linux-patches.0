Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F91FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71E5C433EF;
	Fri,  3 Feb 2023 10:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419685;
	bh=SAp6l6Th0cytDJz0r1Xs2HJYWDJXY2RDqGYmyH0tKHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhzD3ycCvpn/CS5a7ZtRKwrhsYtuiQC7sG3/+x5cbyhtbSb4uRd6e/Ks6tVE1UDgM
	 vn5WP7EHvHYQGc3QDqF5CXke73oIjaNa192brmHRGKA/VwI3GInoy2tKrGUuHDpiaZ
	 vEVlRinkcd3VTlf32QODbhibbQD727R8A2+t4UL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giulio Benetti <giulio.benetti@benettiengineering.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 43/80] ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment
Date: Fri,  3 Feb 2023 11:12:37 +0100
Message-Id: <20230203101017.046884062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Giulio Benetti <giulio.benetti@benettiengineering.com>

commit a4e03921c1bb118e6718e0a3b0322a2c13ed172b upstream.

zero_page is a void* pointer but memblock_alloc() returns phys_addr_t type
so this generates a warning while using clang and with -Wint-error enabled
that becomes and error. So let's cast the return of memblock_alloc() to
(void *).

Cc: <stable@vger.kernel.org> # 4.14.x +
Fixes: 340a982825f7 ("ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation")
Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -160,7 +160,7 @@ void __init paging_init(const struct mac
 	mpu_setup();
 
 	/* allocate the zero page. */
-	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	zero_page = (void *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!zero_page)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);


