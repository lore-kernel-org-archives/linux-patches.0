Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD35F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32171C433D6;
	Wed, 30 Nov 2022 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834234;
	bh=suEp+A+LfDUvUNvfSUstNEaMJts4aZeulICiQ0+/Tgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QapKaQNvYU8q8b3WmfRU9s/FJmhKyk5q0TVYyVt1AD7oHGPYAxKGCjx8F3cpsmQU
	 gk7VuJIHIY4xe/caVYCpVM7N+Pn/C4tZVTytfKCf+kmo+RDvGRR5jDWH7Jh61Gn3fK
	 U5Z5Km6NLBbhLZ+t/lRWWnl1FTsSP3eVL0mtPkTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 6.0 179/289] zonefs: Fix active zone accounting
Date: Wed, 30 Nov 2022 19:22:44 +0100
Message-Id: <20221130180548.186944732@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit db58653ce0c7cf4d155727852607106f890005c0 upstream.

If a file zone transitions to the offline or readonly state from an
active state, we must clear the zone active flag and decrement the
active seq file counter. Do so in zonefs_account_active() using the new
zonefs inode flags ZONEFS_ZONE_OFFLINE and ZONEFS_ZONE_READONLY. These
flags are set if necessary in zonefs_check_zone_condition() based on the
result of report zones operation after an IO error.

Fixes: 87c9ce3ffec9 ("zonefs: Add active seq file accounting")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c  |   11 +++++++++++
 fs/zonefs/zonefs.h |    6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -41,6 +41,13 @@ static void zonefs_account_active(struct
 		return;
 
 	/*
+	 * For zones that transitioned to the offline or readonly condition,
+	 * we only need to clear the active state.
+	 */
+	if (zi->i_flags & (ZONEFS_ZONE_OFFLINE | ZONEFS_ZONE_READONLY))
+		goto out;
+
+	/*
 	 * If the zone is active, that is, if it is explicitly open or
 	 * partially written, check if it was already accounted as active.
 	 */
@@ -53,6 +60,7 @@ static void zonefs_account_active(struct
 		return;
 	}
 
+out:
 	/* The zone is not active. If it was, update the active count */
 	if (zi->i_flags & ZONEFS_ZONE_ACTIVE) {
 		zi->i_flags &= ~ZONEFS_ZONE_ACTIVE;
@@ -324,6 +332,7 @@ static loff_t zonefs_check_zone_conditio
 		inode->i_flags |= S_IMMUTABLE;
 		inode->i_mode &= ~0777;
 		zone->wp = zone->start;
+		zi->i_flags |= ZONEFS_ZONE_OFFLINE;
 		return 0;
 	case BLK_ZONE_COND_READONLY:
 		/*
@@ -342,8 +351,10 @@ static loff_t zonefs_check_zone_conditio
 			zone->cond = BLK_ZONE_COND_OFFLINE;
 			inode->i_mode &= ~0777;
 			zone->wp = zone->start;
+			zi->i_flags |= ZONEFS_ZONE_OFFLINE;
 			return 0;
 		}
+		zi->i_flags |= ZONEFS_ZONE_READONLY;
 		inode->i_mode &= ~0222;
 		return i_size_read(inode);
 	case BLK_ZONE_COND_FULL:
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -39,8 +39,10 @@ static inline enum zonefs_ztype zonefs_z
 	return ZONEFS_ZTYPE_SEQ;
 }
 
-#define ZONEFS_ZONE_OPEN	(1 << 0)
-#define ZONEFS_ZONE_ACTIVE	(1 << 1)
+#define ZONEFS_ZONE_OPEN	(1U << 0)
+#define ZONEFS_ZONE_ACTIVE	(1U << 1)
+#define ZONEFS_ZONE_OFFLINE	(1U << 2)
+#define ZONEFS_ZONE_READONLY	(1U << 3)
 
 /*
  * In-memory inode data.


