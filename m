Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D4713B7A2;
	Tue, 27 Feb 2024 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041848; cv=none; b=LPFfk79+oxCIyHPJz5kAMkB6QT45hxC1h4fGpIEVLL5dJ3xnIOmHMLxZ36RZ1Drob9NSBIqTcn+tceMMoSTCnV5QbO9nXMR0uLu5z34NMAHsaJvA87QZKo0lCqWujeTzIeY9o1Wu6w/W3LS6g6QiEp5kIB1eJAYd07Lz2d6HIVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041848; c=relaxed/simple;
	bh=1GSPrAlfI9/XPzxmsmwc4/tBrKZa0bT6yD4rbUADj8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JM9CnBpgPBhyKyFHmh0S4u6OxdOU1C1V76IGnpq+Td+PJJJy6dnlOzLNGwQ1NHgXFrwqdm2n7v3HMRsTrWgwfysFpC0JD4r+dq76wcimvMT3BFLR/nPXifv8D3GuJKyVm/pBVgy4Gw55He2Wnpx7GxEjQD+HUKGu9MY8llgokMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7bBQkMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7bBQkMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96362C433F1;
	Tue, 27 Feb 2024 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041848;
	bh=1GSPrAlfI9/XPzxmsmwc4/tBrKZa0bT6yD4rbUADj8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7bBQkMJ4aUTogNlxWaLHu6NcgLG3w2CDrZtl6IsuC7/CwkxDuvM44G8VhqSqg6nq
	 LII/nXXCixpFfzyaZDtDzGoxktLT+UQvlw430HpakSpx96pRcty94hqOCnQlop2er7
	 mkM0NmhbK1ZH/ktWdM78fXJiPjV78Y0dEuw+Vd/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/299] fs/ntfs3: Fixed overflow check in mi_enum_attr()
Date: Tue, 27 Feb 2024 14:23:20 +0100
Message-ID: <20240227131628.775018792@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

[ Upstream commit 652cfeb43d6b9aba5c7c4902bed7a7340df131fb ]

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 7b6423584eaee..6aa3a9d44df1b 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -279,7 +279,7 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		if (t16 > asize)
 			return NULL;
 
-		if (t16 + le32_to_cpu(attr->res.data_size) > asize)
+		if (le32_to_cpu(attr->res.data_size) > asize - t16)
 			return NULL;
 
 		t32 = sizeof(short) * attr->name_len;
-- 
2.43.0



