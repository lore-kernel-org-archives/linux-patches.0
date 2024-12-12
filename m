Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ECC213E99;
	Thu, 12 Dec 2024 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019990; cv=none; b=jIfRBcY+yyfnQBYrxc2HpeMWNCmf2NFuJgVmRtd3ebLqZqJiyKgc0H40coFayuAIOcffvqEjQTtgB8CvElE53jpMrbZm1YOj+ouK2wcHGQ1jBI5eCS/Zoqk2tEMBDwHLXgCI4HWzpQ/e7aMYhvbL5ch0/DXYtD110Knqy0JUTsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019990; c=relaxed/simple;
	bh=3MkJSMqCAPnGAszj4CIe+i7dIOhKLgx7seVjvcu7tU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axL6uFqmFcK4jwzbhn4KxX/urdH6oBatHjNVW46dZrBBglEPFUaVBBIETp1nQdIIBEMCBKxv0b0ijCXNFegnrZNAbhC/Dmih40+Bq25MhAuXRgCD7dA/hsuUfv489ugMpQgu8VsIjP31AvYtaIlzVYFfDRjFlFsDsEigNJyKp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/OW4u0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/OW4u0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80784C4CECE;
	Thu, 12 Dec 2024 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019990;
	bh=3MkJSMqCAPnGAszj4CIe+i7dIOhKLgx7seVjvcu7tU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/OW4u0sSmCLw+ac5uijbFbuTWlCiJsNUXMMcDgD/guLIIBlIj0uSuUNj9fYseM7n
	 d+DkIANSY+JWjx2rEYbbctWoTl2u+uw96nAMn1OwVckK8ZzFbpx/1E75bBebZkvvuS
	 yvsLhm10F44h3SPKW34Ap9Q1WSZBgvqtplGMDryw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 323/772] tcp: Fix use-after-free of nreq in reqsk_timer_handler().
Date: Thu, 12 Dec 2024 15:54:28 +0100
Message-ID: <20241212144403.252171928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c31e72d021db2714df03df6c42855a1db592716c ]

The cited commit replaced inet_csk_reqsk_queue_drop_and_put() with
__inet_csk_reqsk_queue_drop() and reqsk_put() in reqsk_timer_handler().

Then, oreq should be passed to reqsk_put() instead of req; otherwise
use-after-free of nreq could happen when reqsk is migrated but the
retry attempt failed (e.g. due to timeout).

Let's pass oreq to reqsk_put().

Fixes: e8c526f2bdf1 ("tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().")
Reported-by: Liu Jian <liujian56@huawei.com>
Closes: https://lore.kernel.org/netdev/1284490f-9525-42ee-b7b8-ccadf6606f6d@huawei.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20241123174236.62438-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 569186f741fb2..8fa56a17f03a6 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1121,7 +1121,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 drop:
 	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
-	reqsk_put(req);
+	reqsk_put(oreq);
 }
 
 static bool reqsk_queue_hash_req(struct request_sock *req,
-- 
2.43.0



