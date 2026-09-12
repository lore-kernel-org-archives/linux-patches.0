Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC2A35AC3E;
	Sat, 12 Sep 2026 08:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203301; cv=none; b=m4n+T9tq5kgLN+XfQiT732j3gnR+7OQpUsAWQygszJfwvSsnc8DZM8Sh4Tu/HfU07v2OXqbWuBDyVYKqLEdBhrJptwS42w5dkU/oL14wRkOc6uOJH6C9S/Og4BTquyr1TOVnZsm8oUeMR8XyvNMauq6vfjREnl3H8FmXqwoNkM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203301; c=relaxed/simple;
	bh=bPNZtyXqceM5u0xovJ4YgasIfMXBPgLPZRyR2gIOAbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJN9P85I+o9l38MUYBoT5ipq0jlSm1P9aTd53rtm6ItynHBvlSdRSge0j6Hv/gMEhAKQUEx18cbCotXffuKf1hs9MQagGlZfGlBM7TFG5xTrXwz0DuRZKUAC0vqUmEFFYQoKG7I6UPpfQcZ5NcXxk35VM8c7KqZScJwt3mu/hsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjoIOmZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjoIOmZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CD01F000FF;
	Sat, 12 Sep 2026 08:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203299;
	bh=eXEZZAaXizBBqv5KXQ9H7JBdwac4+wgAWf7P3QmK41I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjoIOmZBEOKi52dpzerH+PJ5S0Kwb0fggxS6+U5MV7o2vfW57I53taXOJ9AzpQVQC
	 +NCeb5HqaesZWBkJPo8zbs6ycEKmg1rY2raTHu+m7FdSCPUlgDLpknQ/7e5FLoGW/g
	 X0coFQBlrsrVkwvGxEK/giPDI9Pkg3ltCSHQrXLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1381/1815] mtd: ubi: Release device reference on busy detach
Date: Sat, 12 Sep 2026 08:52:11 +0200
Message-ID: <20260912065721.446959122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 90c5c83d90e3b..1997bb70b702f 100644
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



