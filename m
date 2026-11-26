Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704404;
	b=S/dQs2/r2+Y/ZH7Mb5gmKTEiXImU/zTbRTAuQ25GVLOgyc4qNz9kj2PdShC30x4AqrE5
	 sYsTpeeroJL/VtAXL0rh6JmjEoCWBiq2H4tQ/lYKgUiFSHyy5TH1rZIYl7NbYMjai/Tbn
	 YQg+Kwc4A1UncI7OI4/Ndvt9DrEGHdQA5+Nwi5Raj1t1OlFRCu1mXHSDFo2piVTrqAJBw
	 jON4MB6HvLjGtExKwuH7EI1jIZDs+I85r7TED6CLJkhCaBpa5Wu77k7gzWApcqHtW7Djn
	 bwBEtUS0IzhB9cqIcUlRIZ59hOnkP4r3uJdGGocBO5EhZtc3p6mk7RNPvhXYezcknMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QHIv2Q+Q3J3QwoboY8MNwNEl6zBJSRKyIrwYN+N8Gso=;
	b=kuXMWj81jh2LSJNV+Vy7TrzEDA781uYVFTuH0En36UN7Un9gSo9DMfVoZx1FjI3Ui+hu
	 46M/yznQNN75abUBsuBra4HWyqSOwbJYxl7GyN79noVXsByn1AlSacrIIcPNO1sX2YtJt
	 f5V7KIymdRk87NVugQYuSG8H/L+3kLYJIRPkofdx5g2iV540iwomiB0Q56xVYK36C20ur
	 kri7W904LkAiigpoy8Yr9qdFlK84QU10K/Ol2b4Na4i+NYgNcfE91iiEoBx/a3ICfq+LX
	 Thu2bjFik+ujXGSZY2bilv3KItMRwxOQvxOSpvhez6eekJ5sEqwlJtIZm4gUIGrmpxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L95O4Uz0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0E2606A31C;
	Thu, 26 Nov 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L95O4Uz0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308251F000D2;
	Thu, 26 Nov 2026 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704404;
	bh=QHIv2Q+Q3J3QwoboY8MNwNEl6zBJSRKyIrwYN+N8Gso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L95O4Uz02WjBw7ZNEHsUFwwTV6Me9cXdZWwIZo+vFzb+F04YcMiUjx2Z5IJRJHAlH
	 Ydy4GAQNeMGgksC6yhKRqwscN35uYMu13uFMApCAyrzInc9QwfYWImPR+u6uWfT74K
	 qgyigHvTPCbypPxD4zsKlqjAxI3eKjqOJCBw0kjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/265] ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit
Date: Thu, 26 Nov 2026 15:37:23 +0100
Message-ID: <20261126143612.938594296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a310f665c4a54..4112017105d7a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3825,7 +3825,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



