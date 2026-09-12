Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B413B415B9D;
	Sat, 12 Sep 2026 09:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205417; cv=none; b=LDNgURtbAVC3K+lxltCo7vaSW3q6wX66W7hnxeunOeAnL2NInddp3GkDdu1F9t7hljlHeeEFMDY8LdLqXFc+jEjFvnpnPUIG/EuyPwUpWChILVRASMfkKxDP3/X4WkZekd8nCCqqeFoo/rzvIK3lwsVUrKOdINBXX4/QHFwNXCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205417; c=relaxed/simple;
	bh=uz8u6Lgu4YYuBdZA1IUQR5kHQ6oWb3/wgDtCVbs8y0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5GCg+/QQa1KZE6JcXUrj6M25JkdpxX+y7/zye7RwlTkgnsDkpYQvVAwGErJkFNw7lLXjGti6f0AeAx60Qlbub+PrxkoLtT73JUkq3h0OJ84KilV2u2w+pgE4ELs3NG9KyHnIL50vV+WUqyhRByvU/gipC6sK7jtvALwNEAUdj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1scr0qy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1scr0qy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CBA1F000FF;
	Sat, 12 Sep 2026 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205416;
	bh=kot9jK8IA+hBkgdV9P6rPdqh/GFYrO1lvmepj4ZtP5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1scr0qy1UVCdeG4Dl3v7LZNIAL1od/HEZe+HWRRKBKBlClSWy/ZXWEvevq4pFvgOn
	 R6JB9GuBTWh0flIUT9MxBiGNB5/RgCrxN4a78Vxf1fyR1bnQdxWJ/C3BPBVgl6f+Q4
	 4Mtm6yGJ7u73TFHm2XpnA43jFeucMSId8TIhE1Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 1812/1815] dm-integrity: fix buffer overflow with keyed discard
Date: Sat, 12 Sep 2026 08:59:22 +0200
Message-ID: <20260912065731.578584091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

commit 59e6f919d77d72ec79cbf171256f2f7819737580 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1980,7 +1980,7 @@ static void integrity_metadata(struct wo
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
-			unsigned int max_blocks = max_size / ic->tag_size;
+			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 
 			if (!ic->discard_keyed)


