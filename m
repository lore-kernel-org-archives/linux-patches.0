Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203B86FB1;
	Tue,  5 Dec 2023 03:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoxnv5pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF92C433C8;
	Tue,  5 Dec 2023 03:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746639;
	bh=pkIddOl87x5w9buGM5J0axfucoL7rjEWa2PMtbleIK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoxnv5pMd80oKSWPY/zxqIsp/HZh/xXYItni+hYWlMKSwhxyZphGByQjkxirxv5wB
	 S3NhdABn1kBPb7u6XOAATmeCIHqRI3wVAwjOF/59Y48usEeX/nSMFMu2WVzN6Con4F
	 /q8C7584gFTbU6JfWPpWn27oEFxWbr5Q9qGGoUKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/134] efi/unaccepted: Fix off-by-one when checking for overlapping ranges
Date: Tue,  5 Dec 2023 12:16:12 +0900
Message-ID: <20231205031541.774578565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Michael Roth <michael.roth@amd.com>

[ Upstream commit 01b1e3ca0e5ce47bbae8217d47376ad01b331b07 ]

When a task needs to accept memory it will scan the accepting_list
to see if any ranges already being processed by other tasks overlap
with its range. Due to an off-by-one in the range comparisons, a task
might falsely determine that an overlapping range is being accepted,
leading to an unnecessary delay before it begins processing the range.

Fix the off-by-one in the range comparison to prevent this and slightly
improve performance.

Fixes: 50e782a86c98 ("efi/unaccepted: Fix soft lockups caused by parallel memory acceptance")
Link: https://lore.kernel.org/linux-mm/20231101004523.vseyi5bezgfaht5i@amd.com/T/#me2eceb9906fcae5fe958b3fe88e41f920f8335b6
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/unaccepted_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 135278ddaf627..79fb687bb90f9 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -100,7 +100,7 @@ void accept_memory(phys_addr_t start, phys_addr_t end)
 	 * overlap on physical address level.
 	 */
 	list_for_each_entry(entry, &accepting_list, list) {
-		if (entry->end < range.start)
+		if (entry->end <= range.start)
 			continue;
 		if (entry->start >= range.end)
 			continue;
-- 
2.42.0



