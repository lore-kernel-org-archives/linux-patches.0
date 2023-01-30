Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936B33229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9CDC433D2;
	Mon, 30 Jan 2023 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088710;
	bh=EGO3d7qa3WnWSD0R15KD+MAJrmkHxqH8AkOLkEEfJMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYZIJUW4aK5dusEwSnKk5grQlxnPvUZyRF9gRIeZCM+waWa/laV8EI7DpwiEfmsmJ
	 iqpFO+h/93iZn8NRxH0Ti88jHqXh0OzGcZ74CdTkk4T0KHg5N9/yFSc9CvM1/4CEB+
	 jToAWPkm+++f15mxF8BZvpB1NM4e3T88BVKXKlfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giulio Benetti <giulio.benetti@benettiengineering.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 109/143] ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment
Date: Mon, 30 Jan 2023 14:52:46 +0100
Message-Id: <20230130134311.362619158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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
@@ -161,7 +161,7 @@ void __init paging_init(const struct mac
 	mpu_setup();
 
 	/* allocate the zero page. */
-	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	zero_page = (void *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!zero_page)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);


