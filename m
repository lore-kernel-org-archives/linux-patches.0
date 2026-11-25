Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624832;
	b=LGr8ixXNvmZix2W25j72Od2eyPJwGQWG3hCAvk/GOYcbqJL7a/eifSit64D0diroClLM
	 EpTw1WBZbqGtXalMBD68gONnrkOMG3sg8xZY7re+2TmhPXJfOhlXPr2XVIOM3z0PYNPDT
	 M/XNv2Maf5EQ9lW8uA3+lo1Kp/0QgdtWRsvKm+lODTABi7AL4Q8vVHEeml8HcxlXDoDOF
	 C3gqhGeyksbU4Jz/VM8krAFtABWA+m/Y9DWxO8f/ZBJCHuuJQDDM/Yv1xRNQfPD1Wjgm4
	 puQ8a4vWI0wWl0hsCz5wqEtTk2wGtQydoqopZE+GKsnI330u6L4va/ljH+7N3ruzWgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ueb3LrvGlr49t1NoejR/7xSFup9MUO1hrRHZNUXzE9A=;
	b=D43PgcAvlERU2k03JAWUGbExsGaEdi94ohaqt1lpMfV0d0ttkFVEeNRKXsXNmuOJU8+w
	 rbR7ThEDDbcKUk10oXhuxh5uIkgoCQ72o/YEjRyYQ9hHRTnK0yHssduvyAyQ7HOlJMcDD
	 1DQFCNi2XrgmN+p/qChNMN7RNV72v+eRVsmcMsqTYbCLX1/Aud3lvYn8eICmlGKbuky1X
	 Czi/9cXVMNBuH9GMkc6zo209WPAyksI3p3tox0DOUYJ+aHrKI8DbrQJ+8N4n+gXzIlmbc
	 mfeX8XsqUt8EovbbhX11QX8JEHsVz4czgEelFVAqoc+qbZYclSnjK3E7Nej+jYroexA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU9VzH8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65E606A323;
	Wed, 25 Nov 2026 16:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU9VzH8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00CE1F000D0;
	Wed, 25 Nov 2026 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624831;
	bh=ueb3LrvGlr49t1NoejR/7xSFup9MUO1hrRHZNUXzE9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OU9VzH8Pm1hjHHvwNvpogWffeA073hLgSGVKZn6XVu3Jn4VA3cbG/pVFdh8VjETl1
	 VKQnuFVPSdKvoAszhfjkQE46/+yFe6v5C5bF7l3HLHYNPpblNd9p2VrFxo2+RDhfNy
	 wfSixCDyQK81WstwNzCMRbTJGLvRiL7e79vqmCCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/816] ata: libata-scsi: fix MODE SELECT field pointer for unsupported subpages
Date: Wed, 25 Nov 2026 15:30:24 +0100
Message-ID: <20261125143855.599041445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 442f45099f0da..05aad48ccf5aa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4365,8 +4365,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



