Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF3779FD;
	Thu, 11 Apr 2024 10:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832659; cv=none; b=aRVfpkUYKZbwUCZLnmyNNVibyZAy5onD+a8iMFK0u9dZky54zZXln9HlKOxyaTGl/RgBc51y676Ke2Ga2cra6aQp4PgvHgiea+TZ4Eo0LmWGqB4qekWX27jo7Br2yPIOSmJlcvELsiTcax0FwHeaP6oelzXKN0hKLPmYWs/Q6y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832659; c=relaxed/simple;
	bh=n75tymbpOI5E6oyI+Cfqhw/ksbpIi/JHeSJpaYdcF3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTwRslBlagRflS8EjnSPwSmlQSXzLmVwWMkVZMuX9uum06FOITKt+OZTJbiNKEYib5GWjKHa29EQcbhOHICN0zxv0Z/0MGxKD2pd1+Q9on3+MbNmXKFUxKKytlie4kjYoiWgNoa9uVPEF1x/eB3YiexHc+4+M4GxXkEeDtIdYF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgbB8K5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgbB8K5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84948C433C7;
	Thu, 11 Apr 2024 10:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832658;
	bh=n75tymbpOI5E6oyI+Cfqhw/ksbpIi/JHeSJpaYdcF3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgbB8K5hDB/V8oEJm+u1lGu6NVlK6jh/st9uTcZZfZHM6RnYY+5NUt08dVbHleF9Z
	 Rd7TybnbDGgbQzo1toL1hyFhYGoewSRuHlBVQJLwNgmwbqLK2LiSc+MN/6fFPDJk77
	 tNQeha94MVbTPCMpzOhN5p7S+QQtvQtCqo3H1gTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/57] tools: iio: replace seekdir() in iio_generic_buffer
Date: Thu, 11 Apr 2024 11:57:47 +0200
Message-ID: <20240411095409.175223112@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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
index 6a00a6eecaef0..c5c5082cb24e5 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -376,7 +376,7 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 		goto error_close_dir;
 	}
 
-	seekdir(dp, 0);
+	rewinddir(dp);
 	while (ent = readdir(dp), ent) {
 		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
 			   "_en") == 0) {
-- 
2.43.0



