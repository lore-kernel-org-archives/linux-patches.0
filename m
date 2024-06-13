Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65460139CFE;
	Thu, 13 Jun 2024 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281736; cv=none; b=VbeAxdn2dkBDimcTzamwV58nxPemRnfP2Ez/7zJk9B+TVkm3BgnpzJZsizZiNgygbuuT/i0cAIk+LM2Etac3cqj5TpX8veZzK4XRvB9+zZ/yagveju2/spR3YHlQn1yUzF0ek7mmfWpEm5wmdzGiQB146oJwQHEUUQKwmozmlws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281736; c=relaxed/simple;
	bh=/GQO5m+0FT+BX/gX5R2lrU6gR6U8WztZh/vku47MOp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkwIdoiPOIfEsRQgJwYC0vQGolO/WKZrRhJb3ZS+xFQT7/9ECweAHajwMhYragCVGnnSi9Jy0Tol3AsZgqw+3z88+eCtEzwuWa6pqtN4O45/uVoG3b+8Rzsxelpw9EbjU5rfnTXoNRLsAs4Pql777CksZ1DajhAS5ja4HIoMYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/0ycz3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/0ycz3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC4FC2BBFC;
	Thu, 13 Jun 2024 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281736;
	bh=/GQO5m+0FT+BX/gX5R2lrU6gR6U8WztZh/vku47MOp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/0ycz3G+MH6Anmr+DO4sETTDk59dGcHkCJ8S63pS0f4imhT+zVJjrurYtd9oEtNL
	 GU7wv6eR8qMnWdeKDgl5tJsV97VoBNHCRJi+xsmA/U1hs4EZlq/O43ANhFNMgdkwRU
	 Q6+rxgA1qxMLRxeWJZ2L9ezxDLj0H2do26JMjjao=
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
Subject: [PATCH 5.15 038/402] mm/slub, kunit: Use inverted data to corrupt kmem cache
Date: Thu, 13 Jun 2024 13:29:55 +0200
Message-ID: <20240613113303.623363330@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8662dc6cb5092..e8b13b62029de 100644
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



