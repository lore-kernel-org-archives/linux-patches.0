Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D13779FD;
	Thu, 11 Apr 2024 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832572; cv=none; b=EMAlgzfm0kb+Q1dbMeoHS9oRNRZaPeDZ+ScRTEUzRjh1t4SZqlJztsywdVuq9CUMnPxvMg+7uCBInGxydbSfw5p9KYAku6E7f9fata1cNQRGyygvoDyfelcMNWdeUxJXmZb1WwrXhFc6+O3ogiVLGlTxEKb9tveA88svhPuo3FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832572; c=relaxed/simple;
	bh=I3cwneSKWDAILHSGTtQaPMVTFHNrkXSsfkKfpc1ZxaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLSzCxmv3Gu7Z2TL6a6k5mit6ur7GIvRJtIH/XO2fNZmKn9tCkWn/jIlbhXVaMHMuVbHRKvCY5r1u5VIEP3yytRe2SgIIjFu5TAwTO2SYGjnTss8TlYU8bNa5y8wixI10Gfb1u53+Nt6+7izE2OPin37ZfZuuO0KytxoaZUcNsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOFiYWAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOFiYWAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141D6C433C7;
	Thu, 11 Apr 2024 10:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832572;
	bh=I3cwneSKWDAILHSGTtQaPMVTFHNrkXSsfkKfpc1ZxaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOFiYWAr+k+YxA+RRfsYSXAUboR4Fiu7kghCopmpSSNFc72wKvr7i4jVa+2Ve1B/K
	 uzTCl+as7I1aT56ppOODn3uR92Pkhid5emuuYOhfHSPK2xGBe4EdblF2lCLhRXe8fI
	 EQIT7fZrpHOxPXeDcOXB/+Kohokhoy5c7Q6vC+k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/57] pstore/zone: Add a null pointer check to the psz_kmsg_read
Date: Thu, 11 Apr 2024 11:57:19 +0200
Message-ID: <20240411095408.334651070@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 98bc7e26e14fbb26a6abf97603d59532475e97f8 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118100206.213928-1-chentao@kylinos.cn
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/zone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index 5d3f944f60185..295040c249d91 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -973,6 +973,8 @@ static ssize_t psz_kmsg_read(struct pstore_zone *zone,
 		char *buf = kasprintf(GFP_KERNEL, "%s: Total %d times\n",
 				      kmsg_dump_reason_str(record->reason),
 				      record->count);
+		if (!buf)
+			return -ENOMEM;
 		hlen = strlen(buf);
 		record->buf = krealloc(buf, hlen + size, GFP_KERNEL);
 		if (!record->buf) {
-- 
2.43.0



