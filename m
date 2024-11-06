Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850A41D416E;
	Wed,  6 Nov 2024 12:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895133; cv=none; b=r2mzI9PIrnpI3l7Y2JEjuYXndXHEDD9OLMviXAt57Ni+UuOMRotnZZX8Eg6tAhztz2LEV2y1UDeZz2dKIeS4GyN9vj6dFFX3Qu2rUcCFaiFybbEuElvDyXlgprgsOKn1YZGHof5U5Xue7hnq9dAlJh9WTkKcLZif80mWG7AmJ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895133; c=relaxed/simple;
	bh=WdRysko8dpb66i4sIz+p8JSLf+lc8To3V52llo/SRrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvIzCIE1wCd2ugH2u+QPAr3oJAiwZIjGucrQIot8AtMrDp73hQTw7zz8FuBEIPeOBE0cZ378WajFCWffFqcU+iLcjROD2tDO05eBGlxXOKefET22AFlJL/Ghb9frozB6Q0bQ+xIB3qLBAodKJIO/VjlZUDp+kk+SCUeYyLkkOUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afBkglyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afBkglyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEC5C4CECD;
	Wed,  6 Nov 2024 12:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895133;
	bh=WdRysko8dpb66i4sIz+p8JSLf+lc8To3V52llo/SRrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afBkglyFhd00BxlfEnE+303HZfbepY3oe2Wrfl0WBQu++Rcjnd0iQ/LajCxTw0ZoL
	 iMV8HDBz+gAcEdjqlxOPlAM/MsOSQ9alrelfTHf2MdzO1jsa+jJfzjR/hK7JzrVOrp
	 qRtpL8q5WCS8qMBHC+y1CC3GJFnVrNyTmtDn1Uac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 116/350] f2fs: prevent possible int overflow in dir_block_index()
Date: Wed,  6 Nov 2024 13:00:44 +0100
Message-ID: <20241106120323.769453763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 47f268f33dff4a5e31541a990dc09f116f80e61c upstream.

The result of multiplication between values derived from functions
dir_buckets() and bucket_blocks() *could* technically reach
2^30 * 2^2 = 2^32.

While unlikely to happen, it is prudent to ensure that it will not
lead to integer overflow. Thus, use mul_u32_u32() as it's more
appropriate to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 3843154598a0 ("f2fs: introduce large directory support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -79,7 +79,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


