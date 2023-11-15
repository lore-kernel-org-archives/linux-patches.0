Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC004446B6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5mT1WFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E07AC433C8;
	Wed, 15 Nov 2023 22:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085866;
	bh=B3pXandJXbonBrQq5S36OvJI/ACme74ApzDiFH3FMi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5mT1WFbLnW1VBigVKB1q9b+2skA8d6JI801+hFCHyE7nblTelpsSNUgKr4co1r5X
	 eGXTTErT+IP/sq/m5Pw1bPZHuLL+q3mhQ2Z1ePISK6m7n6Z6v4mrxNL0MBlefWN/zp
	 WCeWkdxbmh1HELJGJSAYMwMLQZ2Zja0ts0nZaKTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Chris Mi <chrism@mellanox.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	NeilBrown <neilb@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/119] Fix termination state for idr_for_each_entry_ul()
Date: Wed, 15 Nov 2023 17:01:35 -0500
Message-ID: <20231115220135.905296608@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit e8ae8ad479e2d037daa33756e5e72850a7bd37a9 ]

The comment for idr_for_each_entry_ul() states

  after normal termination @entry is left with the value NULL

This is not correct in the case where UINT_MAX has an entry in the idr.
In that case @entry will be non-NULL after termination.
No current code depends on the documentation being correct, but to
save future code we should fix it.

Also fix idr_for_each_entry_continue_ul().  While this is not documented
as leaving @entry as NULL, the mellanox driver appears to depend on
it doing so.  So make that explicit in the documentation as well as in
the code.

Fixes: e33d2b74d805 ("idr: fix overflow case for idr_for_each_entry_ul()")
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mi <chrism@mellanox.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/idr.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index ac6e946b6767b..bbfd934cab226 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -200,7 +200,7 @@ static inline void idr_preload_end(void)
  */
 #define idr_for_each_entry_ul(idr, entry, tmp, id)			\
 	for (tmp = 0, id = 0;						\
-	     tmp <= id && ((entry) = idr_get_next_ul(idr, &(id))) != NULL; \
+	     ((entry) = tmp <= id ? idr_get_next_ul(idr, &(id)) : NULL) != NULL; \
 	     tmp = id, ++id)
 
 /**
@@ -224,10 +224,12 @@ static inline void idr_preload_end(void)
  * @id: Entry ID.
  *
  * Continue to iterate over entries, continuing after the current position.
+ * After normal termination @entry is left with the value NULL.  This
+ * is convenient for a "not found" value.
  */
 #define idr_for_each_entry_continue_ul(idr, entry, tmp, id)		\
 	for (tmp = id;							\
-	     tmp <= id && ((entry) = idr_get_next_ul(idr, &(id))) != NULL; \
+	     ((entry) = tmp <= id ? idr_get_next_ul(idr, &(id)) : NULL) != NULL; \
 	     tmp = id, ++id)
 
 /*
-- 
2.42.0



