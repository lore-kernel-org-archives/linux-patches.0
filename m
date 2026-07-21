Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6F9437473;
	Tue, 21 Jul 2026 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665160; cv=none; b=QGD0T9hGcShysdfUedHHLN/znJiBC++7q+1tz+3S9lnOydq/Rjt6Q+7NXVDTTQ2ecLQ/vvFSunnSEv9GX1Pva9VQ+tZ6BU3Po9+bopRw6vA5NR2i8m3D2VdqfRVai6qe9oS0/sVlI7UkxithQkF+WojngurHHhFLpK3jWQGAmKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665160; c=relaxed/simple;
	bh=V2Jp2ztm/FiYZGGbN1/gpQ3PfJUlmXtOJTk2S6wkjVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg2sGSkeRmjHUBOLgPb5/l3UqnTnCUdsTedIDBAS0db9npHSHU2qRKLvQ7dvCtolVW2pk5vMj35Sq+r7khcjtSB1K6EnceuGqS5bV2v4iEZo32ZHWqE8jFwdDDz+ruh7WEItnXFdM+4W4qhAJqTjQhG0DFzVms5twTSd39TPux8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvlMmFVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvlMmFVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A50F1F000E9;
	Tue, 21 Jul 2026 20:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665159;
	bh=OYxmGuZf7XDLZSkR9AKL42DTEX+78fWU5xqZHhx/LOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvlMmFVrJ7pzMyySslBdMi/romjLKGCor0og9XGbr66w2J+k7hvE1xg6Uaph73rnj
	 TLhjyLxOm2IeIQ8DZ7YhAba6sPJn6QLlmhUc5im4lXHORwJ4M8txGsHAtrJa51Aar7
	 lJzf5Fy0F2J/LhylWZzTORTp1icq7ktXRjM0nezs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0199/1266] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Tue, 21 Jul 2026 17:10:36 +0200
Message-ID: <20260721152446.262573721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit b86467cd2691192ad4809a5a6e922fc24b8e9839 upstream.

The server controls create-context DataOffset, so the POSIX context data
pointer may be misaligned on strict-alignment architectures. Use
get_unaligned_le32() when reading nlink, reparse_tag, and mode.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2307,9 +2307,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


