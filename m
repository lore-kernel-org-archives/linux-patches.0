Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC932D7DF1;
	Tue, 21 Jul 2026 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674709; cv=none; b=qFjBc/t5GbOOLd4hKuvHIOF5+OpYvziAQXSjwNKkiMmWQz7DLzfQqEeTvbCCcHXvBbBCx/nxKcsq9Xd8XNrhOVIbef0vDq8RlLCKz2HNldP2AOnukZ3Ih/WCX2HEV3neffEkvujFVhBZezLescUp/JOLXUQ9gRkWU9ZY4WprdOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674709; c=relaxed/simple;
	bh=Kpc3BjjZz66SYEdmdGbpRRx8Xtl7GT4pUTL5kQGfwks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+UcYXGgljc7PSNRxChoaqkovcfo2pZrPwXRfv8hcBQyUWVl4cgachlKF/A9pMVTlA/2McZfyWoUq2tDV8zTbbinZan/YjuY+V+tkmq2hecb3xkmBQMo5CdpBdeheTR5ZVVJmjxlM5xmtfiiKmX6Na5GxDVyiRmB85uYGMSmGqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOVYPjO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOVYPjO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3113B1F000E9;
	Tue, 21 Jul 2026 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674708;
	bh=v2gRk3VIXaHHA2/moSYOmyB0wOVjoPqmbrtQZmwQg8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOVYPjO4tdj6NZK6dSgZjZ/R1ofHMsH85I3sXbLStMz8Kitje+2T9i0v4Puj1LoY9
	 RgOp1O0SnSJji2dwdwy0eEa3+v+yw8aiwWDKCFnzOLDCOG9usNjmZNjqh+kC4oIr/Q
	 vzrTzTbVhoE+VThn7Fu76VOtxtPAjmsZSyJjipt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 644/699] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Tue, 21 Jul 2026 17:26:43 +0200
Message-ID: <20260721152410.278623263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

[ Upstream commit b86467cd2691192ad4809a5a6e922fc24b8e9839 ]

The server controls create-context DataOffset, so the POSIX context data
pointer may be misaligned on strict-alignment architectures. Use
get_unaligned_le32() when reading nlink, reparse_tag, and mode.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1973,9 +1973,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


