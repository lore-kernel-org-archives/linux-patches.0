Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7547988D;
	Sat, 12 Sep 2026 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218130; cv=none; b=bzprPgScu5jqnTiS9LyPss+xRtgqqZasdCfyLw9N+22NyPjYdwxB8yYnv3TBDScH8zMr5J7CVFnsnqzHlt2Py2peA5jtzw2hNH18TIy/IIP58TQwwie8O5D7tO4VjYm5uK1pyzjrL/H9HbHfY223ckm4F1vXuno7/E/u9HRb6Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218130; c=relaxed/simple;
	bh=jDF6vALHapno91uUjpXGquwjDRca46Rvhc/yogmqBy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7DEhXvtMmHS/nauxRia3xf7K19kkA9JqvZJaTJ5Nj4c/Pf/PA7KO7Kx9QfLu+BUt11wRSaBBdKZp9ztVTbV1UOBEs9D/DJSVKinT3VoVPcDeoBuh6cWmy7AbS3kpklRtiXpTb+rfPyoIHYQtJXu1ayox4EXU05L5qyeLhZHy6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yACgH7np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yACgH7np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B89B1F000FF;
	Sat, 12 Sep 2026 13:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218128;
	bh=6wosZp+7T/Ozpv2hW+IKP6Dir/HFMj7Jqo3kqY9MJfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yACgH7np86MICY5bf56B/pYTlg741tgUJ7/lz4OqZBn8QiALbjV/HQrMVQQEheDUK
	 uL3HvxPYNrBK/F4/LeGVJP95MGh3Ffs/MKkLRbzFXHFf8jDXRIPxyzzBwKqVliVWfB
	 q11kSJ/thmUu6+SJwDVZgnh2m2oCvGKZVwrlKkfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1082/1376] mtd: ubi: Release device reference on busy detach
Date: Sat, 12 Sep 2026 08:58:28 +0200
Message-ID: <20260912065631.677165860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 31dd710cd84d5dd63c49f640d3a9f36c9699ca95 ]

ubi_detach_mtd_dev() obtains a device reference through ubi_get_device()
before checking whether the UBI device is busy. The busy return path drops
ubi->ref_count but leaves the device reference held, so the device object
cannot be released after a later detach.

Drop the device reference before returning -EBUSY.

Fixes: 7e84c961b2eb ("mtd: ubi: introduce pre-removal notification for UBI volumes")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index d8d3317f9763a..3b30c80cad43f 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1105,6 +1105,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi->ref_count -= 1;
 	if (ubi->ref_count) {
 		if (!anyway) {
+			put_device(&ubi->dev);
 			spin_unlock(&ubi_devices_lock);
 			return -EBUSY;
 		}
-- 
2.53.0



