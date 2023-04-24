Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6E7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62204C4331F;
	Mon, 24 Apr 2023 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342832;
	bh=ZUqq+E4SAtcKWDEWmdPSUllkSE5EpyqvB1YkkU+c11s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H11hDdY3FfSUSEDgWxDXCbpgqh1tuoaPjCnfLAiiuwPVGHzswwuATOGJvgoEzbd9Q
	 9z19gLUtxJZWsALLSBah8ho2G1vyftCIDbwwy0LUPf/Um/U/IuWYGajWqzX9nCSpis
	 pchbXAPvStotyIaPbbHJkWr0g2nL3LSlzwsp5GHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	syzbot+07a218429c8d19b1fb25@syzkaller.appspotmail.com,
	Yang Shi <shy828301@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Xu Yu <xuyu@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 74/98] mm/huge_memory.c: warn with pr_warn_ratelimited instead of VM_WARN_ON_ONCE_FOLIO
Date: Mon, 24 Apr 2023 15:17:37 +0200
Message-Id: <20230424131136.725653548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 4737edbbdd4958ae29ca6a310a6a2fa4e0684b01 upstream.

split_huge_page_to_list() WARNs when called for huge zero pages, which
sounds to me too harsh because it does not imply a kernel bug, but just
notifies the event to admins.  On the other hand, this is considered as
critical by syzkaller and makes its testing less efficient, which seems to
me harmful.

So replace the VM_WARN_ON_ONCE_FOLIO with pr_warn_ratelimited.

Link: https://lkml.kernel.org/r/20230406082004.2185420-1-naoya.horiguchi@linux.dev
Fixes: 478d134e9506 ("mm/huge_memory: do not overkill when splitting huge_zero_page")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: syzbot+07a218429c8d19b1fb25@syzkaller.appspotmail.com
  Link: https://lore.kernel.org/lkml/000000000000a6f34a05e6efcd01@google.com/
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2655,9 +2655,10 @@ int split_huge_page_to_list(struct page
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
 	is_hzp = is_huge_zero_page(&folio->page);
-	VM_WARN_ON_ONCE_FOLIO(is_hzp, folio);
-	if (is_hzp)
+	if (is_hzp) {
+		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
 		return -EBUSY;
+	}
 
 	if (folio_test_writeback(folio))
 		return -EBUSY;


