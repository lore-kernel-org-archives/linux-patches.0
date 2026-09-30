Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E4B3502A8;
	Wed, 30 Sep 2026 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795010; cv=none; b=d4VEqS1vxijcJIHH6kKjEf1CubCr7NjEHJaSd5Oa6cUtCU74mS3iUUAdFXvJtaFmXPiNbs9okDyxzEkjSnpLmjSqQbbcid9VtsXqC3UUINn2U3q89s6RA1HC4Dr2xypAH5wF0T6dV0EhMIzbyQkUGtAYlb2oyfVGDKxo27N3kw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795010; c=relaxed/simple;
	bh=CbmrwigMaMnIhj5TqGYme9pxua4viknlEBxkapG/KRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Tr1GzV5PE8cEUSNBzAHw/v/HaXxEfFUPkgp4Vn4Wqho+b/EFnLr0JHtI8QQwQkjy57xOs0qfKX9yTPT92YQduSoenJHTugeB8lG4+ww2Aa4LmwDPi5fp8wlqtVJs7fPg9qjLePYmTyCX6sDyGtVrQv7h+7TlXUe1WsODmrsUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcrEex9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcrEex9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9831F000FF;
	Wed, 30 Sep 2026 19:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795009;
	bh=GvU5IMZtUk1hJn5IngaD5I5tso2ftezqFWeRYTcrib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcrEex9PBZoUf+qBDr2bX2PHmUnS4SMTfRmPVhncn0L3ey3Gx3KduSz3XP6DM5ph8
	 ImKdUyutgrLqbbFxi2KkS04vhSqSm3Sy3853dBuZK9avFpjyF37tq9W3PFsLn/3yf3
	 W/AFquwpiyzk29Blw8Y1Dpxu0Zq9uhWxbImQ8XW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0410/1193] s390/ipl: Fix NULL deref in kdump without re-IPL parm block
Date: Wed, 30 Sep 2026 17:18:14 +0200
Message-ID: <20260930152443.310507915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 7f918871112e8e7c581e99eb8e545af4e59c8367 ]

Some IPL types, like HMC FTP boot or QEMU direct kernel boot, might
not provide an IPL parameter block. In this case, reipl_type_init()
selects IPL_TYPE_UNKNOWN, and reipl_block_actual remains NULL.

kdump passes the re-IPL parameter block to the dump kernel through
os_info. Before commit 3b9678472bab ("s390/ipl: correct kdump reipl
block checksum calculation"), the os_info entry was added only for
IPL types which initialized reipl_block_actual. That commit moved the
os_info update to machine_crash_shutdown(), making it unconditional. As
a result, set_os_info_reipl_block() dereferences reipl_block_actual for
IPL_TYPE_UNKNOWN. This may happen to work by chance when address zero
contains readable lowcore data and the resulting empty os_info entry is
ignored by the dump kernel.

Skip the os_info update when no re-IPL parameter block is available.
Kdump then collect the dump and reboot without setting re-IPL parameter
block.

Fixes: 3b9678472bab ("s390/ipl: correct kdump reipl block checksum calculation")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 739fe97720f5f..806a32cb22a7b 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1230,6 +1230,8 @@ static struct attribute_group reipl_nss_attr_group = {
 
 void set_os_info_reipl_block(void)
 {
+	if (!reipl_block_actual)
+		return;
 	os_info_entry_add_data(OS_INFO_REIPL_BLOCK, reipl_block_actual,
 			       reipl_block_actual->hdr.len);
 }
-- 
2.53.0



