Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED2934F49D;
	Tue, 26 Aug 2025 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216368; cv=none; b=QHuoId9shC/5kJKFTuytCVhTOOiigaQI5qn/44x50CdIsiNsq7x/7M1Er44oFkVLOqAYvQE93Pc/pAjd/e6Ozx7cu0KkbWibNbppzkyRzl5qw+l7sOGYd7Xd40UrGA0a4mS7vcimsUYSEix1rJOtX2QtwOpyGR6215Tg62WLTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216368; c=relaxed/simple;
	bh=anTM6/3mCIhJt+7KnwR2sU8dLpexHOEhCqgFOjhVdZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EGUdxHXkHUabetrljI0XzjPn5nq2Wtov+iW1AJESU1iVBYyJg1SLRFlkVamBge1D/RAl0GbCfHYPeDqGEp34Xs1aPwZ4oO4BWUy3l4qWfQaR6DNW+8dveB4CSqpY4hp4gVatIiTuwRh/ZOVj2QTBje5guYMZzn4bq0O/i/mIFDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cPBrWF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cPBrWF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6066C4CEF1;
	Tue, 26 Aug 2025 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216368;
	bh=anTM6/3mCIhJt+7KnwR2sU8dLpexHOEhCqgFOjhVdZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cPBrWF4vBzpfupLtg7AgIuxnn8Xpkge3T+Ey8Vy+rOCplEFIFE2vI8hrnINNsr+j
	 cMGbO5x256VdcxVxJuctmQk0zhkIcBAqAuv9+hVXhi75gEySV5SsqcZ/sC8rfwPDp5
	 C28NkWgzp09ZJ6CLDDWF2hCM6HHrK+hgPx5PoPeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/644] cifs: Fix calling CIFSFindFirst() for root path without msearch
Date: Tue, 26 Aug 2025 13:07:55 +0200
Message-ID: <20250826110955.959648328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/cifssmb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6ca08e473a7e..e6541bd5c63d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4362,6 +4362,12 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -4373,6 +4379,10 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
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



