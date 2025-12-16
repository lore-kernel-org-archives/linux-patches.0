Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2FF749C;
	Tue, 16 Dec 2025 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887165; cv=none; b=GY9HEGlA1wD5DNWejuyp/wGev7m7fxk99A+sYHOVV0/uqWhIdeaI0UZjyHEbKHXeU6Oynhjq7MWV7eeRonmFrn/KOoMkQ1Yq1GVWdrKPjJurnTSTzYckrYQNCgumN8of88l95Xw8o3/v4G09q3LA51A9CB5/80M3+MITfAPymbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887165; c=relaxed/simple;
	bh=TdIMqoA2jCSXX1Zmv0+y1Vf1uV8H4TFKF7a8bmx8598=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBpkem9jEmZcPKhTNim9yt71uhRdqNfZvx1AqiexS+yEkd4janXl0cS+8sIBwsHjJbLhkBurNDTW9v+zr6mzAVGDjv8rhbcOaeOlofHIZNV1zjv4+Bw+qZvJEi+ZWSzKo7qrpy7KyHD0yjSvSNsHwIPK4/HrcZJml5qKNvzrx5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBrNcCiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBrNcCiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037BCC4CEF1;
	Tue, 16 Dec 2025 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887165;
	bh=TdIMqoA2jCSXX1Zmv0+y1Vf1uV8H4TFKF7a8bmx8598=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBrNcCiZMetuBaQm/gJeYLtwtWw5/pDLevyLUNLBh2GwjKosuO7iiymcQ/Kh9zJuS
	 EC8nK9sbGrPDql6RZ0aotqxxx+jPHf1+jDtu0oZnNDHt6bmdJzgBOTmDdcnbOTyhew
	 Az8t30lcH5ePD2fhLHFdktlOc/6BpGmBZQAJPnTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/614] tools/nolibc/dirent: avoid errno in readdir_r
Date: Tue, 16 Dec 2025 12:08:34 +0100
Message-ID: <20251216111406.663042594@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



