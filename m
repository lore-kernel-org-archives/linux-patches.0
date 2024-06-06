Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0461196D98;
	Thu,  6 Jun 2024 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683195; cv=none; b=kBq9dJ5cqbasQmSe1WSNYCoRm2Zl8O1MBKsrGawg1jpXdqRI7VN2ZzN2+qo+nfYSljif6vPxecf8ijCexHbCCLZU70q1A4M2gjNDb5hC+V7eI4drbYxcKHIqW4pLNUqCaLYcVKRFLMHKnk0pBM1D4tEiChaUZStDhcrg7Qf+NnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683195; c=relaxed/simple;
	bh=j7sucH7T0cWFkLXmBcpzi1ChCBKiNaklZYd2zaqeFJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUIx+KB7JV69nOSVUkH1uh2Sr6xs3blIsKtd3D2mOeAUtyURCrbLC4WV58UIkcCmxSB5c9Z+bCW/mgyke7tcmrDDOSYtXLZ+wkwzCvdpOLjvd4ft8Ljgc8Zxf0fCI3s9jYJf42IJg5ld3wP/6KJKP8U39K5hgtZjr1ndcGVd0oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7hSZ2i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7hSZ2i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00E3C2BD10;
	Thu,  6 Jun 2024 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683194;
	bh=j7sucH7T0cWFkLXmBcpzi1ChCBKiNaklZYd2zaqeFJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7hSZ2i0sOg6OZmW5Ingh61VUfjUcTZXNNNFzOA9RqVdsrvlP8Yp8aEkyKgUfT4B9
	 0Wz5j0lXRxjGMlppRR8OoFPII+lct2xpz5oLJj9N5fVPVxQqOPiKNjxz+5DcXI08lM
	 MBT9EHguZ5ZwNa+XvjJRDyG9+wVmLBQr9ob7S2/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Glitta <glittao@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Daniel Latypov <dlatypov@google.com>,
	Marco Elver <elver@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/473] mm/slub, kunit: Use inverted data to corrupt kmem cache
Date: Thu,  6 Jun 2024 15:59:57 +0200
Message-ID: <20240606131702.128529466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b1080c667b3b2c8c38a7fa83ca5567124887abae ]

Two failure patterns are seen randomly when running slub_kunit tests with
CONFIG_SLAB_FREELIST_RANDOM and CONFIG_SLAB_FREELIST_HARDENED enabled.

Pattern 1:
     # test_clobber_zone: pass:1 fail:0 skip:0 total:1
     ok 1 test_clobber_zone
     # test_next_pointer: EXPECTATION FAILED at lib/slub_kunit.c:72
     Expected 3 == slab_errors, but
         slab_errors == 0 (0x0)
     # test_next_pointer: EXPECTATION FAILED at lib/slub_kunit.c:84
     Expected 2 == slab_errors, but
         slab_errors == 0 (0x0)
     # test_next_pointer: pass:0 fail:1 skip:0 total:1
     not ok 2 test_next_pointer

In this case, test_next_pointer() overwrites p[s->offset], but the data
at p[s->offset] is already 0x12.

Pattern 2:
     ok 1 test_clobber_zone
     # test_next_pointer: EXPECTATION FAILED at lib/slub_kunit.c:72
     Expected 3 == slab_errors, but
         slab_errors == 2 (0x2)
     # test_next_pointer: pass:0 fail:1 skip:0 total:1
     not ok 2 test_next_pointer

In this case, p[s->offset] has a value other than 0x12, but one of the
expected failures is nevertheless missing.

Invert data instead of writing a fixed value to corrupt the cache data
structures to fix the problem.

Fixes: 1f9f78b1b376 ("mm/slub, kunit: add a KUnit test for SLUB debugging functionality")
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
CC: Daniel Latypov <dlatypov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/slub_kunit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/slub_kunit.c b/lib/slub_kunit.c
index 7a0564d7cb7ae..9384747d90e5f 100644
--- a/lib/slub_kunit.c
+++ b/lib/slub_kunit.c
@@ -39,7 +39,7 @@ static void test_next_pointer(struct kunit *test)
 
 	ptr_addr = (unsigned long *)(p + s->offset);
 	tmp = *ptr_addr;
-	p[s->offset] = 0x12;
+	p[s->offset] = ~p[s->offset];
 
 	/*
 	 * Expecting three errors.
-- 
2.43.0



