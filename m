Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A9C414A2C;
	Thu, 16 Jul 2026 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209582; cv=none; b=KgE0rN3L130va/EmzIV5MPeHw2nJkHucUO1BBLr/I3KDQPxZO0hUyuB4DY6QF4vhmTUrZiuH00A7q5TN9RUa3eheGez76I3nJ/bhrDjgM/q64zBIju0oEhJoMjzKZsnklLXe5r0fD4vGABIoU7WwdTWe4SVP8aBfC4ieeZrQZRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209582; c=relaxed/simple;
	bh=m62d1+2cT8qV9zsi7k3H9Rhb0jdTbWNLLSPTB/9tqrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONIzduTZo5W6JBotwQsyK1+BgxgGVFFwqxjFW5gABCE9TUKna/5gkKJH7scVw3U0tC+vXrtmbeWrS9bnyVg3px2OCLX+I7Y/508MkqL+bTHI0e6CzN/OGOwnmkD7zUhJtJQcoXNo/IR8xbBPr7J9mfMFwWT1HRvei6W15eUSWJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aC42lF7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aC42lF7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634BC1F000E9;
	Thu, 16 Jul 2026 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209578;
	bh=3WRs3yNSDwq+eWFPX3+O9xg7feZmuVJd6CQ1gatoh+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aC42lF7KPpvF4VpZC0v9tp2kHSimE1tAvD1yUn7qhkNqyTzpqFERIz7foM5BKeQbB
	 o/xNWl6yGoVoduL1gvD1vsdMKr3Dql7xZ7KTKUBjToqzJlnpC7UGDX66o4jaBtk/Yu
	 FcnGVIiLU09UXMOvHokXBIxYOBY2k8a6NDdxFW5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 239/518] smb: client: use unaligned reads in parse_posix_ctxt()
Date: Thu, 16 Jul 2026 15:28:27 +0200
Message-ID: <20260716133053.051640704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -2371,9 +2371,9 @@ parse_posix_ctxt(struct create_context *
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->nlink = get_unaligned_le32(beg);
+	posix->reparse_tag = get_unaligned_le32(beg + 4);
+	posix->mode = get_unaligned_le32(beg + 8);
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);


