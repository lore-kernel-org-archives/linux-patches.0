Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C1B264A85;
	Tue,  8 Apr 2025 10:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109711; cv=none; b=jLJlVhOKpdCHolDvai5JnJbQq0/omLQ6bw3IZKhRzuAYIG7Ej1zpE2qvmLcECi70e0lJ0XHmIOfVY/bVMWw810d/l/M8wrbkCkyfH4tmr5u70CVap8flXyqu9Pop4u8dEC3hcDuENcf880u5dyEgvhVwnubDN8nTnQLawiCHXJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109711; c=relaxed/simple;
	bh=dLs8TuTlUtUc2ktr3tr+AONK5aJbkeGe7g/SaQ8UsHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGRaYVgun5zVXPyrVCe/byZ3uejAiiUeAXFFlbi9+rOhBuN9QCq1xf4q7BF/57rVM63RaNVHOg7AGrCTCmGEjuwkfkjUery3DUq/wiOdG2J5G3R5bO8XzASuH6ubUOvIIBKm3Cmwo6jgzaZRH6/LhRZZ2F4iwvAGju/uiUQTUuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oTN8uxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oTN8uxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C197C4CEE5;
	Tue,  8 Apr 2025 10:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109709;
	bh=dLs8TuTlUtUc2ktr3tr+AONK5aJbkeGe7g/SaQ8UsHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oTN8uxa3CqIpa9i+T9QGBuy3M1NU0RU7si2XDXnQOJvz851MDk5VCOql+pgN/w9G
	 rx883y5UVaVwkCWy5kA7BK+18Xl8fweyMH4yczV9qQNRApMS8eYrZ9qdauZGcuUmO+
	 JSbZ0HEuFf1pJFcVDRtUAkdUb2Ob/XVmN5RcTylM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengen Du <chengen.du@canonical.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/227] iscsi_ibft: Fix UBSAN shift-out-of-bounds warning in ibft_attr_show_nic()
Date: Tue,  8 Apr 2025 12:46:42 +0200
Message-ID: <20250408104821.122436310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7127a04bca195..0d96dbbba74e6 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -312,7 +312,10 @@ static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
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



