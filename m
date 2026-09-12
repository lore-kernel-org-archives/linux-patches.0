Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C26221F26;
	Sat, 12 Sep 2026 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211035; cv=none; b=UkMbBXlIC+D6WSKz4/kGuyBWnmOdvOES1OAeBb1YZpWXeIqn2vDEJUHqG98sc3KCCmuhf57SeVezMYe4PgGyINmJgI796yMzkf3hyFw/ESXJkijoIysCG2QtSxGSnqwNEuxbIn7WDxnVdod/mRK4uIQY5HJXQjTXzFzZWCg7HRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211035; c=relaxed/simple;
	bh=hYlfi8c2XpboYMWO1+SyxMy1lP95du/LTO3EDnoQr/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otaZuHSE5MUlVuxMw66KBGoz49jqBWz+KBfvz7eL6sB/h2UblrmPmKAw/ON1vjg9Q6sOCW8SwxxJUDEOD4TO9nUpeb8TmlQH/RZtkpNaF4YL1kCA5BfWbqJezC3it3OeNKLl0O4oRIjdaQHlRMNeJ2FJrbVo06Pi1MHB/7oihec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rme5rl7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rme5rl7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C8C1F000FF;
	Sat, 12 Sep 2026 11:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211034;
	bh=CMPC4agfOLw7n8/zNfPEoLrgdXGGm1r4FbbDVJ5ZpcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rme5rl7yKEhe7V+aLHsWKx4yFaFMsSEGMPMZfTCkfb01njS1hoqw0zkgT4lXL7n70
	 08eJR2apX7bHI4Qaml9kdviUdn/xzm/LwMv4A9YpGfYvpD7snhascLk5KJmWr4hO3E
	 LLjMvhrI8SM77QwFLUDSa44bhb3TLH/Vy2pir1Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1146/1518] mtd: ubi: Release device reference on busy detach
Date: Sat, 12 Sep 2026 08:55:15 +0200
Message-ID: <20260912065649.382234571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



