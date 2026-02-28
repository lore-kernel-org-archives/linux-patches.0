Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AC8332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301245; cv=none; b=BZNplMIwT69ANy3aOiZ1GPBx0wUMQDnwNShhXIOxmyYgvjY7WelwkgAhbax4CeDu+ydc7fpP4kqPdkIa2I1voVkzh60NE5rugBjVE3o5rc5Qe4BmwsTK7VlF6dF6dTMLD3rDeA9zlRqOZONdlq3EjWtg7U2w44mIsI6N6dsB+aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301245; c=relaxed/simple;
	bh=aM7GcsWZOka3mZdbPvxUduPH0aSaXivgWTN99CfH0do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuFtVzHSujxX6b2G7ze4dcnPwIVNtyH7DqQuyHAkLoEq3pY9YD9mByoz/nuwFDBByowGTF2zI3kOo36FHAOGJWBZahE25qj0zkQK+3qQYTKTas3f1wk45Y91BcvGvX6wvS+4scQf2ztFmRl7gMjsLx00+ZaWveBLY2PtpOQVa6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdhqrVso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdhqrVso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A3BC19424;
	Sat, 28 Feb 2026 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301245;
	bh=aM7GcsWZOka3mZdbPvxUduPH0aSaXivgWTN99CfH0do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdhqrVsoe5DNR8UKS7xA9pj5rQfJBPnFYJYeDj5mOshhOg9TJaup2iQdruZTHWTmQ
	 NZi9sG2bWAuLKyYEfl53TvMMVP0+42H1XqDO7PsizGbbu3kQG5Ug+UWbHhJ0KW3PEF
	 9FHtewwOSU5ELvPgKzCquXbqYBcW5uPom4eWTFI2nlX1MmnEJn62LH8xGd6f0HTb6C
	 TinbSdlpy7QWBwMysu5NaNzKEQgPMY4SQJXyBnkJSVVmtFnu32IEc3Wts6gNBcTLxW
	 uXe1wpS3hiLKwjfGaajP2QcNBzlfn/5QupeyzwtB96bcQST6rjifXWpbCa1bT19z/t
	 J8i9UBb/upIEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 426/752] tls: Fix race condition in tls_sw_cancel_work_tx()
Date: Sat, 28 Feb 2026 12:42:17 -0500
Message-ID: <20260228174750.1542406-426-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 7bb09315f93dce6acc54bf59e5a95ba7365c2be4 ]

This issue was discovered during a code audit.

After cancel_delayed_work_sync() is called from tls_sk_proto_close(),
tx_work_handler() can still be scheduled from paths such as the
Delayed ACK handler or ksoftirqd.
As a result, the tx_work_handler() worker may dereference a freed
TLS object.

The following is a simple race scenario:

          cpu0                         cpu1

tls_sk_proto_close()
  tls_sw_cancel_work_tx()
                                 tls_write_space()
                                   tls_sw_write_space()
                                     if (!test_and_set_bit(BIT_TX_SCHEDULED, &tx_ctx->tx_bitmask))
    set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask);
    cancel_delayed_work_sync(&ctx->tx_work.work);
                                     schedule_delayed_work(&tx_ctx->tx_work.work, 0);

To prevent this race condition, cancel_delayed_work_sync() is
replaced with disable_delayed_work_sync().

Fixes: f87e62d45e51 ("net/tls: remove close callback sock unlock/lock around TX work flush")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/aZgsFO6nfylfvLE7@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d171353699800..c6a708ee21dc8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2533,7 +2533,7 @@ void tls_sw_cancel_work_tx(struct tls_context *tls_ctx)
 
 	set_bit(BIT_TX_CLOSING, &ctx->tx_bitmask);
 	set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask);
-	cancel_delayed_work_sync(&ctx->tx_work.work);
+	disable_delayed_work_sync(&ctx->tx_work.work);
 }
 
 void tls_sw_release_resources_tx(struct sock *sk)
-- 
2.51.0

