Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16641A0DD5;
	Thu,  6 Jun 2024 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683679; cv=none; b=ukvCg8CicWKvyxLvGnLMusFbkX2gwFLviQD2pFZJ66Pq9be+tz/E9cjxoR54RrhQ0HjRPTrb7wDUcc8z67DxS6BGJsw/HwpUo5Wez2Y6DzZYCSVSF0ahvAsKbeH9314aaT+aCPFD8BAplhCv1sjHW9i1yMY86KsMNRi+4D95ES0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683679; c=relaxed/simple;
	bh=XwEDPbYWOQpJERMY50WHLw83+ReiMniIFxgT+ZRON0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/bWTr03Ho6bBln/vmbOYnXajLvEoK/VH1bz2L230RR+8eRBlJ9KRSz5aQs+IfordQMeY2l9Bu6L0ORzcCFCY31Pdb64cndCJ73EaYmBGVfr4GwbMm5QqtUvgF5Aj+4xXX4dmpGcx2L9crXyqBIovgpa0NnykPhU+fY/vMmq7zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGwID0L0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGwID0L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A572EC2BD10;
	Thu,  6 Jun 2024 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683679;
	bh=XwEDPbYWOQpJERMY50WHLw83+ReiMniIFxgT+ZRON0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGwID0L0QPdC5YsHoCwjC/u+9mR1ztAT89nfrSVWri2lLEp+mUO0VECxhZV7TMvYZ
	 gwqn/7JJyzp8mNVNBFYYtt/pWb4/di3v24r1HccNzjaJIcqbiWPLHrIcDUw3xcGoME
	 jW9/Vvdk3bpuPDmyPYAkrQkd7EwMlahxPXeeUUIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 580/744] fs/ntfs3: Use 64 bit variable to avoid 32 bit overflow
Date: Thu,  6 Jun 2024 16:04:12 +0200
Message-ID: <20240606131751.065970847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e931f6b630ffb22d66caab202a52aa8cbb10c649 ]

For example, in the expression:
	vbo = 2 * vbo + skip

Fixes: b46acd6a6a627 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 855519713bf79..4085fe30bf481 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1184,7 +1184,8 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 static int log_read_rst(struct ntfs_log *log, bool first,
 			struct restart_info *info)
 {
-	u32 skip, vbo;
+	u32 skip;
+	u64 vbo;
 	struct RESTART_HDR *r_page = NULL;
 
 	/* Determine which restart area we are looking for. */
-- 
2.43.0



