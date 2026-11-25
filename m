Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624803;
	b=XwTlx7kpZsVcWbI2a36iFSrIbG/xJp742fdGY9l1SRuk8svOFw4a01hn8ZxB2mgmaOpZ
	 i/ALQVDR750e1ECJ0XUkdvY9k6SVKtVhaL7aNJiRr/m4zyqMPQM1oSJhgDX6jRGh+p9ZB
	 ciO6ZchWex5ZV9914XYhyjudtEWS1Mk3n2NFkUkjWnhlUg2ehF6iQe0+k6q9cBrHObnC1
	 oSz/tI+rARFzeKdDpPOBMy5UuST1Gr5MxxI7h6U9kbFnkijTXb7jJ102fOWhXXJcGrSWB
	 3CmKhaHXXscngBtQNUF1DPcZraNdJU9Dzs7ra+OJ9cNyAgkmFm7bZ2LnGPe/I1gS6nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b/S+8zQmEEIirb1U9G6MsbuWFrTvryLT0UypFNuo+9I=;
	b=YCo9nNrNvdMgThN/4lMeMJXGgSujewTo5r6xkKCDci8fcito3eleCxyUYkjubp8Bf31n
	 W8EklYjliVdGdULyfrtUHHsv9Ut1myKq6K7fFW0EYINdPmFy5BkkmWs/xY4AimeExq+kn
	 kMm9BV7XJTP5iF7ZGjn8xtCP5TYQgqWvcRuSBJz404UAQy4t40sDr3U/ihpi5rVPpH70Q
	 4z3UaxfmxxGYXfCBSLeL26RIiBBA5sLdL6f5J6PP1opDBUTG/sj8Ao8ADkrNRUP4BlJ2B
	 Dl98mcT8sVMQ89mQHzJYk6XbiVgpfV7CEmc7vy0myL54vpI9TpBJ05Odneb1qh5riIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=auqg5qCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83996606A332;
	Wed, 25 Nov 2026 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=auqg5qCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BF61F000E6;
	Wed, 25 Nov 2026 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624803;
	bh=b/S+8zQmEEIirb1U9G6MsbuWFrTvryLT0UypFNuo+9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auqg5qCcLvTJg3ITTyGQjHi1gPM4Wpz37nhdQSW15zFOp/bNjS4GF7t/NCTpoXkqS
	 ynv1YmfRQt1wxIU9JVY0EKHEVnIeATrdUF7nQVzgcKoVnlmghjVkRIK/iloabp2bMx
	 M28ZbzYZnhfAp/GKxtNx2QQeyXNJ0zp8d6S1WYFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/816] ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit
Date: Wed, 25 Nov 2026 15:30:23 +0100
Message-ID: <20261125143855.576098581@linuxfoundation.org>
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
index 2f70f1c228945..442f45099f0da 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4329,7 +4329,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



