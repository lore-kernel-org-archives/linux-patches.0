Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17C34165B;
	Sat, 30 May 2026 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160960; cv=none; b=KdLwvtMlGfBm9v2mbyAwpjwTrcwNX3+ek/v2wtkvl4YUdVGPEeYTDoN58Oj3GcmltCEYQnyzVqVZJReqIZOEnKHyjIRdASlU/W0Ep77M8N/ebifV9sApKYW+v13EaE1JhrcwgKnImOUvOyiOyBqMPw9/SJ0F8yQPJckN0wfIgW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160960; c=relaxed/simple;
	bh=BNIuCvcJT/RlDUtRIuL2STdJQxTTZlQduHbSKxnJnwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/qNI4tNktZHZd19q2qoviXQI1J2tiygczS22lUJ2pB8UwiTS5LhxmhgOuom6915pkfM3ZeI8RKIKVFjrOqIfkscpmg0hNIzhI6BK5PiItlQmAtQx+UFdlQOgqE/7X8mCVh8M6yHv0+2irAGpLDLiJ+CPVo+qWAXcOowUaLSH08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jHQzQ3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jHQzQ3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677961F00893;
	Sat, 30 May 2026 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160959;
	bh=OO00mFtI3gJsTqMU1a3O8IFbR2axK4vAMpnh540vFis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jHQzQ3ROkz3wUkVjhtIIDpMimEfvKEa3yGzqnBjQRhVK6UAnnWjvDIR7zWnDus9v
	 xFS9XCW/dcWSljsQ54Q5FzQjlE6wBKfaeR40bYsa3A1dlfe6bgz6eLp8KZoj/lyW9u
	 XxR9AglbzpPKSef75CEHuIAybrYxg2emzIxNpgi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 485/969] Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU
Date: Sat, 30 May 2026 18:00:09 +0200
Message-ID: <20260530160313.699658579@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 15bf35a660eb82a49f8397fc3d3acada8dae13db ]

The code was printing skb->len and sdu_len in the places where it should
be sdu_len and chan->imtu respectively to match the if conditions.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: e1d9a6688986 ("Bluetooth: LE L2CAP: Disconnect if received packet's SDU exceeds IMTU")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 8a2d36f5cf33b..56fbf8d2769c6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7730,7 +7730,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 		if (sdu_len > chan->imtu) {
 			BT_ERR("Too big LE L2CAP SDU length: len %u > %u",
-			       skb->len, sdu_len);
+			       sdu_len, chan->imtu);
 			l2cap_send_disconn_req(chan, ECONNRESET);
 			err = -EMSGSIZE;
 			goto failed;
-- 
2.53.0



