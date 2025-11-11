Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E242E173B;
	Tue, 11 Nov 2025 01:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825374; cv=none; b=uv5Ea0ymWshBM/Y6LVF6lVMBkDzHQkLGJprk9/OggBxm6RAaY04Z2/fxTY3XvYeY2GSLqqcR+Mf4SE6NEzb+30tzeg/vxydqEYnHtKsA35B9/tB2BgBkaQHYfz44RisWKcV2dc5JMGkrGh0+xWJOb7d2mH1Xh3CJXFHBvXFWLWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825374; c=relaxed/simple;
	bh=xBLZCt3yBWTMP9rWiDtbLKH3JXjAfK577ucKBsv9EqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPG++yZ9b+4VeTKnNzpRWj+0fsuB7sbhjFU/1Ab/6XK8EA1f+VO08qtAFPDT/m07y7mJ+GCLFkSl8G1eAvqz4Ssh0xwnAMTidWOikdTeVs3ZBcnoxl7ot2dgC4jaJsdDhf8a/dqO34e3Febif8H+JA9bNp7x/8wSlaDIle9X68g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkZe4pE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkZe4pE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C7AC116D0;
	Tue, 11 Nov 2025 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825374;
	bh=xBLZCt3yBWTMP9rWiDtbLKH3JXjAfK577ucKBsv9EqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkZe4pE5B1udYH1IjqKhAtA8QAqpIx7xBUYMdZxugfpMtprvJpxaK9jFW5hOiUpdl
	 m6lQW//1YTXYPtaYQQAGdc7ZKt2e7QzRWdmG+5bHm6tUM/BlMRCB1IxzqhJMtfEdT6
	 Pati0GstS/zlUVjCvXaN1F1Hw/Afb3etSifCMaF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 775/849] sctp: Prevent TOCTOU out-of-bounds write
Date: Tue, 11 Nov 2025 09:45:45 +0900
Message-ID: <20251111004555.164927641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index dadf8254b30fd..95e65b9d623b3 100644
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



