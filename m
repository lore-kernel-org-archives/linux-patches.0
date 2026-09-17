Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CAD58FD2D;
	Thu, 17 Sep 2026 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658983; cv=none; b=lYq9GPfVB4MCh7p3HOR4jUkt/f3tpnyer/voFL4L/724dqQIjYODCRQ0toqDPIMeHXp32QDX+xHZI9Ot/drveoRZvC4XNYOm/O/YX4cg4qfSCWJNR9CB6O6/1jlmvqsTUuUwKBncWpCQdyW/CAww30cdSR2iZhZEPWyTn/DMj+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658983; c=relaxed/simple;
	bh=bAbM83pVMmxg/fRHrWioIFxJSUWC0mImcItewETTTVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVFHeQzx7Yz6CjOQi72NV9A7VWjTCtW6xVURllpp0A1Xq+JWQyzbnBHI01UnI57wy5TQEHIY/U4xZt4s+xW7oVYqa4Eofaipv8vnKeLFTdZzP7Ixpu60Les2mt+EEd2/sRbhbMGy6XrlcPYFfTCWQumsXmIt8zCBb7DIpgY2EGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGD5uG7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGD5uG7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDAC1F00898;
	Thu, 17 Sep 2026 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658974;
	bh=aNGYabKnTzLAC6mokFqP8gGZkTUaK1kuilJU3+Hydfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGD5uG7/m9Bbpv12mrupSPeT6S3xKfr1UXrYk5LHiNswIgfjlzWP4O8z3TJy5smv3
	 CvIWFyyjXiFljHkVT0w9C2AmMGnwdPH+byL1mtg5V7WxIiDa18FhcEvBsCpc3zIXET
	 IDRdUDIm2FaFn4jr84aBwesx+pBJDjoB6MmWyI3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 101/733] s390/ipl: Fix NULL deref in kdump without re-IPL parm block
Date: Thu, 17 Sep 2026 16:06:49 +0100
Message-ID: <20260917151353.473492085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 3c346b02ceb95..7024fc4137152 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1157,6 +1157,8 @@ static struct attribute_group reipl_nss_attr_group = {
 
 void set_os_info_reipl_block(void)
 {
+	if (!reipl_block_actual)
+		return;
 	os_info_entry_add_data(OS_INFO_REIPL_BLOCK, reipl_block_actual,
 			       reipl_block_actual->hdr.len);
 }
-- 
2.53.0



