Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8E714D28C;
	Mon,  6 Jan 2025 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178004; cv=none; b=GJnQc8kXdg92wTuBlBJrjbL+eYiCTQVbmZJ8QKW7mW1R5B8N6jYtFMzAC+rfnbIt7bJbulrNH3SSiMmz1zJ96quWMQbfNTZRt277ROsmsJNH5Vp53FyPTrGuCtWwtYxrFbC3p/ShlcTbrYOrteghUECCw2KQB4kMnZS2xjsdSME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178004; c=relaxed/simple;
	bh=bIYKtXuRYyKZUCWh10qO3nap1RXSgMh2Mmzv3aBlKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAf3sofPO0ObeW6RNk9SHdPE+7EjS/LJX8OtSplRDvkpi7yrfVICBcf/x4rP37/dlKLw8eB0GUWu1/CJCjzMF61qxJkSgwJUWGnyXYF0/198eO1a1l1amReqeeAzZ9kxq0uMifALCevjdxZaPsP9UHBHQBCCB2LH0atzTprqfE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELzA4s6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELzA4s6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0302AC4CED6;
	Mon,  6 Jan 2025 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178004;
	bh=bIYKtXuRYyKZUCWh10qO3nap1RXSgMh2Mmzv3aBlKKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELzA4s6+0Qqk2uV8MOixuZ7ZZ+mN7ZnXbqAinhrpCq6acdnScizxcn1UZnm6XTl9b
	 FxXaELxY4JtmRRvFEqylSHjaUZi2QSPTptgGbFXFEdIP+kQuij67ZuAAKasIbB4bLa
	 gRxLD0Q0RQSj+PWxHaJlF8ztDUSj4ZwcpTjCNJe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 130/156] net/sctp: Prevent autoclose integer overflow in sctp_association_init()
Date: Mon,  6 Jan 2025 16:16:56 +0100
Message-ID: <20250106151146.629295394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 4e86729d1ff329815a6e8a920cb554a1d4cb5b8d upstream.

While by default max_autoclose equals to INT_MAX / HZ, one may set
net.sctp.max_autoclose to UINT_MAX. There is code in
sctp_association_init() that can consequently trigger overflow.

Cc: stable@vger.kernel.org
Fixes: 9f70f46bd4c7 ("sctp: properly latch and use autoclose value from sock to association")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241219162114.2863827-1-kniv@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -137,7 +137,8 @@ static struct sctp_association *sctp_ass
 		= 5 * asoc->rto_max;
 
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
-	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] = sp->autoclose * HZ;
+	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] =
+		(unsigned long)sp->autoclose * HZ;
 
 	/* Initializes the timers */
 	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)


