Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644C6369990;
	Wed, 30 Sep 2026 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783241; cv=none; b=OnMthB1rwvZBAU7VllIdSa2ynVwhivtnDJG//DWgUf4PYPLoo8iDYHLxu3fJ5YJqKamLQX8OnQJP8PqOvtehYqmjNu7GZjUatgoFMusxBbBBAobPFoP2ZD3K9EkzVx5hm4w6W/g03mY1AfKwZqw1VRB3DlDMXo/4kLti7WuoGJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783241; c=relaxed/simple;
	bh=eZzFWj/BoHjwfZFMO0nAzNw+j3gMX7wRbxwtn6DL0Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAOiVC4f7OYn8BX42TTME2BcaYqZKm/lCJcwChyUrRTMfRgUXVDFhWxqwZOBqREsgf5AzjtUUzfmYBu9sBp3YQqYqrhafuygzE9rF+ng8Wuj7ICbhfzabRLF5BcXNlBTNN4lraJkmsIchXs0rXo829SfLNM07NGgRDFvkvWzCB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHjDdSvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHjDdSvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9CE1F000FF;
	Wed, 30 Sep 2026 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783237;
	bh=e6CwwEq+hKzM5T/ORF9njkgivWuQ7zb2pjoi+qfzcW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHjDdSvvrqECWpZgEYYavwq07QIyGbCshwvmnLDfONMZMunCYvCR1ngHe0oHfWjSH
	 nNNBGOuh+l0W0sx7/i5L5mcRcCr7SpB4P5Dql/yZ/PjPZ3sJsWQefS5pANqVGjTdlE
	 qmJpgu+JtKoNPQiRCHKXhYPWq+lMtcnlKKOZFS+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Florian Westphal <fw@strlen.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.10 328/595] mptcp: hold mptcp socket before calling tcp_done
Date: Wed, 30 Sep 2026 17:23:41 +0200
Message-ID: <20260930152354.738773112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit ab82e996a1fa1b9ae514fa357d9ce8df62321157 upstream.

When processing options from tcp reset path its possible that
tcp_done(ssk) drops the last reference on the mptcp socket which
results in use-after-free.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2b0f561f21b2 ("mptcp: avoid unneeded actions on subflow reset")
[ Conflicts in subflow.c, because commit 3ba14528684f ("mptcp: avoid
  setting TCP_CLOSE state twice") has already been backported and also
  had the same conflict: this commit here should have been backported
  first. Fixed now! ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -279,11 +279,16 @@ void mptcp_subflow_reset(struct sock *ss
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
+	/* must hold: tcp_done() could drop last reference on parent */
+	sock_hold(sk);
+
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
 	    schedule_work(&mptcp_sk(sk)->work))
-		sock_hold(sk);
+		return; /* worker will put sk for us */
+
+	sock_put(sk);
 }
 
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)


