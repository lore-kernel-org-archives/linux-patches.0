Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D2230AACE;
	Wed,  3 Dec 2025 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776379; cv=none; b=T01wj3XtlFIpJGk0xEEc5Ly0JSEYpmsnV1VhcGbbqv6+Aqi69TJRFFY++wAutaieGLZ0YBpONQfyduPqzPTPmarhE2aPYdH9cX5S0L60G3b5SrMPpTbuG0vJd9MqdQ8SOCQfsPGoewZExWS2aagNoC1UqwoUivCkH+80nf0BCP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776379; c=relaxed/simple;
	bh=BVA3/RMWGfpCdM2lsiKrRrvgjD5MxyfdoXbND/zsiC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKnb8CwjA/qXzsPKqjDFcK3vKfr3SVyOON88nWyCEBSGAAQ0pP830Ui21z87iYSYIh1ZWcuVXBh95YaRtGl4dwJN2R0JAhTidttWPtX0e/nJTZ387qm32gZg2bj5bGig9ZMmFCelunlJnA0ItxHx+HFLVwovJLrS91X1WJqZSWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAaXGD8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAaXGD8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C5C4CEF5;
	Wed,  3 Dec 2025 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776379;
	bh=BVA3/RMWGfpCdM2lsiKrRrvgjD5MxyfdoXbND/zsiC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAaXGD8N/ClvSoz5mgNrMEj6Pp6l+axsQq1GWqdbJ8DSXUEbaiaaO6Nylo5uDLaFz
	 qdgK2zouNi9we4HcpHs1Dch0Q9Xy/WB0tyCTT+ZB8Jb6xNEOhbi8NtShdTW866knyV
	 bqa5WImiYzvnFXPfif1je5AVa5JA6qat8IRxSm8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/300] sctp: Prevent TOCTOU out-of-bounds write
Date: Wed,  3 Dec 2025 16:26:08 +0100
Message-ID: <20251203152406.694452587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index 5f441a48e7aa3..da00a31e167d7 100644
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



