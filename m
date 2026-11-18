Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048168;
	b=PUMSz5Dqo7ST7Retf4hBOlmHIMUr3Fq/QlZNcCBcr2o7xIY18depkLhb1JRh3NHiNGJP
	 Du/4Ia/91uVx/EiqIAW7uil36vLwlKcphthVJbEJYToJ2M1CMracVVe1ns0D10tUS4hJv
	 /JpJ8zXwWEWMXXhJMWF8gvBE+LPj7ZeeM2NelQJRMEWvo77QpJ+jbGXW7/W/zidiabPFc
	 hjnFj54mpML/Hrq2A6hK38z/Y2yojHiy9HnoAbOjscD07TpEsoVfsWb3SymdYBmDcXj7j
	 9vP5gSCp2SF8BEt5sHKvrn8Z27Uholw3ht6bUbZzUMlqhRoHYkkj8WYbRhbXmc9QzJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rkKaanrm/8EvzjvpPd7yp1SxXjda5otYOyyfXVayujk=;
	b=Pu1hhHzAmcsqUwdr8XsiDiI5MB5Tall4kTzJoQZhEv1MxIUAdhPEunZS4V17e5hFI5jP
	 NNjwEhsAjsBoQ28xohdot8NbunsU1VUIe8M3g9GgBE9DAlZxKYUEr6MyvoxHFRb75ubCH
	 fGyC3HzKDGibeIUgOxA7hvVHz+WndMsFNVDcOgnr0kMxEwMklDQ6v5lBLLaXPYDVxB1WI
	 NJ0IxSyJ9lcDGQDhYRAaBlUZfRobbhxvEUsMh383rNYNdLz7hYiAzSB2X7OINtuSjUIJD
	 x9wfC4/81qrz7GyqSvZJTXp/S55VbU0mmC55npJnLcyDiMmuhKoL+RXSlLOxG3e9PKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnsIsCIk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF8F606A320;
	Thu, 19 Nov 2026 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnsIsCIk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E11F000C4;
	Thu, 19 Nov 2026 00:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048168;
	bh=rkKaanrm/8EvzjvpPd7yp1SxXjda5otYOyyfXVayujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnsIsCIkPwsNt03SL3ZXZwjVR/GQXg0GaJ1puIX1rQcBCNRd4HG4gtXyGkE/NXehI
	 O7TbkyllEzL7ssZ2Z10GW/TP3KfrHnnMVidZAFXYMzlpjzLCcX/AhTpE5dOP3GmKoq
	 tXIcSr0+vQZ6y1CAhWZkyqaLkMhNenxJHWtSXLwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1897/2857] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:48:51 +0100
Message-ID: <20261118150309.534084678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit a52652efd8f985397e87669f505af83f06e335cf ]

The third argument to truncate_pagecache_range() is the inclusive end
offset, but gfs2_journaled_truncate_range() passes the length of each
chunk. A hole punch at an offset larger than its length therefore
creates an inverted range.

Commit 86066914edff ("gfs2: Don't support fallocate on jdata files")
disables fallocate for jdata files.  Otherwise, the following bug
could occur:

The MM truncation path then underflows the unsigned partial-folio
length and passes an oversized range to folio_zero_range(), triggering
a BUG. Pass the last byte of the chunk so page-cache invalidation
covers the intended range.

Fixes: 4e56a6411fbc ("gfs2: Implement fallocate(FALLOC_FL_PUNCH_HOLE)")
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 8a17c3bad4ca0..2e04580b05606 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2385,7 +2385,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



