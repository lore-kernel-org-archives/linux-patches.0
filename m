Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E499A9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A53C433C7;
	Sun, 13 Aug 2023 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962603;
	bh=vLzRE8wPIkV0OHwXQjNwt6Lwb2s508y5j58PujaOhnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Z+d0J9CkegXm5m+ImVuZL4vNu+A6c7+6rxtpWOMKk9HpWKLfi4j6SkVdCyrWjYf3
	 z3XWW+p0OhEahumHaf1sMWqLpfzx3NCqasiTt7eM9tHa42c+RtpzLmcqO4xMXVqCCg
	 /r/iINVmwGZX47e4NgdQheuGvBIa//K6zWHvmmXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 088/149] mptcp: fix the incorrect judgment for msk->cb_flags
Date: Sun, 13 Aug 2023 23:18:53 +0200
Message-ID: <20230813211721.420335825@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiang Yang <xiangyang3@huawei.com>

commit 17ebf8a4c38b5481c29623f5e003fdf7583947f9 upstream.

Coccicheck reports the error below:
net/mptcp/protocol.c:3330:15-28: ERROR: test of a variable/field address

Since the address of msk->cb_flags is used in __test_and_clear_bit, the
address should not be NULL. The judgment for if (unlikely(msk->cb_flags))
will always be true, we should check the real value of msk->cb_flags here.

Fixes: 65a569b03ca8 ("mptcp: optimize release_cb for the common case")
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/20230803072438.1847500-1-xiangyang3@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3370,7 +3370,7 @@ static void mptcp_release_cb(struct sock
 
 	if (__test_and_clear_bit(MPTCP_CLEAN_UNA, &msk->cb_flags))
 		__mptcp_clean_una_wakeup(sk);
-	if (unlikely(&msk->cb_flags)) {
+	if (unlikely(msk->cb_flags)) {
 		/* be sure to set the current sk state before tacking actions
 		 * depending on sk_state, that is processing MPTCP_ERROR_REPORT
 		 */


