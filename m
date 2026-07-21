Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6AD43E4B9;
	Tue, 21 Jul 2026 22:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672424; cv=none; b=PYCNY4s+Nj3kaEcWcL3/jdGEWWn4VW/O1jy7Mjwuas2b7BTx+JbdO1yjEiFnQaenTEFFh2x/MSVoKUsMyx+gW5DigfJs5CxtuNK/LzpinRkFinU1MXYt1tVsanpM2j3/xrUJXlGmpmftqN1thmNbWwV3wcMwzY4g5I1nWEAjMVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672424; c=relaxed/simple;
	bh=Ia7w1nJwGajBWvj0dPdij83BCsGlCeaq3Djm/WxZuKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLioSsbHUngDBdhXJkyx6jWTJSh443SofzCvVpT3mUPtGGUzP/NruF4VMO7P7gmuibCTTHhFihLUrg6kOr4bztue50EEyxnQP9dX9Gps1BNQb0aGU5FxTukseY6+co9r61dYqyK7NgM+LqlzGVtiVTJiFdWuFj7Y4OdoCJJpvw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O68FAdDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O68FAdDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56A31F000E9;
	Tue, 21 Jul 2026 22:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672423;
	bh=e2hHIO8ezlxu4qzAPTUrubVPu9iXjngqZbD2h4LhVTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O68FAdDi4TnZrLIRk0G97Z01J7layrpKnfgF3Xgqiu4/CJUbiJadY8tVALL/vE4wf
	 YrHFBWr7c8JeBs6bxRxNu0WqWomWHN4oiVROpuiIGXCLOnD1Vsd43WX89qhCrlAghB
	 iy7hImTZv9bJKibWUYQ0hHVvhf4j/FsooksQPjpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 618/843] ntfs3: fix out-of-bounds read in decompress_lznt
Date: Tue, 21 Jul 2026 17:24:13 +0200
Message-ID: <20260721152419.962093762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


