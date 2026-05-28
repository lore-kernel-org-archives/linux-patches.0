Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C77F2F260C;
	Thu, 28 May 2026 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001441; cv=none; b=a3Zwx4SztSEK7kcbn1uOxsIAaynP/KcxCV4/0/S4/vbqmU7XIjIOh1fVURwnIAvZfiKeZyxTeeeFDUlJYU1jxRKuJdNn6/crdqQbygephaBM4oLMHwFQJtTyiN5ROjnVGT8xOaaHCfTkRJbHP5xOhjdnrUXW9bnb5X6EocxKNVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001441; c=relaxed/simple;
	bh=RTw6pl2CJ01NI/B/tY/YCZHxY6Qpv5zfJOnfucmfcAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEsYqbxvqDTrFM2UD7yW6ncIC97Q1uQb+jhlw8mq+37ZJOamk362DksWxSNVC4P8nivr39EjKtq0tCHk95XfpjGgpL7kpDs3/2MEO3OK+UjA3Dbc2oHGC+5i7yN4Dgdns0CeNNDvXPiL8PnVnRSp/jtWk9kuK/IoWEObGqv3QuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKTBQEBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKTBQEBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD541F000E9;
	Thu, 28 May 2026 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001440;
	bh=lGZ6DBuF+h1QloFf4Z/cBRMlz58wtYWZ8n9hToX4D8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKTBQEBEt1Ql5CsvrShMlfV29Klm5V7nXCty8AykQcY522MUymACh/jwKkNwr527C
	 CDE2D4UC7w4+ulZMHIt0y1IH6+ZXKVwA6IfURF0t0Uj5cI9mggnyRmbX1TKo6XmEXu
	 F3bbxaWe6pNt8O7ZfS+SSVPJ4WqNzI5VoPLy/wto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/186] zonefs: handle integer overflow in zonefs_fname_to_fno
Date: Thu, 28 May 2026 21:50:08 +0200
Message-ID: <20260528194932.401908647@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cc364669d723d..f1ebe46084570 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -627,10 +627,14 @@ static long zonefs_fname_to_fno(const struct qstr *fname)
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



