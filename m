Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621783;
	b=MLxxNAa9MEneGZkk7c5oib3r/8rjWYvKkt7tVVg/bxCW0ZdpYvLPxHE9V5ds8m0Z7OH6
	 2RSUkh/ylqSNLSEg3+BtpJfrZWAiq+cqXBZjCWf+5uOsmtQh2SiWbVBQMesbS+zsXlQ8M
	 JgC/hv53rD3H9DDSWJe1Q0zYmnzeKvmrLYua78F2WHy/V9HduAptSY1drPHXS0WlRIIGU
	 vzB3KAGATms4S64nwTrnxEj69coPCZ4pno5PYO/Puuo326RoJJu68f1HnksfVx4g9r/eU
	 VbnNkvh/iirkrJl3fuO2tUO6GnIB/xArki0ciAUMu7LLY623iv7Lfnlr57/iA/ZM5NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2IOMv41ytW/EBZKtmajpNNnM2BewSf6SPm9Q+4/QkEY=;
	b=I7dPPWsb6XlAf9Qh1YvA4ciW4B/CIfr9b42pg4O+48yNwmZ7LhP/ic3om7W+/haehN6H
	 bgBC432PVPmLTnkXIgmn35Lpa7j8x5EdXvqgwOhbG1jBh8a/FT1QI4vhtfWUgphjrXktd
	 w6Z0d/V+we9mRFHtJdH/syX2Q1PAR87nk1b/L+hAnDVaP8QN7vOQBYYicT15WN372e+AT
	 Gp5VFmeQVTlaKeqpWhDv9TmZmUpZh9WcK77Dy6ffql8JuyBLjaP8yKw+RQkmmJZxHgR7r
	 zGpuhrT24drYlUVuLmLTWQybPWc74mayup8nhf3fNhyPx264cYkNXVrblTMrdtJXHJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7dq2oZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D113D606A323;
	Wed, 25 Nov 2026 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7dq2oZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0028D1F000EF;
	Wed, 25 Nov 2026 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621783;
	bh=2IOMv41ytW/EBZKtmajpNNnM2BewSf6SPm9Q+4/QkEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7dq2oZT55X3mfcomQMvS7gW8dDdhaWyDzY1j42mUvP+jI4PvXU2XS+zFmvbRthWa
	 op5eGbfxIZqimasCvak33tVOBMg9Ok/6NuaVsgmhy8lqeG1hCuCp6OJ1Xfs6ykSVm3
	 mnr2YSiF61Y3owoWQ07AAlYRNKpvwLjxp00c6wEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/990] ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit
Date: Wed, 25 Nov 2026 15:28:21 +0100
Message-ID: <20261125143829.913664355@linuxfoundation.org>
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

[ Upstream commit a1eb72c477ec1320c540f27ce1e2f717d4518e62 ]

ata_scsi_mode_select_xlat() accepts the caching and control mode pages
both in page_0 format and in sub_page format with SUBPAGE CODE 00h.

However, SAT-2 and later versions of SAT define the SPF bit of the
Caching mode page and of the Control mode page as not changeable and
set to zero (see SAT-6, 10.4.9 and 10.4.6), and SPC-7 (6.12, MODE
SELECT(10) command) requires the device server to terminate a MODE
SELECT command with INVALID FIELD IN PARAMETER LIST if the application
client sets any field that is reported as not changeable to a value
other than its current value.

Reject a mode page with the SPF bit set to one and SUBPAGE CODE 00h,
with the FIELD POINTER set to the byte containing the SPF bit. The only
mode page with the SPF bit set to one that remains accepted is the ATA
Feature Control mode page (control mode page, sub-page f2h), for which
SAT-6 (12.3.4) requires the SPF bit to be set to one. The opposite case
does not need a check: a mode page in page_0 format always has subpage
code 00h, so it can never be the ATA Feature Control mode page.

This also allows the mode page handlers to rely on the format of their
mode page, which a later patch will make use of.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Link: https://lore.kernel.org/r/20261103205448.931471-13-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b761cfd435f84..ff944a80e35c0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4317,7 +4317,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		if (len < 4)
 			goto invalid_param_len;
 
+		/*
+		 * Mode pages with subpage code 00h use the page_0 format: SAT
+		 * defines the SPF bit of the Caching and Control mode pages,
+		 * for subpage code 00h, as not changeable and set to zero.
+		 */
 		spg = p[1];
+		if (!spg) {
+			fp = hdr_len + bd_len;
+			goto invalid_param;
+		}
+
 		pg_len = get_unaligned_be16(&p[2]);
 		p += 4;
 		len -= 4;
-- 
2.53.0



