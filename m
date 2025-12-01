Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53D262FED;
	Mon,  1 Dec 2025 11:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588741; cv=none; b=WDB28UTZoXjtmFWGHoOA11VS3iqsUlE8cyCn/3f5GuqB3cQCPkrVAyl1IzO9KywRXzRLzrH4ZDuLGz6tzl0u6OcZ4ELPL5jmiE9gS4Pf5mujatNvuZ3WWIoslYNZlHoZHfeiJ+1dcciO7jqaJZCYgNU5A8LPBHFL8L0MkmsE+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588741; c=relaxed/simple;
	bh=DrGItrBCBDxps0mqxG46buUAXjUbL5HsFz3KrxNnFwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZ/PdLRkcjBa2q08/NWZAGcjY2RZWKKkRo7zE0POZv+NBB4TbuIFcLE4HOexmAdkmmJq11NFNmLVl2fZb/ZtBbAd89R+DEKh2ydtSqKD4tnJZau4k07K941bQukOVuvixXInopDrVdxkhk/X/96r6AH3/zag+xsn31y9r5v1xM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R39frHDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R39frHDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF5BC113D0;
	Mon,  1 Dec 2025 11:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588740;
	bh=DrGItrBCBDxps0mqxG46buUAXjUbL5HsFz3KrxNnFwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R39frHDYXotRi6iax9DxkVu3chasnkdZmUj0BnmHwfUdcx4m/PxntvvDeZqM5wg8J
	 xLrLSZBxlkQWVlN/aF7baJFjQj71EeshKDCnWdwPZLuvwvYGd9nd4A1EaylVfOQvhr
	 PDU1N3pT4DTk3BMdMomFvnmoJA28VZExol1aUZ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/187] sctp: Prevent TOCTOU out-of-bounds write
Date: Mon,  1 Dec 2025 12:23:49 +0100
Message-ID: <20251201112245.601074459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit 95aef86ab231f047bb8085c70666059b58f53c09 ]

For the following path not holding the sock lock,

  sctp_diag_dump() -> sctp_for_each_endpoint() -> sctp_ep_dump()

make sure not to exceed bounds in case the address list has grown
between buffer allocation (time-of-check) and write (time-of-use).

Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251028161506.3294376-3-stefan.wiehler@nokia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index fd7a55b3049db..641e52b9099dc 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -88,6 +88,9 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 		memcpy(info, &laddr->a, sizeof(laddr->a));
 		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
 		info += addrlen;
+
+		if (!--addrcnt)
+			break;
 	}
 	rcu_read_unlock();
 
-- 
2.51.0



