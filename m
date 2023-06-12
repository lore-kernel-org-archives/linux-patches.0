Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF799AD3C
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B4FC4339B;
	Mon, 12 Jun 2023 10:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566228;
	bh=3a3S7E//5RGg3AIUfWREo/KfaGDdWdkOow4ZzeCJryo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcJmtji04y7ih4dXDyZ151BbdHf8IK13t4lQ0ZJ0vrHzpMv8X29yExQJcAeGvs/+x
	 JTM27eK9jp6VPx/egNdIavb4bpOFO7SzJVIwxmWn6Osk+a3NThewiC2RPUPkEbiUW1
	 UplFyVR5LkQ4uOGjiEY6cpInyIRl4A2XPJSPnwv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang DENG <qingfang.deng@siflower.com.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/91] neighbour: fix unaligned access to pneigh_entry
Date: Mon, 12 Jun 2023 12:26:04 +0200
Message-ID: <20230612101702.727875399@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qingfang DENG <qingfang.deng@siflower.com.cn>

[ Upstream commit ed779fe4c9b5a20b4ab4fd6f3e19807445bb78c7 ]

After the blamed commit, the member key is longer 4-byte aligned. On
platforms that do not support unaligned access, e.g., MIPS32R2 with
unaligned_action set to 1, this will trigger a crash when accessing
an IPv6 pneigh_entry, as the key is cast to an in6_addr pointer.

Change the type of the key to u32 to make it aligned.

Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
Link: https://lore.kernel.org/r/20230601015432.159066-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index d5767e25509cc..abb22cfd4827f 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -174,7 +174,7 @@ struct pneigh_entry {
 	struct net_device	*dev;
 	u8			flags;
 	u8			protocol;
-	u8			key[];
+	u32			key[];
 };
 
 /*
-- 
2.39.2



