Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697621DDCE;
	Tue, 16 Jul 2024 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145959; cv=none; b=fwXs/nnvcDO7sEkKMGQ6NYVTtGX/Ho4Uz9JTwGvZokNQ4kLU03eN9uMydtUjHknpVSZAAkFYOn7C3xXh+SSwLzkSHJNsCtaZuDivNzRhtViq3N89qpBiZol1K/xHcyqIZgykAOvYN6+QBthxVOmRzUaz955B3hxbKRWN1ZmSifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145959; c=relaxed/simple;
	bh=N7dD9odQIBbPIs8tPo0JYGoi3yx00akJIaAQKDD8j8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNKJgvmW+BIxj/hH6QNCggzu25yNdXPS3r9gbo6GrOBzalMeSwTy6xl4Ckyv8Y7kgr/S7Tpx/9qpxzL8sXYAhHN+V0gZ3328WXilueX/lqbLxL4t7p7DBgUI2Hpa6zVhfizSnL6ZJ0XIXfXG+XPb3m1xV1dstmXmNBSLZruGpFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJaF72Bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJaF72Bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A44C116B1;
	Tue, 16 Jul 2024 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145959;
	bh=N7dD9odQIBbPIs8tPo0JYGoi3yx00akJIaAQKDD8j8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJaF72BiI76pGvE63GDkS5r6vYnP9efdy2jd1nyrumMk9bklKcMozqWKWwA8qf49z
	 c0azwqPgcofGRwP/6L9bpUcnQqw8XWb+XRY6lY+0wzx1JTFdCssXu2rYSgf0zjDwAd
	 1vY3sGdk9VC6GM6wXwCL68Q9SG2mDO/2WmXYDJ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/144] firmware: dmi: Stop decoding on broken entry
Date: Tue, 16 Jul 2024 17:31:23 +0200
Message-ID: <20240716152753.081386692@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f191a1f901ac7..dcfddde767d1a 100644
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



