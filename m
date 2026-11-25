Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621787;
	b=L5vRP4Vn/ghWCFlb8VSvzvoQ/K6katjL6mJHkTt6UmoYpXq6SefBRC0S3k4+Sf05K4iX
	 zv/g9KInCKOn0XHCepDiLNpdBVbDcYtSe3pFi6RuUbkX+NtogXXkSM04rzmsLvze98qPE
	 oddBoqH/Wk+XvnyATxWHjByWHM9zRyWRWRTVM81Snx92uMqXkLPDqYGXQjv7tVqqai+Nz
	 Ua4BIVuxn7G5Xm/oEKEUGu2VpJPkr8+Vgz/PaBZyRP+RoC238WfsqgJo7DovMP+0p4xIv
	 45AdLQjyyw7xd9PIL/lgPhGRh+/q4ycNHBliYIu22xlykPn3q97HJuhx4Rc9Yr7IjbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SOd2mzxPj6CNnRhNnsdVB4TUvhKA7ef3BUZf5p4NPrk=;
	b=SZfp8k5oNA4wlLbFPdw1NWYGcgT9AhEluKszuyQ+gRXZPtwQcpK6rdJvmFikDOsvuKt2
	 CahVquQkdZ77/zi2EPcCm9gacqDiQdpFf2CRKsh8ZCOuxbwF9JAZKZkQKCPoQPA8rcmBg
	 F16lCLB+ddSfYwwtvgv5Zf3UC5fR5/awV3yAnRUtA38PYLI8EOj2nCPR3RQB8nwheePvT
	 iA+B5yLV+iOwuBCabS9nsIq2gS5b6q0JbFgQoA5N17AK5BHaVTaHZOv1gCP7UOEZfgHwH
	 r9TNtQz/elCkG81+P7wCpI+rnErfi2/LZ7LbE3tbtTLSOHrgqEoPNS8WvJvd8s+omCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pz4YgYUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F58606A330;
	Wed, 25 Nov 2026 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pz4YgYUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E051F000C0;
	Wed, 25 Nov 2026 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621786;
	bh=SOd2mzxPj6CNnRhNnsdVB4TUvhKA7ef3BUZf5p4NPrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pz4YgYUPGFt/np55sUWJsrLYxUzl5YDNw2gfOXaf2Wuno0OIM52rI82cQcky6bHj8
	 Yp+jmeJlKwJJULYIeAZInSQ54H0JqBe+DHN0TGuobWBPW/Jvsfu13t1E+DMf+I8PXV
	 xtrKiEa05j9XXnrjsJ6GdrURgW8Gdv3ZFwmWSRr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/990] ata: libata-scsi: fix MODE SELECT field pointer for unsupported subpages
Date: Wed, 25 Nov 2026 15:28:22 +0100
Message-ID: <20261125143829.936535892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 2a4c61cf94d48ec8560473d4fd5383583ce8809c ]

When the mode page of a MODE SELECT parameter list has an unsupported
SUBPAGE CODE, ata_scsi_mode_select_xlat() sets the FIELD POINTER of the
INVALID FIELD IN PARAMETER LIST sense data to the SUBPAGE CODE byte of
the mode page header (byte 1 of the page) if the SPF bit is set, and to
the PAGE CODE byte (byte 0 of the page) otherwise.

However, the SPF bit is tested on p[0] after p has already been advanced
past the mode page header, so the test reads bit 6 of the first byte of
the mode page data instead. If the parameter list ends with the mode
page header, it even reads the byte that follows the parameter list in
buffer, which is not initialized when no data beyond the parameter list
was transferred.

The test is not needed anyway: spg can only be non-zero for a mode page
in sub_page format, i.e. with the SPF bit set, and the field in error is
the SUBPAGE CODE. Always set the FIELD POINTER to the SUBPAGE CODE byte,
which follows the mode parameter header, the block descriptors and the
PAGE CODE byte.

Fixes: 7780081c1f04 ("libata-scsi: Set information sense field for invalid parameter")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-14-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ff944a80e35c0..ce85f1dc69569 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4353,8 +4353,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 				break;
 			fallthrough;
 		default:
-			fp = (p[0] & 0x40) ? 1 : 0;
-			fp += hdr_len + bd_len;
+			fp = hdr_len + bd_len + 1;
 			goto invalid_param;
 		}
 	}
-- 
2.53.0



