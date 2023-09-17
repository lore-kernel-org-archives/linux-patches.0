Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F1E6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA21CC433C8;
	Sun, 17 Sep 2023 19:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980296;
	bh=MCrlwr+2dIlW2OqNs5tGStPAfB6fteqEbTHk2gBZL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwfyamcoA8DCtgvIwt6DTwzL5NbqmFmf0NI1Nn46gVJ14AN8LVK4mDW6MFP6FVw1F
	 brZt3DRoYYmlUvAmZV+nmAruVsY96UGktHlKDDjgmskzdfriV8C54u7QTaHZ9rQU9Q
	 cbY7WeXK8oRYOnvTBZBhurfJOYzXhQ0kS9l000ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 133/285] af_unix: Fix msg_controllen test in scm_pidfd_recv() for MSG_CMSG_COMPAT.
Date: Sun, 17 Sep 2023 21:12:13 +0200
Message-ID: <20230917191056.265203812@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 718e6b51298e0f254baca0d40ab52a00e004e014 ]

Heiko Carstens reported that SCM_PIDFD does not work with MSG_CMSG_COMPAT
because scm_pidfd_recv() always checks msg_controllen against sizeof(struct
cmsghdr).

We need to use sizeof(struct compat_cmsghdr) for the compat case.

Fixes: 5e2ff6704a27 ("scm: add SO_PASSPIDFD and SCM_PIDFD")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/netdev/20230901200517.8742-A-hca@linux.ibm.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/scm.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index c5bcdf65f55c9..e8c76b4be2fe7 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -9,6 +9,7 @@
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/sched/signal.h>
+#include <net/compat.h>
 
 /* Well, we should have at least one descriptor open
  * to accept passed FDs 8)
@@ -123,14 +124,17 @@ static inline bool scm_has_secdata(struct socket *sock)
 static __inline__ void scm_pidfd_recv(struct msghdr *msg, struct scm_cookie *scm)
 {
 	struct file *pidfd_file = NULL;
-	int pidfd;
+	int len, pidfd;
 
-	/*
-	 * put_cmsg() doesn't return an error if CMSG is truncated,
+	/* put_cmsg() doesn't return an error if CMSG is truncated,
 	 * that's why we need to opencode these checks here.
 	 */
-	if ((msg->msg_controllen <= sizeof(struct cmsghdr)) ||
-	    (msg->msg_controllen - sizeof(struct cmsghdr)) < sizeof(int)) {
+	if (msg->msg_flags & MSG_CMSG_COMPAT)
+		len = sizeof(struct compat_cmsghdr) + sizeof(int);
+	else
+		len = sizeof(struct cmsghdr) + sizeof(int);
+
+	if (msg->msg_controllen < len) {
 		msg->msg_flags |= MSG_CTRUNC;
 		return;
 	}
-- 
2.40.1



