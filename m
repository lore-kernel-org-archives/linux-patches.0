Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217243;
	b=x0rndqVOAXPmi5eVvBKCsdyt4wF2jmoEsug+PW0amrBoEc+Co6HWTAhRYpmu+2OmzTK+
	 GSHKgqHbffQSch2p/7MZKFS20h/AmgH2X+A/NkIvg5NzLh3sIH8iMBZB5QYXwWq58l2/H
	 /+zSSaBiqCzEcoa78Whq22u2349uzAYvgJWD1huOD/SqoMFPqz1BUmywGlNydLIkMsIEQ
	 j02FeUsOE3FQZd/Fe65YovnRUwTRpc26YoPoH1a7y2UqIp2HPluJql9qpHnDg0GsGaTXl
	 ZmXPSaCWHvc67rOU+wvFErKtzMXkOLLoLy1nZSr4U8tbqsACd9SkMss+N4AdAVMRy/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QFBkk7ThSxn+OOQp/DQJD+rOk5JUzRh5tEXyZMwlwKQ=;
	b=2IdosWye/o4f1fTBSLh3kovjFHIx6l2IP00/oCgrWXpyIVSmx69sEMUjWdVa+ORqahuf
	 dtw+zX8zkLEZ7pXt2hT+KRavo0cAKGBGm234ucyXDnkZ1fK9kar7g93499xqEkci7JxVL
	 XfzhSE8e8JUd/ojiqvoDTnPbv4qoVdoQo2Gv9RdrBiNkSQImamkQRMhOo0kWXJiL0YGzG
	 FM8RgIfTjL1Laj/H0+1NC3SfliDfTbbc9n7wj97MrEmj0x+m0CTrK/vQCJ0uKYJvQxoY+
	 qzn2OqqTVjW+nakn1BLO8uUT41q2iRrKmaYLeVCPKgHuOBMlPdrvHXhizz7t+3hPgBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqcF4lmR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D801A606A320;
	Wed, 28 Oct 2026 19:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqcF4lmR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE471F01828;
	Wed, 28 Oct 2026 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217242;
	bh=QFBkk7ThSxn+OOQp/DQJD+rOk5JUzRh5tEXyZMwlwKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqcF4lmRdk2LrbovZKcFcn3LLqWH0xz3vhV+aqjPRJEYudfC3I/pwiFqzn0HQJK+O
	 5BZk4VLt8HR35eKa9qYIF31TWDKQyEsP2AHRB6YYEvEHCLJjfpHwSn4zypQ3amj70F
	 YZ/HPR/pKU14Bee3nb2ZBT4vkSiIcai6eBNvMCiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1791/1887] dm-integrity: fix infinite loop on discard with large tag size
Date: Wed, 28 Oct 2026 18:04:47 +0100
Message-ID: <20261028170540.205938163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

[ Upstream commit 18d80c77b4c7dd20699e81cedfbbff4e9d198f28 ]

When integrity_metadata handles a discard, it fills a buffer with
DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
time. If the kmalloc fails, the buffer is the on-stack array
checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
is never decremented and the loop never terminates.

Fix this by using sizeof(checksums_onstack) as max_size. The array has
MAX_TAG_SIZE bytes since commit b93b6643e9b5 ("dm integrity: fix a
crash with unusually large tag size"), so max_blocks is at least 1.

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ sashal: Adjusted context for the max_blocks calculation without extra_space. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 4fcd7d821568f..8a7422a54a896 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1830,7 +1830,7 @@ static void integrity_metadata(struct work_struct *w)
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned int max_blocks = max_size / ic->tag_size;
 
 			memset(checksums, DISCARD_FILLER, max_size);
-- 
2.53.0



