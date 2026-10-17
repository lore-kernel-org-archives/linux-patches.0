Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9AE3B813A;
	Sat, 17 Oct 2026 16:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255702; cv=none; b=UMLX3Po6TIBAx1oqJO20IjhbemiEgH74rAt3Pt5ITUiOJjPcVWaQ1ygBxy2zqDls9krPdUHMSr2/QU3aHnLDPWUejZ88CN+/oyrnWIknLao77UCb1QeKujk6Xmnz3feMDhn1LKSroeZfkDLR5wKRpz7Vpgpmm0KkyhHkZAhdw/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255702; c=relaxed/simple;
	bh=HdRjVTQ6kdGjtwcmzMB8go6Ae/kvQLLEHLxGPTaWKVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzSpkg6lyXZRE6wtb0xYllentQKWSYKpQGfTfebdjGvzqmVcCv0qLTkLsHP4rF9Wey5AhFO/lD76nABoM0jWsZYYUtTOsp50EOnXPqsY+nW46qPlY1v/bdlvC9ZNsTNCvvXW0CyQKAWvMKXSqoeCH5YnRYI5rjLjYL7DI113jFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIF+R3dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIF+R3dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217981F000C4;
	Sat, 17 Oct 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255701;
	bh=V3mXj4ilo+pk0QBux1vNJFoAxyp1L/7l3MGM8ib4i5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIF+R3dwfqSdn/pLUPuIPbn7sEuAIrKaiJ1ZhbRA9gT1J9dWjPpImaOryEGhx4zrN
	 a1Upx+vjcj2hTVnAkWfmNP/e+IRPudUQmLGHEsFc82puq1whKlSyAIBQEukLGqIb28
	 wG3uqhSlCL3TlmuKVPp5fom+o5u+VJrPP8ESxlNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 863/869] dm-integrity: fix buffer overflow with keyed discard
Date: Sat, 17 Oct 2026 18:01:44 +0200
Message-ID: <20261017160058.983453655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

[ Upstream commit 59e6f919d77d72ec79cbf171256f2f7819737580 ]

Since commit 68c5c42567bc ("dm-integrity: replace forgeable discard
filler with a keyed sector marker"), integrity_metadata computes a
checksum for every discarded block into the "checksums" buffer.
integrity_sector_checksum always writes the whole digest. So if the tag
size is smaller than the digest size, the checksum of the last block
that fits into the buffer is written past the end of it. For example,
with hmac(sha256) and tag size 16, a 4MiB discard writes 16 bytes past
the kmalloc'ed page.

Fix this by subtracting extra_space from the buffer size when computing
max_blocks, like we do for writes.

Fixes: 68c5c42567bc ("dm-integrity: replace forgeable discard filler with a keyed sector marker")
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 513c6d5fd74e1..b1313077de7ab 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1857,7 +1857,7 @@ static void integrity_metadata(struct work_struct *w)
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
-			unsigned int max_blocks = max_size / ic->tag_size;
+			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 
 			if (!ic->discard_keyed)
-- 
2.53.0



