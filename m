Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4A34398EB;
	Mon, 17 Aug 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978023; cv=none; b=EjN7Unp01pl1cWs6yZO+DPjOdcOdvnHobYlZstuEFheyXjjkTHbvmx+jNprt4d7D9Ey5ToZFKqG++RRGuiuYaU20jff9YwgR44dETEUMCrX2tQrpIzM1GknsYQDtrptv1nU6k4Zq+0K/uZOWLOgODRl8dLIySZDwbOz5GVe8jWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978023; c=relaxed/simple;
	bh=8bWLUjAWsaSuKlvv9Drt4ZUKHuEE0J27Lj4IN34GJrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1LIMey/jxMl2z1y6AfEfunUbww8VExfXzVsy/gAFZfxViyV6ioXOjGZhDRZcTvcEb61o9PyjIaqoW6qFSBuNCH+jr6gB+2oEzhm48o50W0zepVIA8+kVw/+tT/TxARkhnIkw1akURaXhP+kWxaJZaFHeX9ixwmBrWCJlJEh0oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9AfVmgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9AfVmgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594F11F000E9;
	Mon, 17 Aug 2026 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978021;
	bh=GTOhgDtueiKnr5uyTGkmrN1WHlpv9xrvzfowSHBSiGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9AfVmgcdgxtgPII0Od/Vn1hNPqwtTw+bNSnc33B8MAegXYi9AyJVvwIYQmIzb4e1
	 zTxxR/Tc8vg2jsm3zl4oTZjlVHAUsgNOlRny3Pi3ToxirF5ka6hUBQKuMpjN12Zy/v
	 qZJ5Izb1Ce1ADOdWx/7HvObr/wFNt+ojvRYz5srY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Morin <guillaume@morinfr.org>,
	Chris Li <chrisl@kernel.org>,
	Zijiang Huang <kerayhuang@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/181] swapfile: call cond_resched() before locking si->lock
Date: Mon, 17 Aug 2026 15:32:47 +0200
Message-ID: <20260817132538.321723720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Morin <guillaume@morinfr.org>

The 6.12 backport of commit 66366d291f66 ("mm/swap: add cond_resched()
in swap_reclaim_full_clusters to prevent softlockup"),
added a cond_resched() after locking si->lock. Move cond_resched()
before spin_lock().

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Fixes: 60cbe67d1342 ("mm/swap: add cond_resched() in swap_reclaim_full_clusters to prevent softlockup")
Link: https://lore.kernel.org/stable/ansgKOOXi6KE3oKf@bender.morinfr.org/
Cc: stable@vger.kernel.org
Cc: Chris Li <chrisl@kernel.org>
Cc: Zijiang Huang <kerayhuang@tencent.com>
Cc: gregkh@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 552df432c37f4..ed0a5ed25e65b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -770,11 +770,11 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			}
 			offset++;
 		}
+		cond_resched();
 		spin_lock(&si->lock);
 
 		if (to_scan <= 0)
 			break;
-		cond_resched();
 	}
 }
 
-- 
2.53.0



