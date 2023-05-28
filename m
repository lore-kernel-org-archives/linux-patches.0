Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C389A611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D374C433EF;
	Sun, 28 May 2023 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302738;
	bh=mZ4KTD5fen5f2gRmA4Ey8cU94SF+hCSv6BZdHdLB/cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IORSKFZvnkLpYhE/MY1cxUWUpvYpkoDIunYSAboNNggCzz50WR9/sTmkp97QgG10c
	 Zju0ihjvWoPQkdcwZd04vlKFijNFM/ciRN7z4sHL2cBAsLPCf5RR+2nNa0E4w4eQ6M
	 m2XUWwcKbcush3v70MTJMSAVqYZtHoAje5jKbcdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erez Shitrit <erezsh@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 107/119] net/mlx5: DR, Fix crc32 calculation to work on big-endian (BE) CPUs
Date: Sun, 28 May 2023 20:11:47 +0100
Message-Id: <20230528190839.045433646@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Erez Shitrit <erezsh@nvidia.com>

commit 1e5daf5565b61a96e570865091589afc9156e3d3 upstream.

When calculating crc for hash index we use the function crc32 that
calculates for little-endian (LE) arch.
Then we convert it to network endianness using htonl(), but it's wrong
to do the conversion in BE archs since the crc32 value is already LE.

The solution is to switch the bytes from the crc result for all types
of arc.

Fixes: 40416d8ede65 ("net/mlx5: DR, Replace CRC32 implementation to use kernel lib")
Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -15,7 +15,8 @@ static u32 dr_ste_crc32_calc(const void
 {
 	u32 crc = crc32(0, input_data, length);
 
-	return (__force u32)htonl(crc);
+	return (__force u32)((crc >> 24) & 0xff) | ((crc << 8) & 0xff0000) |
+			    ((crc >> 8) & 0xff00) | ((crc << 24) & 0xff000000);
 }
 
 bool mlx5dr_ste_supp_ttl_cs_recalc(struct mlx5dr_cmd_caps *caps)


