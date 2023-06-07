Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E49B24EA0
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858BCC433EF;
	Wed,  7 Jun 2023 20:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171062;
	bh=ODzEe5MTMPERDf+zXbuLdOTQOBegDNhuK6ZJ0a/0Ze4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBnWQxxAKzAnZ++nfkr80NgTUtt2sXltZgi60r/G440z14ZoLeN+4SbYPgyaDl9+v
	 9Jp0JQFPjyC1bDGyaZ8ZQIrmwiWsDClQMsAZKvBKnlHpPbBxDsRhMWiO8sd2BhLws0
	 qcAx9Y+IAV6FNcrvZTO4mnsUQUkeeSLYHFbTWakE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	kernel test robot <lkp@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/120] wifi: b43: fix incorrect __packed annotation
Date: Wed,  7 Jun 2023 22:16:23 +0200
Message-ID: <20230607200902.989733320@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 212457ccbd60dba34f965e4ffbe62f0e4f970538 ]

clang warns about an unpacked structure inside of a packed one:

drivers/net/wireless/broadcom/b43/b43.h:654:4: error: field data within 'struct b43_iv' is less aligned than 'union (unnamed union at /home/arnd/arm-soc/drivers/net/wireless/broadcom/b43/b43.h:651:2)' and is usually due to 'struct b43_iv' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

The problem here is that the anonymous union has the default alignment
from its members, apparently because the original author mixed up the
placement of the __packed attribute by placing it next to the struct
member rather than the union definition. As the struct itself is
also marked as __packed, there is no need to mark its members, so just
move the annotation to the inner type instead.

As Michael noted, the same problem is present in b43legacy, so
change both at the same time.

Acked-by: Michael Büsch <m@bues.ch>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/oe-kbuild-all/202305160749.ay1HAoyP-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230516183442.536589-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43/b43.h             | 2 +-
 drivers/net/wireless/broadcom/b43legacy/b43legacy.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
index 9fc7c088a539e..67b4bac048e58 100644
--- a/drivers/net/wireless/broadcom/b43/b43.h
+++ b/drivers/net/wireless/broadcom/b43/b43.h
@@ -651,7 +651,7 @@ struct b43_iv {
 	union {
 		__be16 d16;
 		__be32 d32;
-	} data __packed;
+	} __packed data;
 } __packed;
 
 
diff --git a/drivers/net/wireless/broadcom/b43legacy/b43legacy.h b/drivers/net/wireless/broadcom/b43legacy/b43legacy.h
index 6b0cec467938f..f49365d14619f 100644
--- a/drivers/net/wireless/broadcom/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/broadcom/b43legacy/b43legacy.h
@@ -379,7 +379,7 @@ struct b43legacy_iv {
 	union {
 		__be16 d16;
 		__be32 d32;
-	} data __packed;
+	} __packed data;
 } __packed;
 
 #define B43legacy_PHYMODE(phytype)	(1 << (phytype))
-- 
2.39.2



