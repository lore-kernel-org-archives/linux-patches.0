Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705239;
	b=FhXWdttPQGQNEWNZE2WDzxVbBSacU5xwRgUpELzdbQ6YUPZS1dbXblPgMv6aS6uGXCiY
	 eeOPVXx269gjFHNGUODxrjDtO2Yng3xO7noUDnkxUNLrOhd+NlIiufxTjmS0AesGZJLCj
	 sCYo+boMxyUYyFv+Eg7atTq7clIpRb1sr28+bi9VdxsS6nuw2wdLoPVI0AB4FbFsGSloL
	 GAbWvYiTAkmLyI9WlEQsOzfrpsCCCKyEG7UfhoajaS1P8eiueYGGb6JmkPGimyV2gPEmj
	 GPHJDCjW10G2a+So67UDNzviWjEZ5baRDliF9IgvigxWWvG8Jc13nSdZ17JbDEHHz2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CsX91LHYdXquntBEPyX8KeH2FpFYphvpJ6V55GWMVSY=;
	b=KjFLSfDBw+itXDliz9kOmFemNUCUj51zLiwjeUaxRF3NQ1y6R6fvaoz20KEqAcqUC4AZ
	 pAJK9ogGMOlcrXyhsoVz4zt+A5j8qL1XibtjY4BO7PFsF1taWBU56scTupFTsP/+8fdBY
	 3QuMnKvf9PcfRsiY+PgUuBzwUInpkGssqhhlTxUSbBAh3KoE/GzvzAOU8lR/Ajrcc51X4
	 4fgKFVsjuzaovDZCWYaY+urolvIsv0id6QpnQwHftBD+X5LghOebDRPz4K7iz/kISx4b8
	 u4nw3FEdRfIXnWjg57xkpFv3h+7FwCxvMkpaxN3qcXC116Lfa0OLWDF6u/lr9Vo3hIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EW6w9vPS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6CD606A31C;
	Thu, 26 Nov 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EW6w9vPS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1813C1F000C6;
	Thu, 26 Nov 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705238;
	bh=CsX91LHYdXquntBEPyX8KeH2FpFYphvpJ6V55GWMVSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EW6w9vPST61wikYbqaAuDe4dYnntCZ1Lcz+7+TW9yhXJkjemJ95UFgOfknWwjNUd4
	 P7v2QmP+zSxTlHNryojYAmi4KVVzqnVluu6vO4HC1uerNFvRklM9hKcGX6AGJwYxW7
	 LmEf0lNxx+5biGNEOLTzKlHuzKcaWY1nxX6zFBEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/319] ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit
Date: Thu, 26 Nov 2026 15:38:20 +0100
Message-ID: <20261126144009.725435985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f162a2bea70eb..282d92c6f767e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3779,7 +3779,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



