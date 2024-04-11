Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F620142624;
	Thu, 11 Apr 2024 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832313; cv=none; b=KfqqWXWMdc0oHLxU5jTZAu05O1pDy2I/qriXmJU09RpFEc1iU06O2dcguPs+x0KT9C1PtyX48O9lA6nQ5MhW6Mr5C+YnR0JmKZ9aALAqaJuG50CZUuX2WaB7qrsoAyEeFm9kHfVPHP5NXq7mtp8AvtLiOF0LRlTxP2n8g3cpq3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832313; c=relaxed/simple;
	bh=JKrnKLgM2/8P+SDub5K/KiDaYEFSXU8BmE4Sri2hpL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4CyTVNKe4zNXnKuUVNvQZ/imbrvmHYM4MVPJdgvbVIQLOqrMUZPxW3iB28RQhGM1UhRir1AjemPGEtes5Jfa2SKnQOzFoMGwJU4g9Mmnpa1cabZ5YUSVkvM5wuCN4n8nqzro+K36tnKdLkWRzQy2SgZxqlySQ5rpAcchcT/Jos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhT+Ns2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhT+Ns2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA73C433F1;
	Thu, 11 Apr 2024 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832312;
	bh=JKrnKLgM2/8P+SDub5K/KiDaYEFSXU8BmE4Sri2hpL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhT+Ns2MHMvXXX0zNoi92cUbxLcX692At56GNrh0eMD7DkAGJLVY0gSHofoDuC643
	 LdALf5UU63W6m8dJvmqwVUZDUxX8nWv6ewGYrjgiRHIyXR1t/ncb1Li9OmDpouD5c7
	 YuL//rMoOi2jm9WluqhJoDNbbLbPZEIEUt1igEog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/294] tools: iio: replace seekdir() in iio_generic_buffer
Date: Thu, 11 Apr 2024 11:57:19 +0200
Message-ID: <20240411095443.853450033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 4e6500bfa053dc133021f9c144261b77b0ba7dc8 ]

Replace seekdir() with rewinddir() in order to fix a localized glibc bug.

One of the glibc patches that stable Gentoo is using causes an improper
directory stream positioning bug on 32bit arm. That in turn ends up as a
floating point exception in iio_generic_buffer.

The attached patch provides a fix by using an equivalent function which
should not cause trouble for other distros and is easier to reason about
in general as it obviously always goes back to to the start.

https://sourceware.org/bugzilla/show_bug.cgi?id=31212

Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Link: https://lore.kernel.org/r/20240108103224.3986-1-petre.rodan@subdimension.ro
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 48360994c2a13..b8745873928c5 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -373,7 +373,7 @@ int build_channel_array(const char *device_dir,
 		goto error_close_dir;
 	}
 
-	seekdir(dp, 0);
+	rewinddir(dp);
 	while (ent = readdir(dp), ent) {
 		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
 			   "_en") == 0) {
-- 
2.43.0



