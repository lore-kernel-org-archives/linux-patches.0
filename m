Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3207434D3BD;
	Tue, 16 Dec 2025 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885391; cv=none; b=WRjvfW9dzNn73flrdU7Nj8WxF//2Ebgx0an8GCfhwjMwgXqx9DQXtYcuLpGmdvyP2uJBQbtSJEurky+qB0Fo8IG6tZe5REMmGLQiIZZjauigKe+RKEoj/XlVvQUOBv2rwj+vUC4UQ8WE18F5PuCLSv73f9gvo7asVsbD+j3L75U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885391; c=relaxed/simple;
	bh=h4TD0yuoOWZslL8g/vl0dbsi6E7oB84ufrzaFTsFwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVdl1X/jYqIXi9o3A2F7owjhBnk3mzeKJIGR+WFdbvvUJd1YayEr32AJ16UIVo9VFT9YZtXyzrceveXvWqbaOgLsnxUUz9oOzCL9HFl2l5DzE4xIcwFoQ/9uA9TWPtncT3VX/ZVJ4MzcpMO4nTs32E4mAE7vMSErm/MIOZSVzfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdgyfCf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdgyfCf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7581C4CEF1;
	Tue, 16 Dec 2025 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885391;
	bh=h4TD0yuoOWZslL8g/vl0dbsi6E7oB84ufrzaFTsFwO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdgyfCf5PlnHcmHST6xT9JroMy9a7U16ti/8qXL7/PrTE79jwvGqD9D7UJ0WIyJTt
	 4p7zOCBXqVsdTkyu8dOD636cismn/YZ4OnfHAoj3x0ULhyLHz4yTLZVLzdiEDQDz/o
	 Z88vqenZbmwl3K2VaRMOttB2So7U5NW5JKGCQdd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/507] tools/nolibc/dirent: avoid errno in readdir_r
Date: Tue, 16 Dec 2025 12:09:26 +0100
Message-ID: <20251216111350.060590242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 4ada5679f18dbbe92d87c37a842c3368e6ab5e4a ]

Using errno is not possible when NOLIBC_IGNORE_ERRNO is set. Use
sys_lseek instead of lseek as that avoids using errno.

Fixes: 665fa8dea90d ("tools/nolibc: add support for directory access")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/dirent.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/include/nolibc/dirent.h b/tools/include/nolibc/dirent.h
index 758b95c48e7a4..61a122a60327d 100644
--- a/tools/include/nolibc/dirent.h
+++ b/tools/include/nolibc/dirent.h
@@ -86,9 +86,9 @@ int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result)
 	 * readdir() can only return one entry at a time.
 	 * Make sure the non-returned ones are not skipped.
 	 */
-	ret = lseek(fd, ldir->d_off, SEEK_SET);
-	if (ret == -1)
-		return errno;
+	ret = sys_lseek(fd, ldir->d_off, SEEK_SET);
+	if (ret < 0)
+		return -ret;
 
 	entry->d_ino = ldir->d_ino;
 	/* the destination should always be big enough */
-- 
2.51.0



