Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E828C31B11A;
	Mon, 18 Aug 2025 13:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522308; cv=none; b=ovsZdrxMCH7c1rIBnNtcjyObBn8EoTM/7dOwza9VbnKnjeHzbx+U1UVVOE9zCg/18Qjf0SSiFDnn8Qs/jHfU5S/uXE9jloxl0lNmcTaO2KY01dJN/5G/ryhf8H1+4BPvaXJn/zzldJoEqCn7p8VhtZSMduAuospxlpEGSoCfYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522308; c=relaxed/simple;
	bh=oseI7lf0wIF97CxgBo2Y/1FcC9wd1r4wYfs8fpX7AZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HY0HRl0mo7F7GFuQWH42wqjjaehmGqhwn2IsoO4NtNpiH8MmIcWUynwuVWHGIZx30s8qx7pvg+AWgG/EPLfcrixiS5tRprej7r9xPX1nlzceh3aK55jaFESC2qTiLOMYmSHaP8zI/346DxuB7a9qmlpT8PovijScmG1VSD2SUnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHVlnoJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHVlnoJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58515C4CEEB;
	Mon, 18 Aug 2025 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522307;
	bh=oseI7lf0wIF97CxgBo2Y/1FcC9wd1r4wYfs8fpX7AZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHVlnoJAHWnpLcTEY/gRvoHPgxAnauXVxnD15kKhbIRz4XcFxNJ0R7leSK6LBpemJ
	 NY/znaVsW6iRXQH9BLzuyI6+Wg4GZqL93gKifG6+RqTPOXybWE+0RtO8l8FApiAW0A
	 XPle/lCEHEFK9+RHoQLQwke7/ACMkTREr5aHzyLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/444] cifs: Fix calling CIFSFindFirst() for root path without msearch
Date: Mon, 18 Aug 2025 14:45:03 +0200
Message-ID: <20250818124459.357021073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e3d9367eaec3..8a257cb29c95 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4028,6 +4028,12 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -4039,6 +4045,10 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
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



