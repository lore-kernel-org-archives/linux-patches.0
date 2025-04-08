Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156E5264FB6;
	Tue,  8 Apr 2025 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110709; cv=none; b=tzFV54mD2+5fFcdlpB2S7W6kF3IGHvhtNpGU7/cl5Cc8BrAdiNNRL0Vkk2sUvYufDRzOSewY0NRrzHX/3GZrVQMC2oBvTrL6CKUPE4xhsmPERMMSJC4DQMy1olPHvqOO0fiUJ45AzpTrqb/n7imHHpfNW6OHo+Qk5cRTdqZtaPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110709; c=relaxed/simple;
	bh=uvkYWI8Fh45LJKxP4A+EJncCb0Ein7AsJfEpna2T4oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T62/cWhnve0f98zkPek92OU2hYmCIWjtBXQlG8FsXzChIK02c7Q6NtdG3dxDvIRnq3GJIDYbGd4ibr+FKbahQLTJwmkGgJ2HReW8AD2bbg7O2r2ZBmRIS7Z6mgHpXiVlotw2tNZJZWq0ueCqpdWyijSZDuRIgmyq9iR5zoWcMA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK/ZTYUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK/ZTYUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C5C4CEE5;
	Tue,  8 Apr 2025 11:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110708;
	bh=uvkYWI8Fh45LJKxP4A+EJncCb0Ein7AsJfEpna2T4oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cK/ZTYUPQJx0ONdRfhbiy/aCp6eNq34967UBs2aF3KVGb4narzTvS8flz2XqPrK/2
	 KKm1ORjBsb8leElfG04Gzj8KRx3kMNhI5UfsW0UI07VO0tc1cVMaGiFUN2aDiCrGkx
	 z6s0XrMEjhlVnNtDi1rBj8ib1GI2u+pBrj5rhxZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 163/731] firmware: arm_scmi: use ioread64() instead of ioread64_hi_lo()
Date: Tue,  8 Apr 2025 12:41:00 +0200
Message-ID: <20250408104918.068129935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3b8c56d8072750fd9625f03b92d8d6000c98628f ]

The scmi_common_fastchannel_db_ring() function calls either ioread64()
or ioread64_hi_lo() depending on whether it is compiler for 32-bit
or 64-bit architectures.

The same logic is used to define ioread64() itself in the
linux/io-64-nonatomic-hi-lo.h header file, so the special case
is not really needed.

The behavior here should not change at all.

Fixes: 6f9ea4dabd2d ("firmware: arm_scmi: Generalize the fast channel support")
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20250304144346.1025658-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 60050da54bf24..1c75a4c9c3716 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1997,17 +1997,7 @@ static void scmi_common_fastchannel_db_ring(struct scmi_fc_db_info *db)
 	else if (db->width == 4)
 		SCMI_PROTO_FC_RING_DB(32);
 	else /* db->width == 8 */
-#ifdef CONFIG_64BIT
 		SCMI_PROTO_FC_RING_DB(64);
-#else
-	{
-		u64 val = 0;
-
-		if (db->mask)
-			val = ioread64_hi_lo(db->addr) & db->mask;
-		iowrite64_hi_lo(db->set | val, db->addr);
-	}
-#endif
 }
 
 /**
-- 
2.39.5



