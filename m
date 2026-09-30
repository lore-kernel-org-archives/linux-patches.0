Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE5C355F42;
	Wed, 30 Sep 2026 15:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783246; cv=none; b=MJLJcAnacWmmYSQEuNtQ5G9bPmJennfDAyFa2O4xGRM/J8U0ZlPv4MzKSxkRF9Bu+xmpwFe5v4NqLcYd48KqVDgfTduaM9CeoHtqQ77E/PPChwQ3yH/OOADsp0hVSJdE3NpVlcIz0MUc9jFAY/8u7PFB8ZKW0ZXZpdDXuIhR++o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783246; c=relaxed/simple;
	bh=LZo30F41h5NYy0KUhVhQ9/38NrHgxAnBs0hQuzhhWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv+LqZBlfGCwJSo/SXIS0sXXHgoCcP++8xtdxal0Is6z9q/AjREGAlWGUHCDLlcJ884lRS5l4DRAfyyu2edzVudLSJSULjgjFrY3GrBP+7AlavBNV1Kp4+LbnhQJocdq/T+Xwy0Len9C4XgbEfuwrlWMM0o4Os0vvajSPIG55PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHfv6MVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHfv6MVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461D91F000FF;
	Wed, 30 Sep 2026 15:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783242;
	bh=i76DWxkbzi/s/1STldtwXoP0XTMb32liXNMlg50XJdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHfv6MVHYUC96qaL+FCNEneBh/WmBVkwM5ENKB6IFYRG3i2nDeGjrITXK8pPCytT5
	 5nExuUw6Yhrr0fc4tZ9iA7GP8sUgWPlSbJQscU+t04u0/sgUA99wIRUtipiFGkpLbe
	 s+0Ega4rAWrJWQZow5hjVuTOB+ak0Kfw+PUbk4xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Xinyang Ge <xinyang@anthropic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 330/595] mptcp: close race between scheduler and state change
Date: Wed, 30 Sep 2026 17:23:43 +0200
Message-ID: <20260930152354.782072936@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 42064de57fb83231fcc89663a94885f228a1ee53 upstream.

The mptcp scheduler may race with subflow sockets state change: data
transmission on the selected socket may fail and a later release could
try to use mss_now reset to 0 for a divide operation.

Address the issue by explicitly checking for the critical scenario.

Fixes: c886d70286bf ("mptcp: do not queue data on closed subflows")
Cc: stable@vger.kernel.org
Reported-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reported-by: Xinyang Ge <xinyang@anthropic.com>
Closes: https://lore.kernel.org/20260525194828.1137119-1-shardul.b@mpiricsoftware.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260917-net-mptcp-misc-fixes-7-3-rc4-v2-2-0cf5c72667c8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Note: moved the mss_now check in previous places before commit
  d9ca1de8c0cd ("mptcp: move page frag allocation in mptcp_sendmsg()")
  which is not in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1381,7 +1381,7 @@ restart:
 	}
 
 	mptcp_set_timeout(sk, ssk);
-	if (copied) {
+	if (copied && mss_now) {
 		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
 			 size_goal);
 
@@ -1891,7 +1891,7 @@ static void mptcp_worker(struct work_str
 		if (!mptcp_ext_cache_refill(msk))
 			break;
 	}
-	if (copied) {
+	if (copied && mss_now) {
 		tcp_push(ssk, msg.msg_flags, mss_now, tcp_sk(ssk)->nonagle,
 			 size_goal);
 		WRITE_ONCE(msk->allow_infinite_fallback, false);


