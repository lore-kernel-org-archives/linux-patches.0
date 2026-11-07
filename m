Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063444;
	b=KzmOqMbtWN7v7AKETeoNk88a54aAftNWgU0ksOgaIn4BMAV5PLG+VhsU5AtoVmtw+ota
	 n4DwismjqMkqgNT2UudDXB4qlPjeSSnxu1LT9oKL+Iu7A+b6PJZW3WRukTrFRboQvji4j
	 VqKlqwRbGDGe0kiZeSMqSVrZdvm1n+EsEbEh3qdjcurpl0Sqyh/qKqSMn1OgrzY5YoE+C
	 cqVG15I3qLP0y7keU7sjz3ml3VOtFmzZzXNkDiL7zdHLRwdeUTKatcI4eOgG1jfVixTui
	 +385+5RB61ge91SUJQvPMid0jylpgaWJFvJqPxBP4UVcyDFwyh2qBLn+bSmw5eoOI4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8ufY2dbpDFX38r/1rrTlj88NNWIeuAwdUKRa1Ck6UA=;
	b=zed5rz+eJz26Bt9UQZpltLGKUtOs3hf+zV5BkZW7xyxRjOLA7rNLhVWYO9DQYhLYh6Ql
	 4wXqs7qYXxGyqZ/MfRGQUp4mHXyaPfbqg13O59soksIKRvsW2SJWK3WB3IOcaOpGG/VNL
	 /KgjbvFqYwVCRgZ8jGwnyzl5VwUkV5nzxqRkFgEXfI2ve0xxoOSrGIlxhKFz4LRGFCRuy
	 i68pyi2wlCExLZ+1kbexRlaWeNtIec+KYk/DTQMt2VFXkfvMv4YBYF7IbOFPjv0+Vh16N
	 XzMB0q/mfEcREW3sjS2LJnqhQP6lsLA2BLRPCAvf6mGOSbJXbAx0/7BSdDi+4uszP/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Or8IGKAt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5155560A2616;
	Sat,  7 Nov 2026 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Or8IGKAt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C21F008A1;
	Sat,  7 Nov 2026 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063443;
	bh=G8ufY2dbpDFX38r/1rrTlj88NNWIeuAwdUKRa1Ck6UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Or8IGKAtegsmS3zZsa/mNB+ssL2sgF5cUkgjz91760+OQMkovsq0htIplpTyTFpyS
	 MnDk/UwZRG88nO6hn+fE3PHQK9ELh6PkRu44PMF64BYnNQgXC6Rn4TGZmFglCGIB3X
	 Us79v1H9tIzhV+Z5wSXzuKdLAkElrjCxWRr7ut1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 599/869] dax: fix dax_range_compare_iter() to use correct size and address offset
Date: Sat,  7 Nov 2026 08:54:41 -0500
Message-ID: <20261107134913.378684161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit a4bfbfb4e98a62b589ac7ca9e73e9612bfe8cab7 ]

dax_range_compare_iter() has two bugs in how it calls
dax_iomap_direct_access() and uses the returned addresses:

1. The size argument passed to dax_iomap_direct_access() is
   ALIGN(pos + len, PAGE_SIZE), which is an absolute file offset
   rather than a length. This causes the underlying dax_direct_access()
   to request a massively inflated nr_pages via PHYS_PFN(size).

2. The addresses returned by dax_iomap_direct_access() are page-aligned
   starting addresses, but memcmp() compares from saddr/daddr directly
   without adding the page-in-page offset of pos1/pos2. When pos1/pos2
   are not page-aligned, this compares the wrong data.

Fix the size by computing ALIGN(len + offset_in_page(pos), PAGE_SIZE),
matching the pattern used in dax_iomap_copy_around(). Fix the address
by adding offset_in_page(pos1)/offset_in_page(pos2) to saddr/daddr in
the memcmp() call.

Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261011064840.1296-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 69ac2562cec31..155f8024b30df 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2168,6 +2168,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	u64 dest_len;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -2183,17 +2184,18 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	}
 
 	id = dax_read_lock();
-	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
-				      &saddr, NULL);
+	size1 = ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
+	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
-				      &daddr, NULL);
+	size2 = ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
+	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	*same = !memcmp(saddr, daddr, len);
+	*same = !memcmp(saddr + offset_in_page(pos1),
+			daddr + offset_in_page(pos2), len);
 	if (!*same)
 		len = 0;
 	dax_read_unlock(id);
-- 
2.53.0



