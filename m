Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219CD35973;
	Tue,  8 Apr 2025 11:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112326; cv=none; b=YwEbGB5uiBD+eE3fM0Rle44QZ6gfQ2KkQ7KQNUFj4gSrCCns6wJFbAFCDg9NCffwIkrOTB6ugVfqO1FqdF5TucQbja+Ougv0u5pH7m1AB2NnpSD+GMUMvP8BjocHhSivm0ryA0Ae2zrIKlXCqOeZbZgoxlRS434CJxA+GE4EFCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112326; c=relaxed/simple;
	bh=40QpU26GkonI0QKE7sdlQkYMWPxUQ9v1wP5yEIiOh+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UH3cia9/Us2SRjyKuFizcUtqQg/8uIK5HQnpRYRfVbSlaRoxOMsee1doMGtAjs5FCGPGLaE/ZqT7Y1Z4m3V1pMWVQZAnT45uV/xcdJacorCzmoJU5XY1SrWe1f1CyIrBMoVvtk2YHk5AM9uvT7/P3EVLmWWqaDvEqBH2NwwkfNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xd2/sZRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xd2/sZRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CA8C4CEE5;
	Tue,  8 Apr 2025 11:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112326;
	bh=40QpU26GkonI0QKE7sdlQkYMWPxUQ9v1wP5yEIiOh+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xd2/sZRadrIRsPIMEVClcibhlR2CSkaB66KecsuFYMW63m7geCIj99Iwfthy4fjyV
	 fdUeHTfObTDSUBBI+oTiqHeuAj0C8THRJl2a2s6/ByWq/IE5KfgtfWmQSHaF5xnMgB
	 AbnCZxT1L5M3LpQwqj95nU8OpLKok0JaN50BDrfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengen Du <chengen.du@canonical.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/279] iscsi_ibft: Fix UBSAN shift-out-of-bounds warning in ibft_attr_show_nic()
Date: Tue,  8 Apr 2025 12:46:50 +0200
Message-ID: <20250408104827.115441993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengen Du <chengen.du@canonical.com>

[ Upstream commit 07e0d99a2f701123ad3104c0f1a1e66bce74d6e5 ]

When performing an iSCSI boot using IPv6, iscsistart still reads the
/sys/firmware/ibft/ethernetX/subnet-mask entry. Since the IPv6 prefix
length is 64, this causes the shift exponent to become negative,
triggering a UBSAN warning. As the concept of a subnet mask does not
apply to IPv6, the value is set to ~0 to suppress the warning message.

Signed-off-by: Chengen Du <chengen.du@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/iscsi_ibft.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 6e9788324fea5..371f24569b3b2 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -310,7 +310,10 @@ static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
 		str += sprintf_ipaddr(str, nic->ip_addr);
 		break;
 	case ISCSI_BOOT_ETH_SUBNET_MASK:
-		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
+		if (nic->subnet_mask_prefix > 32)
+			val = cpu_to_be32(~0);
+		else
+			val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
 		str += sprintf(str, "%pI4", &val);
 		break;
 	case ISCSI_BOOT_ETH_PREFIX_LEN:
-- 
2.39.5



