Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065514;
	b=hkDdHQ0oLzDIyAwzTHvVCZ0TV6L/4F191A9+XTZPy3M9joAYCYK8nq+N9SjB91M5kP3A
	 r55IlRHZbPGl5BAtaEa3BkLdEOCRcRvW1YRMFVlCimz3VKYE7Y+yZv1TQnZ1bQ7ehLKlM
	 U9KjIfUM4k/8DFDtszo7ILvAdJrafZaOdW/SFSxPZxUx0jBLDNufIIc/h7wG+94HYm40j
	 ikrolTPNrNRI7/aWTjwATUO+kX/2lCiikv3WFacX7bkhLb7HmBWfuxrY83Ez+K04imjuU
	 r7OxxK78mv7YGVpwwjkjh9GIrfXGmdsp18JIGZ12WAxC5nnxUE25iQhhiWyop4fPmPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O7ejzZuBw+Bkz6mufRGyZzhteUT4zdWDjA0RtYILO1g=;
	b=X0Gq5PCgj9hI4GoZ3qzzuDVT4k/4KE9Y1WJAvLVs5l1oXkGYi6OnzE6mV7u6qxa2NyZu
	 6C2ZQJVD9YJylq5CV65EYKG1UudvPUJlEzgJ4ysuU9QeyEW67SBnn25n+YsdexsndxcbY
	 cxWW9f6mIPACsiUCaW3p6VcoFstTPk9p+aEtmXrxfUhdWVXFkTTLX3HKChTtPJ9HCFE1L
	 CjGapfj+MKnwqp7O6HTAizN8xqrOpSvBjY/489a6xc4xzVVy1NU48zYgzGOFHY9HBisci
	 TSZh6RozLRP+g4X224QnXi6lDW5iPkXCZjtensCGIRgwggUbrqqhczJGweQ/0jr6FQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aKgarrkQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB642606A32C;
	Sat,  7 Nov 2026 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aKgarrkQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554CA1F0089F;
	Sat,  7 Nov 2026 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065513;
	bh=O7ejzZuBw+Bkz6mufRGyZzhteUT4zdWDjA0RtYILO1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKgarrkQNmYxTnIhtC/PiYnuRtb1jzjgwHhrr80t6pD3zEq1/npFoRbqhrgF69H4z
	 pNb0iuBaMYnqoiXDbSAvSgOj/C1qZYY5jKNCXaJOlW90HSFQSornuNgAaWgv9LzCRq
	 5IZcSadOU8e3FYvkwGwe21HkJbd4CyCnJRUF/TSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1196/1257] ntfs3: fix mapping pairs bounds check for alignment
Date: Sat,  7 Nov 2026 08:58:12 -0500
Message-ID: <20261107135012.196486472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f517cae6333121783043d9ba5142b50f5d1cf75b ]

In the UpdateMappingPairs action, the expansion check compares the
unaligned new attribute size with the available record space. The new
size is aligned to an 8-byte boundary before the mapping pairs are
updated, so the check can underestimate the required space by up to
seven bytes.

Use the aligned size in the expansion check to ensure that the
subsequent update cannot exceed the available record space.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index f78fb1d9ab777..2dc12e72cc9b8 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3439,7 +3439,8 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		if (!check_if_attr(rec, lrh) || !attr->non_res ||
 		    aoff < le16_to_cpu(attr->nres.run_off) || aoff > asize ||
-		    (nsize > asize && nsize - asize > record_size - used)) {
+		    (nsize > asize &&
+		     ALIGN(nsize, 8) - asize > record_size - used)) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



