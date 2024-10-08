Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8501DE4FA;
	Tue,  8 Oct 2024 12:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391248; cv=none; b=dOPku52o+6YMi6jbu1N5LtzHambzZZOtg/auLx+3fZfVufPqM3VzANH0vLqZDQI1nvch3WtLVtSExIO0XcXLJkSVujzORB+6a/hv1r0lTabxBMWfdkvsVuH0jCFC1riluA3lq08Q5xQAGrbhuEi9JMfXI9GYjsHrm3POAaW/mVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391248; c=relaxed/simple;
	bh=0CvUfK7nc2XMXdXXjmHX3h+D2dc4HqSekf5MwdSj2bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCRp4heh/ZSlkc2HEe8/VIrch0r6l4HUKJGxjngR2ZI5J9Dj2UPVo2UkfkkUT16ja+cN7DOJkBn032j916r47NP0J6myOXl5Lsq5Z+5q1zamIkuRFesNV2oQF75CyPRyuM9kxJl4Kb1QZHuYuhND4+wR8Ibf0DhOhALBNBTQK9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uC9YeC7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uC9YeC7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C9AC4CECC;
	Tue,  8 Oct 2024 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391248;
	bh=0CvUfK7nc2XMXdXXjmHX3h+D2dc4HqSekf5MwdSj2bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uC9YeC7CFkVqaMMQbbyAg42rcHhw6uxkm4iE51SjXDkRZJPbHj1kwGGk00+V3Idc5
	 Mc+WBD7jjutAeft4iuuThYW+pngut1gp456bbbxoQHrXUU73qBCxMyXK5xEdDFFzP7
	 MEbNB9T9Jnj15fKvqP7NLQ8U0TRlcZDDmVatSjpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f4e0f821e3a3b7cee51d@syzkaller.appspotmail.com,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 054/558] sctp: set sk_state back to CLOSED if autobind fails in sctp_listen_start
Date: Tue,  8 Oct 2024 14:01:24 +0200
Message-ID: <20241008115704.345806696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8beee4d8dee76b67c75dc91fd8185d91e845c160 ]

In sctp_listen_start() invoked by sctp_inet_listen(), it should set the
sk_state back to CLOSED if sctp_autobind() fails due to whatever reason.

Otherwise, next time when calling sctp_inet_listen(), if sctp_sk(sk)->reuse
is already set via setsockopt(SCTP_REUSE_PORT), sctp_sk(sk)->bind_hash will
be dereferenced as sk_state is LISTENING, which causes a crash as bind_hash
is NULL.

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:sctp_inet_listen+0x7f0/0xa20 net/sctp/socket.c:8617
  Call Trace:
   <TASK>
   __sys_listen_socket net/socket.c:1883 [inline]
   __sys_listen+0x1b7/0x230 net/socket.c:1894
   __do_sys_listen net/socket.c:1902 [inline]

Fixes: 5e8f3f703ae4 ("sctp: simplify sctp listening code")
Reported-by: syzbot+f4e0f821e3a3b7cee51d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/a93e655b3c153dc8945d7a812e6d8ab0d52b7aa0.1727729391.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 32f76f1298da8..078bcb3858c79 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8557,8 +8557,10 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	 */
 	inet_sk_set_state(sk, SCTP_SS_LISTENING);
 	if (!ep->base.bind_addr.port) {
-		if (sctp_autobind(sk))
+		if (sctp_autobind(sk)) {
+			inet_sk_set_state(sk, SCTP_SS_CLOSED);
 			return -EAGAIN;
+		}
 	} else {
 		if (sctp_get_port(sk, inet_sk(sk)->inet_num)) {
 			inet_sk_set_state(sk, SCTP_SS_CLOSED);
-- 
2.43.0



