Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3F126F2B3;
	Mon, 13 Oct 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369924; cv=none; b=fvdj3Net9N+3v+dHClPyUU/ghWKWJaV6TDQ9qCQfSSnpqlq8/QIlBQ3/MFwoZL//1uw8XylMvLaiJ14o2xYR1vaz2ag98kSc0DNWVNr5xRlegM2dVGK+9yup9WJaFeOuLS1hGL39y14GYqLyA+4WvHQAheilvzGc7Kv+hEKV8ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369924; c=relaxed/simple;
	bh=kQoj9RJ9l8PaL+Uf2MYzKyRBtIDZcHlmrZpxwNFILwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhYBqGCZf9eQTuwyl/eOqIizXWPbEoQVwxvb3X5ktB1XYG5AZ+Z9WtBZbN+L7HXSA5+xQbHV6dBFlC3yNxIiZIqpKHDo2DH1I+Sr07UWMjyP4ZDfQtuAyNYwcldtk8y5nC2NgzxzJrEtlN3t9YUqMJbtnw8FtYx4+HFhpkSSIIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJtrVmuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJtrVmuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E608C4CEE7;
	Mon, 13 Oct 2025 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369924;
	bh=kQoj9RJ9l8PaL+Uf2MYzKyRBtIDZcHlmrZpxwNFILwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJtrVmufFGOIZEKMrgTgIlzzwR2kzNO5IxUObkGCEbSAafFS3W18vqUp6ze2hk+w4
	 4Nqf5QRVAPnhCYwN0lmmyH790U2sr+Af1xPZDZcTiLPDKc57hizNedxXpr6AOj5uNW
	 H6j4gbG+LWjYLvujK5MldTgoUzTGDzbUyc5QJjVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 383/563] mptcp: Call dst_release() in mptcp_active_enable().
Date: Mon, 13 Oct 2025 16:44:04 +0200
Message-ID: <20251013144425.147558926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 108a86c71c93ff28087994e6107bc99ebe336629 ]

mptcp_active_enable() calls sk_dst_get(), which returns dst with its
refcount bumped, but forgot dst_release().

Let's add missing dst_release().

Cc: stable@vger.kernel.org
Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 893c49a78d9f ("mptcp: Use __sk_dst_get() and dst_dev_rcu() in mptcp_active_enable().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/ctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index fed40dae5583a..c0e516872b4b5 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -505,6 +505,8 @@ void mptcp_active_enable(struct sock *sk)
 
 		if (dst && dst->dev && (dst->dev->flags & IFF_LOOPBACK))
 			atomic_set(&pernet->active_disable_times, 0);
+
+		dst_release(dst);
 	}
 }
 
-- 
2.51.0



