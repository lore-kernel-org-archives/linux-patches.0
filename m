Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98FC13FD94;
	Thu, 11 Apr 2024 10:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831093; cv=none; b=STZYCFsYoXsET5Y3LH7Aiy58n81NIYH9bL8CeHVrL7YBfDH42DjpVQXQbzp2Cb0OpWuLOnP+3+pDoQAP+22WDC+Cn7snNT6EQ4ZHwqznEUCSomUIeChSlQA8OgFc0sfKlf+QQr0zhMvmiOxWkYcwzbJgWSx1hoXDUZJEeUGDZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831093; c=relaxed/simple;
	bh=uLfxFcbhtOQEkwa9vRvuchlhUXbYp3ihe+1koowFtAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAd0g5eIJq8EPQCHTVyZ6x/YR70IqrFHXSAvNt97798jOi6X8Fwrgqxic+GVxrkJXxgOf11afcysme03aHNQevYCoSL5JvOfBs41IXXnfZuJFqO7m5w+GpuKPLys1ciwqAdLJmZuu75EAv17x+zDhOfIF931IzEYgRHhqzEUwYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDOLDjyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDOLDjyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B73DC433C7;
	Thu, 11 Apr 2024 10:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831093;
	bh=uLfxFcbhtOQEkwa9vRvuchlhUXbYp3ihe+1koowFtAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDOLDjyT84rJ36I/qEuYNLTTsRS+xjY08QTtLFj7melgQhmwS8GwHPbqPErSq2unX
	 R9QbZxF5O80sQ+TYpVIHw7m75uzVIKTdda7xMGbKAzY+mrnEbngzlKlkwWaCoglOmd
	 0ap4bO3ky1Hw1yw5OA7URGHvF9VIUeoIlpi2WC34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/215] tools: iio: replace seekdir() in iio_generic_buffer
Date: Thu, 11 Apr 2024 11:56:45 +0200
Message-ID: <20240411095430.752724387@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



