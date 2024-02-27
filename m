Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7BE78B61;
	Tue, 27 Feb 2024 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042605; cv=none; b=mvN0Xvlk1TTl2H5TQOIkcVbJTfoN1sFwzucmRtB/mqQXv4Zvqg2hmq4/PEDkjwr2SATfsT4ebKhdBRNhRlm++QZN9Qp5BQA2tfvnncri5o3Un5Gpt7Imuj1j3m6X3YjYtnS0eC1DvoASLVkk/LlR68fMuJEHWo47Uc9/oQTfHp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042605; c=relaxed/simple;
	bh=RqyAC7pCc2tBgNhGH0yMajEGbCMQsmMns2VDe+mX9UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjTwhcwE88vKyqRUWbHiJPNjR7lQyjDdiKoavCuP4g6hUF0mI7iGcu8tH2JpQbXqTTy8J2CHLZB8xsLHYf4GGm05+GlTvsyquMQ4O5YVNHsAKDQ/4Sy9hd2D/oSD3Z4+dGcMKBjDoKkp3wyMV0K9862uiNGcZpb2R6Zp1rOSwM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTU6VuuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTU6VuuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C843C433C7;
	Tue, 27 Feb 2024 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042605;
	bh=RqyAC7pCc2tBgNhGH0yMajEGbCMQsmMns2VDe+mX9UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTU6VuuALMsUU2KSyZsOOQG599qwpuvOaxJVM5TZtt/RTdjpbmpl8jtl9mfM8iOon
	 +a7lqCuA7JVVfNirrFLRdHjjBE5cJid03yRqnXtlumAG7fdCMr4CBwG+LFlbRQaS+x
	 PUyzCdO2fEUBmthlaH8ThLDp4SjSOgLjG2GplaWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/245] fs/ntfs3: Correct hard links updating when dealing with DOS names
Date: Tue, 27 Feb 2024 14:24:02 +0100
Message-ID: <20240227131616.881046672@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1918c10e137eae266b8eb0ab1cc14421dcb0e3e2 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 938fc286963f2..ac43e4a6d57d1 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -509,8 +509,20 @@ bool mi_remove_attr(struct ntfs_inode *ni, struct mft_inode *mi,
 		return false;
 
 	if (ni && is_attr_indexed(attr)) {
-		le16_add_cpu(&ni->mi.mrec->hard_links, -1);
-		ni->mi.dirty = true;
+		u16 links = le16_to_cpu(ni->mi.mrec->hard_links);
+		struct ATTR_FILE_NAME *fname =
+			attr->type != ATTR_NAME ?
+				NULL :
+				resident_data_ex(attr,
+						 SIZEOF_ATTRIBUTE_FILENAME);
+		if (fname && fname->type == FILE_NAME_DOS) {
+			/* Do not decrease links count deleting DOS name. */
+		} else if (!links) {
+			/* minor error. Not critical. */
+		} else {
+			ni->mi.mrec->hard_links = cpu_to_le16(links - 1);
+			ni->mi.dirty = true;
+		}
 	}
 
 	used -= asize;
-- 
2.43.0



