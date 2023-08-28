Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C8C63A2
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5C7C433C8;
	Mon, 28 Aug 2023 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219816;
	bh=IfHsrz1KpTyF1ixXdkG/eObr7j7f9YHHkZ7R2CIK/gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liQ9sX2q261hBvtnBgPadAPGcdAQedar70Hmmkzi9ZM5kzKXFuNDC08b4qWgRW7zj
	 jsXqdsr7OSyC0rIJWie0jR68uteNKBcS0vrM/EJe3CL4XssNmCkWvRvJX/LGKOuJtp
	 DhOMmjCBl4zq4GI2UXuhXaflJ32xkQaqFHFijXoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 82/84] mm: memory-failure: fix unexpected return value in soft_offline_page()
Date: Mon, 28 Aug 2023 12:14:39 +0200
Message-ID: <20230828101152.057636437@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit e2c1ab070fdc81010ec44634838d24fce9ff9e53 ]

When page_handle_poison() fails to handle the hugepage or free page in
retry path, soft_offline_page() will return 0 while -EBUSY is expected in
this case.

Consequently the user will think soft_offline_page succeeds while it in
fact failed.  So the user will not try again later in this case.

Link: https://lkml.kernel.org/r/20230627112808.1275241-1-linmiaohe@huawei.com
Fixes: b94e02822deb ("mm,hwpoison: try to narrow window race for free pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6375fe9be87b6..0c08e803ed42d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1919,10 +1919,13 @@ int soft_offline_page(unsigned long pfn, int flags)
 	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
 	} else if (ret == 0) {
-		if (!page_handle_poison(page, true, false) && try_again) {
-			try_again = false;
-			flags &= ~MF_COUNT_INCREASED;
-			goto retry;
+		if (!page_handle_poison(page, true, false)) {
+			if (try_again) {
+				try_again = false;
+				flags &= ~MF_COUNT_INCREASED;
+				goto retry;
+			}
+			ret = -EBUSY;
 		}
 	} else if (ret == -EIO) {
 		pr_info("%s: %#lx: unknown page type: %lx (%pGP)\n",
-- 
2.40.1



