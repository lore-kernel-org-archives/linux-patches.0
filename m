Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A22FDC53;
	Thu, 16 Jul 2026 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211050; cv=none; b=KU+Ch/LRC8iWV+eZGPWt+QNk0I+4entLQjCcz+i3bKQKTZD+7nagyTBbfblVuLD/VckNluQK0NjtbwFGjjwOw2gMmjBSQ4Ko8QDImd/C3TNxWGBunM1lfJoUhUP+e7/hi3MN4IQ+lG5n8u4hx5Ul16MpmOB+0NmCK8f/ICDu61I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211050; c=relaxed/simple;
	bh=yAfV+XCza3Y8fD9TR3xs4CnB9d2EPcCNHU2MN4624Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+dIjw/9dgKZoMcrw/WUvKT5PdHQ+ha0GuP8jV3/Da9iPj/4BrU4A82QZSliTLA1kkGA1nkHgENkkg6rmzsYs+hitCEGYXIpZkhaP2wvNzXw91z6/De4LkypyeZLLjFBIi3Iq8qeSVAEF7FAvJ9d3Aa6HbOg2qLIWaB+QWoiBzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLjdfdbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLjdfdbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FE01F000E9;
	Thu, 16 Jul 2026 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211049;
	bh=7i2xgoCrSTpP/+ArdH3uGJBuqVz1RLIHCydBG//sRPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLjdfdbCYOtxr3C1j65RDNJs71KP7AUpFjI4UAsTClNdeXzob32ml3BbziaG73I19
	 noa/DYxk22l+TwNCNK1DikhmoAUbJtPV9MayornSHwYsnRyc9rRdrUb0BpkhmEtMq4
	 I8rhBHm5VgJ20u2+mAfklI5lTqBJrdxBoTgE+JV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 236/480] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Thu, 16 Jul 2026 15:29:43 +0200
Message-ID: <20260716133049.925464559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2297,9 +2297,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


