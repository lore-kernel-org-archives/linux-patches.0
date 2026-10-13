Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99014EC66A;
	Tue, 13 Oct 2026 12:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893007; cv=none; b=ZxweYmtswGcSfhvp/n5axBkGqyZdJDBw9pbKriyoltd2cix9G+ucmSCUWEpyNdCyPq8pmpPU/wWT3g356apLajYeAeU35t13pTBugdNyd8bPGpzohGSe+DtzK+ECn9BckAF7iJlhohUL/b9L5dLiNu5HUTJzrUdStyElJGFQgKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893007; c=relaxed/simple;
	bh=QQ3KFsv1Px++fT/zZGZqj0OS32LlsK/+wvbvz4G1jP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBdOfT4k7b5jOi+EaLz4tbIue+IT6KlsITAt6CLxKrIhjZFv9pTadD5ArQfWniE5iZ/opKTVnOnElH2KfUhJWQe4QUmuFS+hM60elAFqsauNLP8YQbbkifelV1QNBj5cuJfLg9vgxlFWd+/srijyU4B3hmbF0vBsJ52zy/FqwzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1k0aMUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1k0aMUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0AF1F000FF;
	Tue, 13 Oct 2026 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893005;
	bh=I/FiUrznoDZ3jayqEnhfGsIZFy76ZWuwV3ePq4RojH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1k0aMUAqUubz/3X50iYaC9Z/n3BgAJuxQrxfOcgdWmJShg27BSuPVzzAy50vc5jn
	 Yn2XJEiNHZ+X4p4YqHYPSyhTDUJb9bB7L2ID2zdtlzJSTqa9igChTveHZe1St/NfTs
	 lEN++O3CmQlU7bR2xkmAuATT6MwXDNiO+/c4ezW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 081/621] net: skbuff: dont leave stale bytes in skb_copy_and_csum_bits()
Date: Tue, 13 Oct 2026 13:31:16 +0200
Message-ID: <20261013112922.778287326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit ab9414ed70bd783e902a85c350620dee269bcb2b upstream.

When skb_copy_and_csum_bits() reaches unreadable frags it returns 0
after copying only the linear part, and the rest of the caller's buffer
is left as it was.  The callers copy into a buffer that is about to go
out on the wire: an ICMP error quoting the offending packet, or a
driver's TX bounce buffer in skb_copy_and_csum_dev().  Neither buffer
is zeroed beforehand, so whatever was in memory there gets sent.

Zero the part of the buffer we didn't fill.  The checksum usually
won't match the data any more, so the receiver will usually drop the
packet, but either way it no longer carries anything it shouldn't.
Only zero for a positive @len, a negative one from a broken caller must
not turn into a huge memset().

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20261007-b4-skb-copy-csum-stale-bytes-v1-1-adbbde033fb3@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3582,8 +3582,12 @@ __wsum skb_copy_and_csum_bits(const stru
 		pos	= copy;
 	}
 
-	if (!skb_frags_readable(skb))
+	if (!skb_frags_readable(skb)) {
+		/* Don't hand the caller a buffer with stale bytes in it. */
+		if (len > 0)
+			memset(to, 0, len);
 		return 0;
+	}
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		int end;


