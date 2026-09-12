Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33611386455;
	Sat, 12 Sep 2026 09:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204521; cv=none; b=qZsG/5tv5rWhLax4uCfpGs3w4xE/Gz6/2Ngc6rGX1LnqRGD9rc7AbABGaGPRJjgVymzbkNqrLXtq5uoSQYLffQnyYZee3/TPnVjpw1wV4GVvbiHgZPBcllnd6C6YXsiJgvluL4q8cA+PuKQQdqGORwXG25S09GTpJ0ezBD+1CZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204521; c=relaxed/simple;
	bh=z00J/3uSXFh7IEyJiiYlZWaJZqUbpBNL40RV4lCrHIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWqXpmAiYj1T50EBYKXzO+gVGyQB71FucpzKYEwzlDzQr8msUDXwEOPn8cZX9v5jIQS6lpmFyxYBnOpSijbHzm23FDcDoDhFxjSEcBrfeFxD0e0hnKEgfN1MXBB7QCzOGGrRCXinyPxQw10eSEpP7qY0nfh9Aub712iDI/Gg144=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kzl7OMGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kzl7OMGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F4F1F000FF;
	Sat, 12 Sep 2026 09:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204517;
	bh=ZhEe3Asr5e+wW0DgnDKI7cnmcR4bIVBdit6MhY9+zqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kzl7OMGhh2uX82skFu5eXYoYm3zNPase5th/v2sFVz7XBO2iKKIp/hy8Qv3I7pS01
	 Cvfvcz9G2ZR71mxL4M/pUayqJLtX5QGYLz1yf/c7m3AuP/BoN7Yj+DlwdHqCvpnSKI
	 kY2eZNWhJSmXkRFYSI1NVQkrThtuC6ae+9lNlAfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1602/1815] ntfs: remove empty EA attribute pair
Date: Sat, 12 Sep 2026 08:55:52 +0200
Message-ID: <20260912065726.597731418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 772e4c8f25559e3b5c6c526253b3f771a4a4c02c ]

Removing the final xattr leaves an empty $EA stream. An empty $EA
attribute paired with $EA_INFORMATION is not a valid EA chain and
ntfsck reports it as corrupt.

Remove both attributes when the final EA entry is deleted.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 0eba3f41c7bb9..88bfd65606920 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -275,6 +275,15 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 		ea_info_qsize -= ea_size;
 		p_ea_info->ea_query_length = cpu_to_le32(ea_info_qsize);
 
+		if ((flags & XATTR_REPLACE) && !val_size && !ea_info_qsize) {
+			err = ntfs_attr_remove(ni, AT_EA, AT_UNNAMED, 0);
+			if (err)
+				goto out;
+
+			err = ntfs_attr_remove(ni, AT_EA_INFORMATION, AT_UNNAMED, 0);
+			goto out;
+		}
+
 		err = ntfs_write_ea(ni, AT_EA_INFORMATION, (char *)p_ea_info, 0,
 				sizeof(struct ea_information), false);
 		if (err)
-- 
2.53.0



