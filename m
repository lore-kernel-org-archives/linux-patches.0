Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B2A36607D;
	Thu, 30 Jul 2026 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426802; cv=none; b=DxR/6fmUo1YKTZ2PvElkjdTzEF4WpmMhFXNObDbvAKIKOOz4xwht+4HbXfjC+EsU4KtHqgMl5NKqHTWZgpOQnef+PAuA0LMC1DSycPJPUAv6+hW8Uk00kvi1rwb7fpD8Y4p3WRUXBz5HAZpLNG9dJeZB3iHlUfSyQoO6rcbeo18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426802; c=relaxed/simple;
	bh=cQn5A1PBHXEOmiV/FTBHzF5wo+jkZrTkJstWIP5LtC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox2wvNs0/sge43rS/s8etZurL/0hUK1kaUnRlTPOKxbYuK0q0/sUjovnlDaQDF9y2CVtwoClyGGLjPtRiMjlE2TvsTU5qTqSbtdb0d4/NyzWSs7tbIj704pURwhp2R+69aDbPoHxxTmjZ3z6mmDah0661E1mawF1pWEDUm64IEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7gIMx/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7gIMx/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07E71F000E9;
	Thu, 30 Jul 2026 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426801;
	bh=2m+WPo+H4Lld647KspV5y6rcrpqH2dTYtwR/UOITD4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7gIMx/xcu8mTXzdSIvuFxqj36rx98Pc4dbZgavivmSOSUVkXf3ERSvaXllLORcGF
	 TBOb5XBMyaWGlG7hd8o2UmRFzFBlZ7ob2/ygm/YbuCOBB5sjK/UGmjF4F5jQrkXDj6
	 5qxKG8DtKr8WJo+BWHe0ySxGhK5ScWBpiXMvxyu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 546/602] dm-integrity: fix leaking uninitialized kernel memory
Date: Thu, 30 Jul 2026 16:15:38 +0200
Message-ID: <20260730141447.502879325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 7bb03b2b01b814a9fc14afbfc2cbb2cca5b34750 ]

If hash size is less than device's tuple size, dm-integrity is supposed
to zero the remaining space. There was a bug in the code that zeroing
didn't work. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2502,7 +2502,7 @@ skip_spinlock:
 			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 			const char *mem = bvec_kmap_local(&bv);
 			if (ic->tag_size < ic->tuple_size)
-				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
+				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tag_size);
 			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, dio->integrity_payload + pos);
 			kunmap_local(mem);
 			pos += ic->tuple_size;


