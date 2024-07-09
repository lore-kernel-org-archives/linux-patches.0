Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95119156F45;
	Tue,  9 Jul 2024 11:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523546; cv=none; b=E8O96azDdtbiqWAIVq3rBKpbQ6YwcuSX+nLkTnADAK0avY//ojlWxZXPI+D3jGR3SR722csUc/qtNYdkgfhAggT7I6SpcKK3OSNT42SUpaRyKTP9ftZ0nokz7ZCZGlppFLjKLvqUNeFK+DZ62xDncwX7FUgFkRQ7EphKYsH6RAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523546; c=relaxed/simple;
	bh=l0Y1qG9SmVpcziil998k3Ofr6K9AQn+Voj9HuQqAFKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pkl8q8rWShKrTtCueWZniAzRxrAbZhZvQWn+bJC2tjEYv+wHhZDpPFwpUtupt3hcZNA8HM2dA2XgU2o4Wf8yXEifubb91yNDtF5+LqkuppZaRG1+VXUw6efd0bYCCnpoujza1aDk84F1RGXyh+qMd5E+z2Cyl6LDnotn7qEmZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KugCHdcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KugCHdcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC91C3277B;
	Tue,  9 Jul 2024 11:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523546;
	bh=l0Y1qG9SmVpcziil998k3Ofr6K9AQn+Voj9HuQqAFKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KugCHdcxyZh9FdlrNzJs9DHW5NzKAeCv1k9xa3yBPsmKifm3wapLUHDYj10ld7a7o
	 7rZTrkub4gysOAveyWWBvTtan0nr/mSmXpcAyagxzxwcJyT0a9TWpK7lZDXQaLDCeW
	 yBUkp4v99etH/Ond6/E9kqM4O8bfZ/UkDOQG8KwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/139] firmware: dmi: Stop decoding on broken entry
Date: Tue,  9 Jul 2024 13:08:49 +0200
Message-ID: <20240709110659.290193039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 0ef11f604503b1862a21597436283f158114d77e ]

If a DMI table entry is shorter than 4 bytes, it is invalid. Due to
how DMI table parsing works, it is impossible to safely recover from
such an error, so we have to stop decoding the table.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Link: https://lore.kernel.org/linux-kernel/Zh2K3-HLXOesT_vZ@liuwe-devbox-debian-v2/T/
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi_scan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 015c95a825d31..ac2a5d2d47463 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -101,6 +101,17 @@ static void dmi_decode_table(u8 *buf,
 	       (data - buf + sizeof(struct dmi_header)) <= dmi_len) {
 		const struct dmi_header *dm = (const struct dmi_header *)data;
 
+		/*
+		 * If a short entry is found (less than 4 bytes), not only it
+		 * is invalid, but we cannot reliably locate the next entry.
+		 */
+		if (dm->length < sizeof(struct dmi_header)) {
+			pr_warn(FW_BUG
+				"Corrupted DMI table, offset %zd (only %d entries processed)\n",
+				data - buf, i);
+			break;
+		}
+
 		/*
 		 *  We want to know the total length (formatted area and
 		 *  strings) before decoding to make sure we won't run off the
-- 
2.43.0



