Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8BECA40;
	Tue, 16 Jul 2024 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144251; cv=none; b=CfH3p2Nh7Gutg+XkiRJEF6yUcGrZWJFs3a6bniNpUp2R6x7LSP4SmCqDTCIemSQM2WNxvdZVjssW6i0lhVvCyqOtWlkITsOZxnUabIEVC/+TSH5E/A0LxtgvpTZ3gC6jLTeqU6GkfDjqznEWLozyUj5Xf3yXUkzbZ0yWeXzXpeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144251; c=relaxed/simple;
	bh=Qlcqy8uMCuay0AuwUCJ/WRwM6tFcIwNXPToXJDUkcBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r091jFRcwUV0T7/TuHgHBXoqAtnnOVDR8aI5+wx/55MmRGtI2oPXd4jcybdgwM023ylO6VamGtxRc6KzIhqslSk1C4GdzgILTQwtIzGgTVNHGTsqS/H+pXFVXt/LxjRO5hDqOnb6FQ6bOXu3T5qqH18mNNVSt+bjmTqATcjAtTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYJhIdku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYJhIdku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D653C116B1;
	Tue, 16 Jul 2024 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144250;
	bh=Qlcqy8uMCuay0AuwUCJ/WRwM6tFcIwNXPToXJDUkcBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYJhIdkuum5fHNFVVNPVziV0J7+TubqsXhqvaG/xfQSeOJoOWYAmRziFPo6s2s0fE
	 A7Aw/U0Pj4kTBiKy7YtaocV9Pb5WtdoXz2/bVU92KeQL6SsVC9nSF34mbXsPBaTZcb
	 R2kOH0SoC7euJFg7ujhOnLol+tC9dxqMS4Iy23Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/78] firmware: dmi: Stop decoding on broken entry
Date: Tue, 16 Jul 2024 17:30:42 +0200
Message-ID: <20240716152741.025105779@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1e21fc3e9851a..537c104652f71 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -96,6 +96,17 @@ static void dmi_decode_table(u8 *buf,
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



