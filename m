Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8CD403AFB;
	Tue, 21 Jul 2026 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654932; cv=none; b=rqBlMlcrgFd3KM7skXPUIoFv/AZuOoaT1Ee7r9bTaVTXdkruRWLf27LhABnhlCZYurRtxQsJY++i8Mwyq7CZvTkRPRbz7/jsDG1jK4OWFtXFdgZDu7rNqM02OmkaJ/81t4W+RPI43SNwyMNcS1nfaOord+xNrE4bhadQYW89AAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654932; c=relaxed/simple;
	bh=xGPBpCr813BUBk6HOguTxotfVepCWpKh6nCKdmpUWSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNKJBmJX0GS1v4Wdw3XKcDsOELbHWEtGlAU6zTd3zhfF91Y14ZcBMmRnYd3+YheiPXlG32Bwa0cG6HqGONc6Qa7OGkMz/MaZwIkrslJpiIKe2b8ncV6jVZ9j/sfa02dxqIVbfGA5I80PQf05RQKH9DhiZ/BZUBQus50eXpQ/BCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2AbaEu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2AbaEu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C385C1F000E9;
	Tue, 21 Jul 2026 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654931;
	bh=7fud0tYnpiX3ASQs6GPmaOqyU1QkSSM/71KkJrDcev4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2AbaEu/aqeOA8dlfY8jgc4eCuC/2/AT/9TL11Coz3PgkPqPAru+v8gKCVzQQjENK
	 D650GlXE7AATg246DkUYycbcap5iIW0ebAkXD4EwuSXBgmg/fWXoJ5TB0nojQvl6+o
	 XKjl5td39H/1Z9TRv4e0miOxcOfRNglu0LYzaAAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1848/2077] dm-log: fix a bitset_size overflow on 32bit machines
Date: Tue, 21 Jul 2026 17:25:21 +0200
Message-ID: <20260721152636.326522245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 9743132a41f4d9d0e54c5f2adcb821b04796bab1 upstream.

Commit c20e36b7631d ("dm log: fix out-of-bounds write due to
region_count overflow") made sure that region_count could fit in an
unsigned int. But the bitmap memory isn't allocated based on
region_count. It uses bitset_size (a size_t variable). The first step of
calculating bitset_size is to set it to region_count, rounded up to a
multiple of BITS_PER_LONG. If region_size is less than BITS_PER_LONG
smaller than UINT_MAX, it will get rounded up to 2^32. On a 32bit
architecture, this will make bitset_size wrap around to 0 and fail,
despite region_count being valid.

Since bitset_size gets divided by 8, it can hold any valid region_count.
It just needs a special case to handle the rollover. If it is 0, the
value rolled over, and bitset size should be set to the number of bytes
needed to hold 2^32 bits.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: c20e36b7631d ("dm log: fix out-of-bounds write due to region_count overflow")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -425,6 +425,9 @@ static int create_log_context(struct dm_
 	 */
 	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
+	/* Handle dm_round_up rollover on 32-bit systems */
+	if (!bitset_size)
+		bitset_size = 1UL << (BITS_PER_LONG - BYTE_SHIFT);
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
 


