Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A5A248BA1;
	Wed, 15 Jan 2025 10:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938194; cv=none; b=i3h/5bImmHn0emjzbZuBFcyzTFKwdc/ViV4g/KXpQXqGG54pkzL/nyLBE3rbZCi94254WTys2PtvzD5JUPuVJnlRuPHOaeqpge/MNZXqpM1G41rfY4I+Rlpbsm/Jk/PSDJO4zx2HzJGtUfAhz+kCOLaY/W5WTQsaJRgE0CIfjfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938194; c=relaxed/simple;
	bh=RtLa1hxC3wSeTb+g8Ab2j21mjK9F/Fs0SZmI4/0yQQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAAqdwYRxdQUxFMJjd8S5G4krmUpxejUDQqQPKrzFlyIuKLhh3eBmsi6j37ylreJuhBvBx33iBl7p9a5L6DjyBsI9T1NhzC004d9u8Rnhtp2Za1Yh2mWNBa/9cqIJsCW36BCIaCnQMAlJ/wGsmceRYY3yVXGha1YB1+CK+IqMaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXcilxE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXcilxE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32546C4CEDF;
	Wed, 15 Jan 2025 10:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938194;
	bh=RtLa1hxC3wSeTb+g8Ab2j21mjK9F/Fs0SZmI4/0yQQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXcilxE67ytWpddqh8KqRvUN1dGcIvEGFzwK5vEY7UDkVsnGmqkFigy965lCDmXVo
	 HKYD8L0e1rLkI23U1DwfTZ/1DQCm5G6fuxY23V+jWSUNuKR279r95YC1y64lpmCO6l
	 J+G9MECCreqhH2vVUALi+8KJ9QVwZFh7npd6vH48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 094/189] mptcp: sysctl: blackhole timeout: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:30 +0100
Message-ID: <20250115103610.078785719@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 92cf7a51bdae24a32c592adcdd59a773ae149289 upstream.

As mentioned in the previous commit, using the 'net' structure via
'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'pernet' structure can be obtained from the table->data using
container_of().

Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-3-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 81c30aa02196..b0dd008e2114 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -160,7 +160,9 @@ static int proc_blackhole_detect_timeout(const struct ctl_table *table,
 					 int write, void *buffer, size_t *lenp,
 					 loff_t *ppos)
 {
-	struct mptcp_pernet *pernet = mptcp_get_pernet(current->nsproxy->net_ns);
+	struct mptcp_pernet *pernet = container_of(table->data,
+						   struct mptcp_pernet,
+						   blackhole_timeout);
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-- 
2.48.0



