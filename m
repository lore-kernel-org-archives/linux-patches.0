Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E97F1C1F0F;
	Wed, 19 Mar 2025 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394919; cv=none; b=f+lfX71ueNBUc8Fk55djt4aD5k6oU5XWoBdbvtmnaC0I9xMdYzlJXJ456r6hFK7KAPRHFBDKhY1tiYUYRNOICmGyFVLIfFLamRtYIeoT1NtpzPYOPlsdegNY3B8/hFywTS3kfN/BdEbC5s0ls7l5sYnOAUrFJ3/NxoTc/kxkotc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394919; c=relaxed/simple;
	bh=FXqgskyyxMEHQpDTpG3OD2OtGubS/B3dpPTWi5fhBRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mpDUTXrw5egbeErKhQ+XG0Za7NgwG3ZRZCy5FMW4/ORBWPQf2ZWqa7jf4lplo/t2am0oTHp6FNNk+0DBKj2b3reZ65Ch0EuAyOuF48AHgnSUVjQD2/FaNOwESuP/v/ADgJXEIn/4nuEksfmLlxCIeJjM5cC9xeJWb0ilvQksNfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zk4rGw1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zk4rGw1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC05C4CEE4;
	Wed, 19 Mar 2025 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394919;
	bh=FXqgskyyxMEHQpDTpG3OD2OtGubS/B3dpPTWi5fhBRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zk4rGw1hlYrQ0GBpJ+Ska3xnXs2RXqV/N3ejvqxKzC87pytlj2Mhn9pnq6HDVXL8P
	 bfLXuODcjXUW6jH0KgLq0bGm45h+/oGyPPpj3+BmbxgLy+ZWUuflljVKw9NQa1lncN
	 yyWZmAivvMQyakAx8RbllbYjGkSmY0Xmib/TUbOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 129/241] cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()
Date: Wed, 19 Mar 2025 07:29:59 -0700
Message-ID: <20250319143030.917286519@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit cad3fc0a4c8cef07b07ceddc137f582267577250 ]

This would help to track and detect by caller if the reparse point type was
processed or not.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index b387dfbaf16b0..a93127c94aff9 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -724,13 +724,12 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 				 le32_to_cpu(buf->ReparseTag));
 			return -EIO;
 		}
-		break;
+		return 0;
 	default:
 		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
 			      le32_to_cpu(buf->ReparseTag));
-		break;
+		return -EOPNOTSUPP;
 	}
-	return 0;
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-- 
2.39.5



