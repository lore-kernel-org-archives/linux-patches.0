Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C810E1C860B;
	Tue, 26 Aug 2025 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213100; cv=none; b=YhunbsQYIR5FB+TEmUe+QNPbJkr8kUPYJIjGA7S6WozPqF7HXutu/s5DtNXMjJvwiDzvnJwByLWGGrwv6+8VnRwXHx6LhmutPq8wji7jtvf8ygy54nFSygfbSe/PYZnXiusdy0Ax3eYQypRq0iI+DK363qv1UHSXr4XdFUDgVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213100; c=relaxed/simple;
	bh=4UXw2U71UI+FonbDFqh+1N8FTq9+j3TPFARwWz4ynDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cv4sBg5JyRJe0crSjkcjypNQqlJ9UVcLB2i3wsYbF0ACAQhtoTApeZ0l+SE5TIqbCAO50DMX4cJaxKkcxr1bekoWJ7i1Ccnud/NEF7OuNPf73cnAeS6BGLktZgVaO6zRImVw6Wt9A0BRAbb94Z/ndJJMi+eXlvzOHE3Il8cjbo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWWKEOOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWWKEOOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ED9C4CEF1;
	Tue, 26 Aug 2025 12:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213100;
	bh=4UXw2U71UI+FonbDFqh+1N8FTq9+j3TPFARwWz4ynDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWWKEOObtnk+h2Z/DneSSITeSMpgeoNaVtqsTuZyY7e33zTGz2p+ojoWkwC5/DpL4
	 S+lYvSdWsncOb52ZVuqkX5Ee6ntUI9ODeK6KBQ06TpiVQJP5XqoJZr9jBxW4kI3cBn
	 vQfM9d5mDmM9VK/HWAAfcH7/W6O0ABhtLaOk9NoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/587] cifs: Fix calling CIFSFindFirst() for root path without msearch
Date: Tue, 26 Aug 2025 13:06:09 +0200
Message-ID: <20250826110958.534594839@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b460249b9a1dab7a9f58483e5349d045ad6d585c ]

To query root path (without msearch wildcard) it is needed to
send pattern '\' instead of '' (empty string).

This allows to use CIFSFindFirst() to query information about root path
which is being used in followup changes.

This change fixes the stat() syscall called on the root path on the mount.
It is because stat() syscall uses the cifs_query_path_info() function and
it can fallback to the CIFSFindFirst() usage with msearch=false.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 81d425f571e2..91f4e50af1e9 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3984,6 +3984,12 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			pSMB->FileName[name_len] = 0;
 			pSMB->FileName[name_len+1] = 0;
 			name_len += 2;
+		} else if (!searchName[0]) {
+			pSMB->FileName[0] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[1] = 0;
+			pSMB->FileName[2] = 0;
+			pSMB->FileName[3] = 0;
+			name_len = 4;
 		}
 	} else {
 		name_len = copy_path_name(pSMB->FileName, searchName);
@@ -3995,6 +4001,10 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			pSMB->FileName[name_len] = '*';
 			pSMB->FileName[name_len+1] = 0;
 			name_len += 2;
+		} else if (!searchName[0]) {
+			pSMB->FileName[0] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[1] = 0;
+			name_len = 2;
 		}
 	}
 
-- 
2.39.5



