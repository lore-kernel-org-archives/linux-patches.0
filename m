Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B08E388E4E;
	Thu,  2 Jul 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009400; cv=none; b=ocg9bbuFd+AJmYCU2NvhlXjTg7zMRlfvVquULjf0+M2G03Qk3AKYzvUUSMgMTeJnokXYfdfjDAA0th6n8viNM1rMq0gV0yoAu+WsULUOYomZ8Fuj/9Emq4yFCh9KxidsojFH6sfBIQdsYYo4Dcj6eU5YpJWqsh0Hpj6G18tFPs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009400; c=relaxed/simple;
	bh=hUJ0e52Ppsqoi0Li4LKI4372spzg0u6ayC0kVUSzICU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeQLOJHHC+R3/S4XGWpJdxDiHk9WPWPiipVS+rt2M3nbaXYZLf+Zwz8NluwSssK1IsI0zkj40CcHlARZD4u5AU54w/TBbAc2F6C+cngQloI1w5LDM98dGZhIRIAkNGwtrGuLeDDXQvrp6XGCXUwNGSWRHUZwdeNKjVlmVnY4+vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAspxcjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAspxcjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72C21F000E9;
	Thu,  2 Jul 2026 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009395;
	bh=guMcj1sP8H8OYP8xsVrHOV3GdNFn+MeASToPDL373Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAspxcjLImLl5j28xbaWboiLvYc4aEokxBkyHik5UlAoeRcgkcv7jbvA1MsvSlxiA
	 IG19p0HlImCmdFFwVRcWLYnrlPCGQWl3u7Ys4PmHED1V57YA37/6U6Re0z4mdQgBvT
	 zyNtm89jHDQMFOqtn5m27c0YFhWy/AGtaS3B9Xi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/96] batman-adv: tp_meter: keep unacked list in ascending ordered
Date: Thu,  2 Jul 2026 18:19:26 +0200
Message-ID: <20260702155109.702854704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 5aa8651527ea0b610e7a09fb3b8204c1398b9525 upstream.

When batadv_tp_handle_out_of_order inserts a new entry in the list of
unacked (out of order) packets, it searches from the entry with the newest
sequence number towards oldest sequence number. If an entry is found which
is older than the newly entry, the new entry has to be added after the
found one to keep the ascending order.

But for this operation list_add_tail() was used. But this function adds an
entry _before_ another one. As result, the list would contain a lot of
swapped sequence numbers. The consumer of this list
(batadv_tp_ack_unordered()) would then fail to correctly ack packets.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index fc2f0b49e5a06e..c837a91879ac2f 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1334,7 +1334,7 @@ static bool batadv_tp_handle_out_of_order(struct batadv_tp_vars *tp_vars,
 		 * one is attached _after_ it. In this way the list is kept in
 		 * ascending order
 		 */
-		list_add_tail(&new->list, &un->list);
+		list_add(&new->list, &un->list);
 		added = true;
 		break;
 	}
-- 
2.53.0



