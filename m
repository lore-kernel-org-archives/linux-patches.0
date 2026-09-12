Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993DA79DA;
	Sat, 12 Sep 2026 08:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201736; cv=none; b=AwdTk5T2T6v9499VEedd6EG3/cHmzCSlQ3X++EF58DqEkUNc2z6ufvsqcsvyX8UMvKWST1/CjWFiZvKjGSM5AENF/hqk/hPHM5pt7yTClA07PesNW4JUjlDY61ykjLbMGZwlq2dxA5oLOcWL9Q0Dmo3OAbbfdrUI6F039x7gS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201736; c=relaxed/simple;
	bh=PJmZ7PD7HH/CIEcUzeKIT06QSy3f0NNHK6sYAFQAUis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdb2mvF9Z30PNLi3N9PQluOQC3mFNuxY/MGmyDQz0UV2+MeKSlVr3Z0vUIUQ8Rf613NXgYjEbLV58jnwgjJwyEe3LmaNMldEH0NtWakEeiWGYP4EvL2VMLcfuSjk2r+78iEPLIBL8mZeNU214bzVlagYebdP8NThApzYqXnmnB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kz/mGJ5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kz/mGJ5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5474B1F000FF;
	Sat, 12 Sep 2026 08:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201735;
	bh=NhD69Ca74GhwS8QuuUFdWLS0i8TPRcB3kJgHV2z1674=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kz/mGJ5+AqeQfkdnJcQ/mi4GBC5kwdjE+FjK81sQFWFSGk0sG1QGz9Ss8D2sOSo3U
	 mOT8r/GT1eUnrHB/NYUv3MAWzpZRQrOOvqvbEAjsV5KsXfZcqBw0VCdeK1VfnJPmvD
	 hPbnPhE1fdSO1Lc1mTfEZTG/CrlEGGkOlnPJXrdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1058/1815] remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()
Date: Sat, 12 Sep 2026 08:46:48 +0200
Message-ID: <20260912065713.854202490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit bb840ea69347aff7bde5a208e7b5b180669a7656 ]

table->offset[i] is a u32 from firmware, but was stored into a signed
int.  A crafted offset like 0xFFFFFFF0 becomes -16, placing hdr 16 bytes
before the table buffer.  The subsequent avail check was bypassed
because the negative int was promoted to a large size_t in the
expression "table_sz - offset - sizeof(*hdr)", yielding a large positive
avail and letting the out-of-bounds hdr->type read proceed undetected.

Store the offset as u32 and validate it with unsigned comparisons before
any pointer arithmetic.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Fixes: fd2c15ec1dd3 ("remoteproc: resource table overhaul")
Link: https://lore.kernel.org/r/20260803114331.3277263-6-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rsc_table.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/rsc_table.h b/include/linux/rsc_table.h
index c6d6d553d8f11..4cef11a2e3a2c 100644
--- a/include/linux/rsc_table.h
+++ b/include/linux/rsc_table.h
@@ -337,17 +337,22 @@ static inline int rsc_table_for_each_entry(struct resource_table *table,
 	int i, ret;
 
 	for (i = 0; i < table->num; i++) {
-		int offset = table->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)table + offset;
-		int avail = table_sz - offset - sizeof(*hdr);
-		int rsc_offset = offset + sizeof(*hdr);
-		void *rsc = (void *)hdr + sizeof(*hdr);
+		u32 offset = table->offset[i];
+		struct fw_rsc_hdr *hdr;
+		int avail, rsc_offset;
+		void *rsc;
 
-		if (avail < 0) {
+		if (offset < sizeof(*table) || offset >= table_sz ||
+		    table_sz - offset < sizeof(*hdr)) {
 			dev_err(dev, "rsc table is truncated\n");
 			return -EINVAL;
 		}
 
+		hdr = (void *)table + offset;
+		avail = table_sz - offset - sizeof(*hdr);
+		rsc_offset = offset + sizeof(*hdr);
+		rsc = (void *)hdr + sizeof(*hdr);
+
 		ret = cb(hdr->type, rsc, rsc_offset, avail, data);
 		if (ret)
 			return ret;
-- 
2.53.0



