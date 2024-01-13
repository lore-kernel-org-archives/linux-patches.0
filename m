Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6685B1110;
	Sat, 13 Jan 2024 09:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPibs+Rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D484BC433C7;
	Sat, 13 Jan 2024 09:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139709;
	bh=FYkWVibhDnBcaT/QmS31Cp4C/LC3w5k1EqCbzOA4oqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPibs+Rxxyyc1CYIO1mGEgK8xJrbnJHOFQjWAcMjJ2MSgJ5AgWKxxB2dZkKakfC+o
	 vjFS4xCJaqfoTPgDHvMdb9SGxEz7AG1ID2pQ/s3e5mSEDvnHdOiGgjwdqbXyJ6Nccw
	 zEV+Yhi6xj/Xa57kLWz2xqS4ApZbrQAdRSZmNnm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oskolkov <posk@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.19 22/25] net: add a route cache full diagnostic message
Date: Sat, 13 Jan 2024 10:50:03 +0100
Message-ID: <20240113094205.733342417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094205.025407355@linuxfoundation.org>
References: <20240113094205.025407355@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oskolkov <posk@google.com>

commit 22c2ad616b74f3de2256b242572ab449d031d941 upstream.

In some testing scenarios, dst/route cache can fill up so quickly
that even an explicit GC call occasionally fails to clean it up. This leads
to sporadically failing calls to dst_alloc and "network unreachable" errors
to the user, which is confusing.

This patch adds a diagnostic message to make the cause of the failure
easier to determine.

Signed-off-by: Peter Oskolkov <posk@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dst.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -98,8 +98,12 @@ void *dst_alloc(struct dst_ops *ops, str
 	struct dst_entry *dst;
 
 	if (ops->gc && dst_entries_get_fast(ops) > ops->gc_thresh) {
-		if (ops->gc(ops))
+		if (ops->gc(ops)) {
+			printk_ratelimited(KERN_NOTICE "Route cache is full: "
+					   "consider increasing sysctl "
+					   "net.ipv[4|6].route.max_size.\n");
 			return NULL;
+		}
 	}
 
 	dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);


