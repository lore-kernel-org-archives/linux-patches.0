Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C521170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CE3C433C7;
	Mon, 11 Sep 2023 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441951;
	bh=piP8ZnFUex2ukLDAltozxZuwLm5C7/hiC/ulpFtJ8pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hky/EM4rqBjsEv9ieUv9o0vHhmbvjio4kmd0ma6OYXjgy+f715uRXi7rpzJmzNA+x
	 eLMGAAWfx62xh62avr5XDcDVbCOfKWWRAWRk7ut5ICL32D+K4Z/mmY23J4zGsA7tpQ
	 7UwB49Kfm/ZXL3CGOzfHlwgTt3Xo+zIYEuqRO8W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 594/739] mm/pagewalk: fix bootstopping regression from extra pte_unmap()
Date: Mon, 11 Sep 2023 15:46:33 +0200
Message-ID: <20230911134707.692764295@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

[ Upstream commit ee40d543e97d23d3392d8fb1ec9972eb4e9c7611 ]

Mikhail reports early-6.6-based Fedora Rawhide not booting: "rcu_preempt
detected expedited stalls", minutes wait, and then hung_task splat while
kworker trying to synchronize_rcu_expedited().  Nothing logged to disk.

He bisected to my 6.6 a349d72fd9ef ("mm/pgtable: add rcu_read_lock() and
rcu_read_unlock()s"): but the one to blame is my 6.5 commit to fix the
espfix "bad pmd" warnings when booting x86_64 with CONFIG_EFI_PGT_DUMP=y.

Gaah, that added an "addr >= TASK_SIZE" check to avoid pte_offset_map(),
but failed to add the equivalent check when choosing to pte_unmap().

It's not a problem on 6.5 (for different reasons, it's harmless on both
64-bit and 32-bit), but becomes a bootstopper on 6.6 with the unbalanced
rcu_read_unlock() - RCU has a WARN_ON_ONCE for that, but it would have
scrolled off Mikhail's console too quickly.

Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CABXGCsNi8Tiv5zUPNXr6UJw6qV1VdaBEfGqEAMkkXE3QPvZuAQ@mail.gmail.com/
Fixes: 8b1cb4a2e819 ("mm/pagewalk: fix EFI_PGT_DUMP of espfix area")
Fixes: a349d72fd9ef ("mm/pgtable: add rcu_read_lock() and rcu_read_unlock()s")
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/pagewalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9b2d23fbf4d35..b7d7e4fcfad7a 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -58,7 +58,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			pte = pte_offset_map(pmd, addr);
 		if (pte) {
 			err = walk_pte_range_inner(pte, addr, end, walk);
-			if (walk->mm != &init_mm)
+			if (walk->mm != &init_mm && addr < TASK_SIZE)
 				pte_unmap(pte);
 		}
 	} else {
-- 
2.40.1



