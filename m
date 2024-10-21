Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C72C1EBA16;
	Mon, 21 Oct 2024 10:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506831; cv=none; b=SjTiUw7NIIRuzS2WgdWDbs7C2lkvSG1L6nOY9TktL5nYuMuXMXgFwV/4mF/s8LUxk6+ps7OAW493HPJ3dTGOIuHnyeWoiN8AFfjXod3czU/klTiaivu1oI/hAaqZpgvJT295zJ0zmQ/S7ot45IOIrBUezA7e3vylGBOk3Gp5pZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506831; c=relaxed/simple;
	bh=+Km6Vz2OOZ9ZXpn2bGp+6xFjnuIqsiJys/xqkar7feU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx4Fh+bR1J/jKF9QaXvxFEE7GmPddeHq/JHhQotaP6kJIA/DsvDlI4NKmvTZwOEBFIT5GoiKVn/tBPmKOE+7dG2+Odb02KiMy/tVSxGfsQW2nIetxSm25wtJSmM9EoB3IhpY1rz8U2U0gWgJB5tzcTmF3XR4+Yg2JO9dgPMq6i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT4tcnYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT4tcnYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5596AC4CEC3;
	Mon, 21 Oct 2024 10:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506830;
	bh=+Km6Vz2OOZ9ZXpn2bGp+6xFjnuIqsiJys/xqkar7feU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT4tcnYfPrql5Egkyqi77fcRxjx/rXxHybvl7u3TVFuqF3Slc1jCOofyzm5BWoRh7
	 smAe+gf5rXSDKNwXaupeHGmobcgBX6ybwpHeY5MGohpfDdKG8GZtIhDms7Y6D/1nKf
	 xFPXpqPpE+53CB1/yV6lJfSw895YGn+DqwKEBN30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Li <chrisl@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 134/135] mm: vmscan.c: fix OOM on swap stress test
Date: Mon, 21 Oct 2024 12:24:50 +0200
Message-ID: <20241021102304.593567247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Li <chrisl@kernel.org>

commit 0885ef4705607936fc36a38fd74356e1c465b023 upstream.

I found a regression on mm-unstable during my swap stress test, using
tmpfs to compile linux.  The test OOM very soon after the make spawns many
cc processes.

It bisects down to this change: 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9
(mm/gup: clear the LRU flag of a page before adding to LRU batch)

Yu Zhao propose the fix: "I think this is one of the potential side
effects -- Huge mentioned earlier about isolate_lru_folios():"

I test that with it the swap stress test no longer OOM.

Link: https://lore.kernel.org/r/CAOUHufYi9h0kz5uW3LHHS3ZrVwEq-kKp8S6N-MZUmErNAXoXmw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20240905-lru-flag-v2-1-8a2d9046c594@kernel.org
Fixes: 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding to LRU batch")
Signed-off-by: Chris Li <chrisl@kernel.org>
Suggested-by: Yu Zhao <yuzhao@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/all/CAF8kJuNP5iTj2p07QgHSGOJsiUfYpJ2f4R1Q5-3BN9JiD9W_KA@mail.gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4300,7 +4300,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx) {
+	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;


