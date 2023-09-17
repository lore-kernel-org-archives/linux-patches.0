Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6236FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B45C433C9;
	Sun, 17 Sep 2023 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981530;
	bh=pYUG/cUpxhip6HrE2ZQIxOF8iVMv7avuRzXti6Xd1XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjuEC8Tx0PFgH8mBRTkkRp775ukVUU1pAp3fV7YeJ0cREV7Fgc/XwNRX9qseeab1q
	 mUEgFwv84YdRAEjipc1tY/ewbrIw1INVrvqJkhiKA7rKQdZJI8VLQid1jdUqPwltkz
	 YNZVhhx1UCi1x4Ek41u8ExKCTIbTTzNTfcstai8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh Singh <kaleshsingh@google.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Yu Zhao <yuzhao@google.com>,
	Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>,
	Barry Song <baohua@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Steven Barrett <steven@liquorix.net>,
	Suleiman Souhlal <suleiman@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.1 136/219] Multi-gen LRU: avoid race in inc_min_seq()
Date: Sun, 17 Sep 2023 21:14:23 +0200
Message-ID: <20230917191045.908251759@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh Singh <kaleshsingh@google.com>

commit bb5e7f234eacf34b65be67ebb3613e3b8cf11b87 upstream.

inc_max_seq() will try to inc_min_seq() if nr_gens == MAX_NR_GENS. This
is because the generations are reused (the last oldest now empty
generation will become the next youngest generation).

inc_min_seq() is retried until successful, dropping the lru_lock
and yielding the CPU on each failure, and retaking the lock before
trying again:

        while (!inc_min_seq(lruvec, type, can_swap)) {
                spin_unlock_irq(&lruvec->lru_lock);
                cond_resched();
                spin_lock_irq(&lruvec->lru_lock);
        }

However, the initial condition that required incrementing the min_seq
(nr_gens == MAX_NR_GENS) is not retested. This can change by another
call to inc_max_seq() from run_aging() with force_scan=true from the
debugfs interface.

Since the eviction stalls when the nr_gens == MIN_NR_GENS, avoid
unnecessarily incrementing the min_seq by rechecking the number of
generations before each attempt.

This issue was uncovered in previous discussion on the list by Yu Zhao
and Aneesh Kumar [1].

[1] https://lore.kernel.org/linux-mm/CAOUHufbO7CaVm=xjEb1avDhHVvnC8pJmGyKcFf2iY_dpf+zR3w@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230802025606.346758-2-kaleshsingh@google.com
Fixes: d6c3af7d8a2b ("mm: multi-gen LRU: debugfs interface")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com> [mediatek]
Tested-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4331,6 +4331,7 @@ static void inc_max_seq(struct lruvec *l
 	int type, zone;
 	struct lru_gen_struct *lrugen = &lruvec->lrugen;
 
+restart:
 	spin_lock_irq(&lruvec->lru_lock);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
@@ -4341,11 +4342,12 @@ static void inc_max_seq(struct lruvec *l
 
 		VM_WARN_ON_ONCE(!force_scan && (type == LRU_GEN_FILE || can_swap));
 
-		while (!inc_min_seq(lruvec, type, can_swap)) {
-			spin_unlock_irq(&lruvec->lru_lock);
-			cond_resched();
-			spin_lock_irq(&lruvec->lru_lock);
-		}
+		if (inc_min_seq(lruvec, type, can_swap))
+			continue;
+
+		spin_unlock_irq(&lruvec->lru_lock);
+		cond_resched();
+		goto restart;
 	}
 
 	/*


