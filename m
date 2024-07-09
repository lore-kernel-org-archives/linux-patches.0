Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB127713;
	Tue,  9 Jul 2024 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524412; cv=none; b=HcqnGLzYNJH8/JR+asvXoUgn0cDUu2oRY58BC9WY0dlHoD6zp+NxK44a4+qDwOEXVVpr/rtheXVxjYKK5agT3JWuQe4tXK4yT8vvBF1q1qb+vntRJFU9TVeYhO6klBD4CAV/lBgQ4jfKy+suNn74y067HPHlSQ11drAlSo++2L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524412; c=relaxed/simple;
	bh=Qp+erhX8cMtfd2io5P1AUSHesz337EhuoCfXnxP597k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFq0qQkOKOI++XAkSMu7NwYtia68xmDUBOUs0MLrtncfzScFlgvvTm4nuYYrDNhCuXhV+YygK/axCidijRXSJbO6OOfEFeMYWupIcnMCXGRTpOeugcbeB1W2rJN08BLQQpvskzvAsFhmWD4CZ8cqeNky327dt69w9A6hj6ikQUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiT+8VS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiT+8VS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18259C3277B;
	Tue,  9 Jul 2024 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524412;
	bh=Qp+erhX8cMtfd2io5P1AUSHesz337EhuoCfXnxP597k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiT+8VS6hc8rHNL24OGqWaajNvys0qdAv2SEjqa+0sBUzWYwLt16Fj1NSTef8uxJx
	 pwNMZgSYccp32uUQaiNajk65r5o2bSlMX5Q8HXlaPwS+Ye0s00p/cwdbm779fBrQGd
	 pSf8qA4grtDujbFgDcMj4zrvzkzaz33oJ6cC5xII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 174/197] fs/ntfs3: Mark volume as dirty if xattr is broken
Date: Tue,  9 Jul 2024 13:10:28 +0200
Message-ID: <20240709110715.681688765@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 24f6f5020b0b2c89c2cba5ec224547be95f753ee ]

Mark a volume as corrupted if the name length exceeds the space
occupied by ea.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 53e7d1fa036aa..73785dece7a7f 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -219,8 +219,11 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
-		if (ea->name_len > ea_size)
+		if (ea->name_len > ea_size) {
+			ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+			err = -EINVAL; /* corrupted fs */
 			break;
+		}
 
 		if (buffer) {
 			/* Check if we can use field ea->name */
-- 
2.43.0



