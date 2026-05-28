Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4436DDDC5;
	Thu, 28 May 2026 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999896; cv=none; b=odily2j4UcNLJWfzEiihI5e8Zy4BmxUOYdBBlXRgUUEldL695yKKUy8k4mzX0eL81ccLjYCVeTc0i+VunlK3JxWGooVkWXn8HJkb7v4vb812qVPgJBtKDtF38OYu9+5WPensfacWtt7OsOYMxp0vkBAMh02okKFm3w/aiLHAd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999896; c=relaxed/simple;
	bh=TOBMXyRAPIFSl21H2Wyg3czF1ZeupQNYYB2X09BMGUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAFkFQ8OBxaeIXIS5TQC2FLCF9oY7+jf8/Jw4NeR0N8IKo05Na/9ZPynlIOF0omZ1Mvp1Tvo5M8CQ3zRo/aJlA3vD8DfHvR1mS2G3wh3SsiJUnwTmL8moi3WdPQL/XIImNPKxwOE0iH+J3LgW/XZsKO3Oz+9WRrnFkTJyQH5jzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2+J1t9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2+J1t9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537031F000E9;
	Thu, 28 May 2026 20:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999894;
	bh=YYSrRMRelwnjQ8g0HmB0ds3oNI2411q0ugbF7k80/jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2+J1t9KA9QNO5bkKXENit5EUcS8lrzKoHuZDXIzJMETE9KeVoxyrz6VZywvW0cUI
	 6nItEWPXtgaxZScUCaQ2mMIWdKrIN9HlkyDNMu+yo32/wzFysHg6bZcXA55TT+276z
	 AqZw0sVeoSPtdmjyaBtkdBqiILF2eOe4LoI1apeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 228/377] zonefs: handle integer overflow in zonefs_fname_to_fno
Date: Thu, 28 May 2026 21:47:46 +0200
Message-ID: <20260528194644.993409492@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 3a8389d42bdf4213730f4067f8bfa78bae6564ef ]

In zonefs the file name in one of the two directories corresponds to the
zone number.

Here Alexey reported a possible integer overflow in zonefs_fname_to_fno(),
where the parsing of the zone number from the file name can overflow the
'long' data type.

Add a check for integer overflows and if the fno 'long' did overflow
return -ENOENT.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: d207794ababe ("zonefs: Dynamically create file inodes when needed")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 70be0b3dda496..7e345a6aa5510 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -610,10 +610,14 @@ static long zonefs_fname_to_fno(const struct qstr *fname)
 		return c - '0';
 
 	for (i = 0, rname = name + len - 1; i < len; i++, rname--) {
+		long digit;
+
 		c = *rname;
 		if (!isdigit(c))
 			return -ENOENT;
-		fno += (c - '0') * shift;
+		digit = (c - '0') * shift;
+		if (check_add_overflow(fno, digit, &fno))
+			return -ENOENT;
 		shift *= 10;
 	}
 
-- 
2.53.0



