Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69AC3644B3;
	Tue, 21 Jul 2026 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663806; cv=none; b=Z/yEgYIm4AobeeUAz+0LZvjAxzOaiVW4TsVtLrLjfEH41RwheXJF6VrQIEatqPHbcl4DiyG5vdwQfSlCA1PUzvOnPNTvIjpbPIH0d+7OTiBa3p2bdtMt1ZIAmS9UAOsrfu/wr6Ox7uuUpsuNupS9yfcGFFNddbClEE9cvqaWHaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663806; c=relaxed/simple;
	bh=3vJFsilgP4Of5w0tz+xSbvRueHOyxUrSxoxwC8gBKC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0RtNee4bVMAfjc4p4x/sdapJv4cJi4VO8uJ3n+ufbCKyovdeWu67xZemNTjQuUMVbUOdJfeA5Xd0Y1Y1DJRf/HmIlegzMI06MrkYowRXtwJ47PI+doUjQgUPLJUs/yuIUwhc7bmInhTfeUT/Aatq4qgS2P9E1h8jfR9jmuWkek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrAQKVDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrAQKVDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5881D1F00A3F;
	Tue, 21 Jul 2026 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663805;
	bh=UYwRXP1GSZTrAqBVOyhRst2wOkMarBFTZYRq7fXbL6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrAQKVDnZz6EnO+rIQUgWVPn41225V/haQ+Ad4K57jMKOtZwf8r9yt8sEfWhg+kLg
	 KCRRrH84LBHUkGWf+VjYEK11MOrTSD+0doog8UyfgtV/lzVp31hyBinlmBce8b+uGa
	 hDaQlnhupfppgttFh5h3YDXhFlsPrYjAydBFMgi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 0925/1276] ntfs3: fix out-of-bounds read in decompress_lznt
Date: Tue, 21 Jul 2026 17:22:48 +0200
Message-ID: <20260721152506.732216482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 7160a57192fb16d7a6fa9b7f5c7ac341d2444a89 upstream.

decompress_lznt() does not validate array index bounds before accessing
the decompression table. A corrupted NTFS3 image with invalid compressed
data can trigger an out-of-bounds read.

Add index bounds checking to prevent the OOB access.

Reported-by: syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/lznt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/lznt.c
+++ b/fs/ntfs3/lznt.c
@@ -240,7 +240,7 @@ static inline ssize_t decompress_chunk(u
 		if (up - unc > LZNT_CHUNK_SIZE)
 			return -EINVAL;
 		/* Correct index */
-		while (unc + s_max_off[index] < up)
+		while (index < ARRAY_SIZE(s_max_off) - 1 && unc + s_max_off[index] < up)
 			index += 1;
 
 		/* Check the current flag for zero. */


