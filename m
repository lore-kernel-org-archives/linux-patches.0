Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C44F9E8;
	Tue, 16 Jul 2024 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144497; cv=none; b=WIgdjKj4ogQ7jYNrMbNUaAeYG0apkv+oJ9v0lmSN06boFljxqzGTymyQPBVdnI/uQGmK1BCX9V1E2uBtxTxsSH0mztIOmCg9hrUDSJR8LJKdDOykFD39t5Lz/G7cYgmh5BHzunUkvELQxh4C8kqFn5AtZgnU16a0bn/WSWGTPW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144497; c=relaxed/simple;
	bh=3a/wjMmpDvWAaO+mK4g1NLWdiLYM74bo19K3E05q8oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkwpRbiTiVsZP8RMQEOkSv62CLynFFNoJRsgBIuwAm4hpQu5Z2865X0BdoYBJN+NkGMv95jHFmn6J8Y8oQVsxXUgoO9ltnlMtgCBppCekVPP/t+kX0rFh9S1imElL9fGG7va/J5Tw4g4nTSZn8ikp60YgSgXdQcn9lLPvL1I6yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7w6lLHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7w6lLHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A376DC116B1;
	Tue, 16 Jul 2024 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144497;
	bh=3a/wjMmpDvWAaO+mK4g1NLWdiLYM74bo19K3E05q8oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7w6lLHs+K1QB6rHQBkMgEqFy9I0OTFhIvozpEx4FSWbGc/FG/rVuiXQ5r0JZI2lN
	 xvbOSOgPY+qKxoOFPVCAXVpc7ggQlRyVaL2b8FXy77XlE9bmitmcQS9OFdYebLJ3py
	 qdEk8AbCXyqiwIKB1IfpfpyFbAQihc/3OMTJ6iI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/108] firmware: dmi: Stop decoding on broken entry
Date: Tue, 16 Jul 2024 17:30:28 +0200
Message-ID: <20240716152746.507933799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d51ca0428bb82..ded0878dc3b63 100644
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



