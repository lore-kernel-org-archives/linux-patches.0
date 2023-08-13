Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A8F9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5001C433C7;
	Sun, 13 Aug 2023 21:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963090;
	bh=DJ99QsE4NiJUw90O8h8oIAkdEORPmMOM5bwIWT1ga9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAnfLXR3u6FJQHlkdVUSAgazbeb3s7/CJqEUtvrdHib8QBzlnPGEtFyfB/x6889Zy
	 dK28+mWJUjs8/ZMGlI2bpoczav8aGnWEDpB2DSP5+DKYs0o2pbIWIZiS1P8Lb5dnhw
	 /mBRtYenb5brJCacWYYTonVSSMk1bAFSEe2wlhX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8ada0057e69293a05fd4@syzkaller.appspotmail.com,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 5.15 49/89] xsk: fix refcount underflow in error path
Date: Sun, 13 Aug 2023 23:19:40 +0200
Message-ID: <20230813211712.260561254@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 85c2c79a07302fe68a1ad5cc449458cc559e314d upstream.

Fix a refcount underflow problem reported by syzbot that can happen
when a system is running out of memory. If xp_alloc_tx_descs() fails,
and it can only fail due to not having enough memory, then the error
path is triggered. In this error path, the refcount of the pool is
decremented as it has incremented before. However, the reference to
the pool in the socket was not nulled. This means that when the socket
is closed later, the socket teardown logic will think that there is a
pool attached to the socket and try to decrease the refcount again,
leading to a refcount underflow.

I chose this fix as it involved adding just a single line. Another
option would have been to move xp_get_pool() and the assignment of
xs->pool to after the if-statement and using xs_umem->pool instead of
xs->pool in the whole if-statement resulting in somewhat simpler code,
but this would have led to much more churn in the code base perhaps
making it harder to backport.

Fixes: ba3beec2ec1d ("xsk: Fix possible crash when multiple sockets are created")
Reported-by: syzbot+8ada0057e69293a05fd4@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20230809142843.13944-1-magnus.karlsson@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1001,6 +1001,7 @@ static int xsk_bind(struct socket *sock,
 				err = xp_alloc_tx_descs(xs->pool, xs);
 				if (err) {
 					xp_put_pool(xs->pool);
+					xs->pool = NULL;
 					sockfd_put(sock);
 					goto out_unlock;
 				}


