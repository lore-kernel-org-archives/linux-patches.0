Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04F08F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ADCC433C8;
	Sun, 16 Jul 2023 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540377;
	bh=iST81elIs5GPAvhGF4+LF4I6fZSLGev//0T7+nEx3Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0+YFvuaJFzzDLUi0GZPDDPtpwNN/HboE+rbqWD1vad2CUS2lwKIZkzb8ioV/hNK5
	 yjOitkKjax6Yt9+/DK2i76XwoE5Nhf23IdvrFePQuG8U+jZT5UJRgzLBRvz27c16Td
	 qnSeiVdvsr5pnmWv/C53jzdqEidbkCpSRm442MLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sachin Sant <sachinp@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 315/591] powerpc/64s: Fix VAS mm use after free
Date: Sun, 16 Jul 2023 21:47:34 +0200
Message-ID: <20230716194932.041041042@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit b4bda59b47879cce38a6ec5a01cd3cac702b5331 ]

The refcount on mm is dropped before the coprocessor is detached.

Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Fixes: 7bc6f71bdff5f ("powerpc/vas: Define and use common vas_window struct")
Fixes: b22f2d88e435c ("powerpc/pseries/vas: Integrate API with open/close windows")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230607101024.14559-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/vas-window.c | 2 +-
 arch/powerpc/platforms/pseries/vas.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 0072682531d80..b664838008c12 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -1310,8 +1310,8 @@ int vas_win_close(struct vas_window *vwin)
 	/* if send window, drop reference to matching receive window */
 	if (window->tx_win) {
 		if (window->user_win) {
-			put_vas_user_win_ref(&vwin->task_ref);
 			mm_context_remove_vas_window(vwin->task_ref.mm);
+			put_vas_user_win_ref(&vwin->task_ref);
 		}
 		put_rx_win(window->rxwin);
 	}
diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 94c023bb13e05..880b962afc057 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -507,8 +507,8 @@ static int vas_deallocate_window(struct vas_window *vwin)
 	vascaps[win->win_type].nr_open_windows--;
 	mutex_unlock(&vas_pseries_mutex);
 
-	put_vas_user_win_ref(&vwin->task_ref);
 	mm_context_remove_vas_window(vwin->task_ref.mm);
+	put_vas_user_win_ref(&vwin->task_ref);
 
 	kfree(win);
 	return 0;
-- 
2.39.2



