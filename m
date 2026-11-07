Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062458;
	b=v3aYW06ii3Y1ukhDesRNhJSzzdb2pbZN1bJV3MDLEsheMLDcq1MRaPo30BQOs7bslqO7
	 OSmJqSspePKjyeRlA42tRF/zJX3HKOLuQDXQqw/7NKRocc1gtzmUUmybvcv/SXzShaCMg
	 m6mS1BBoXYotuuRR7kNGZmvZXrO2iBFetQHvXbDCrCvnHVNc0thWPFlp8RH2OZD2ogF7m
	 6FwtANQztV1V37tuxjp7pQZC7Ozd9IFVbPamN6/JP21qC5RGZ80lOR+3/jSN7TFXn2JmS
	 Vh9U1/KTtdmd2CCk2NAYvLV0eM8AwPMs10aVxK7AmHN+7qh/NY0n1CImpstTfClMxkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GxTvTrFLBn3P6RGTnxcCVmE7CqyBIdUKcm2F5ncjrII=;
	b=MnHi0bZu7nh1vBG6n+rHOuY/oaIv46T6odw98ziGwqQMuOTnmWNcGSg/AQR9tlaHjHty
	 McdAK08k7XBU4tRF9P4FDCC154LhtSJWplImgVrbu1pMYiL+vV0xmb8abffZA8xUYEt3/
	 LCByuCsPI6ZBaloEXWkPjUCZRVOmR4KSrDiQvQDqwkYA7DOM/SKzQRwAgdyayZ4wF+OFy
	 zYWh0UpXc6g0ZZMujfgliHY3KCUYsUYhcpAdyKjQ4lxnrbaDHpFzfL52oL3dMmRprCFyi
	 /rzWyMERc5x/1woe5u1nynhj8KO7sx05OznOpLOXrbmLrdA9UCOeDdLmHW8TkxQYs4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pzct+Bla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B810B606A642;
	Sat,  7 Nov 2026 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pzct+Bla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652C81F008A2;
	Sat,  7 Nov 2026 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062457;
	bh=GxTvTrFLBn3P6RGTnxcCVmE7CqyBIdUKcm2F5ncjrII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pzct+BlaNwjVFlYB+thLJR7r4s5+is9Vw1V+ODyRAjJFhJJR1YJrgoYLMgU3Z6ZuZ
	 J8RfVcMFQcCtbA4Grbwpij/04fxs25Nlpd2WNiIzQFljvdahSgCRjKNdIHthN+TMsb
	 mwXYZ5Gs7nxJeFgyfznwbkxSQHNsQYZhexeT174o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1326/1536] dax: fix dax_range_compare_iter() to use correct size and address offset
Date: Sat,  7 Nov 2026 08:55:42 -0500
Message-ID: <20261107135035.058760173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 756400f2a6257..ae1e9497b4168 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2006,6 +2006,7 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -2021,17 +2022,18 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
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



