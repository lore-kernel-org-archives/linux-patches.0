Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7E063A2
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54ECC433C7;
	Mon, 28 Aug 2023 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219813;
	bh=Qd4L/KRqv488xpLafUYEnJpMt2ewrSdShzhOCsSaImU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm0LzXjnfCHCIXvW5WKs8TAMuuyPdp20IqvDmf3vr1trNLQxPE3VevOZsQvvBenH4
	 fXHB06PpqLhiC61dAD0DFgcSSDxlR+ncixggJW791VoFRY3YG88CETjxqhTY1sVsg9
	 +NmAn4B4QIkRPwUXD0bIViFKpnvv0Ss46dLBS7M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 81/84] mm: memory-failure: kill soft_offline_free_page()
Date: Mon, 28 Aug 2023 12:14:38 +0200
Message-ID: <20230828101152.028259447@linuxfoundation.org>
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 7adb45887c8af88985c335b53d253654e9d2dd16 ]

Open-code the page_handle_poison() into soft_offline_page() and kill
unneeded soft_offline_free_page().

Link: https://lkml.kernel.org/r/20220819033402.156519-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: e2c1ab070fdc ("mm: memory-failure: fix unexpected return value in soft_offline_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e3c0fa2464ff8..6375fe9be87b6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1857,16 +1857,6 @@ static int soft_offline_in_use_page(struct page *page)
 	return __soft_offline_page(page);
 }
 
-static int soft_offline_free_page(struct page *page)
-{
-	int rc = 0;
-
-	if (!page_handle_poison(page, true, false))
-		rc = -EBUSY;
-
-	return rc;
-}
-
 static void put_ref_page(struct page *page)
 {
 	if (page)
@@ -1929,7 +1919,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
 	} else if (ret == 0) {
-		if (soft_offline_free_page(page) && try_again) {
+		if (!page_handle_poison(page, true, false) && try_again) {
 			try_again = false;
 			flags &= ~MF_COUNT_INCREASED;
 			goto retry;
-- 
2.40.1



