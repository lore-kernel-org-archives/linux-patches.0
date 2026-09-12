Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620CD4519B5;
	Sat, 12 Sep 2026 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209925; cv=none; b=c5/KEFthGjLTMsbFzVQmnLZ4NFMHPrCiF6aJMm24ZGvzjjOpqy/YUelNTSApfmkae0K1pBXnuRpBMxKNQ0FTkK2ABTUQqRXFJ9PTLXvxwyaeJblOdHBmYPPUeiBFIUCTHRQ8vsEB1Xrxjzusij/pTRcrDl04D/CXeo+AQhGhzic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209925; c=relaxed/simple;
	bh=X5jQwwa6e8akobe89s9aJv9VkT8fDS6Vhy2GOFEH2Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSUyAqAxFWRkrfIi/cHaXRdT2jMjSPQM3AiQ8IxvNU6aAAYRq0u8jeCJ5Y8Fq8xfoBZzGNe0RCCvL+fCCXBk2Bv7q8dEoGaxh2xAIMlV6rvyf5oqezUQ/Qr9PBNXdELq+VVHk5PI6pJgdFsqEIBDTNlYioiK2XvsONtfa9bC0wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kR/UD/r4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kR/UD/r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5261F000FF;
	Sat, 12 Sep 2026 10:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209924;
	bh=VMI+gXJhfA0tR2T6P5l6HJw9UYHwRVXyG0Bn+6IhWfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kR/UD/r4FlP9VsmnJadp+5MAHdMyFx29MDslvXEKi5Szz5GsuxWi5BcFU4SX7FwjP
	 +jeguoPYduxY4CZJHbQa8zXFbsJkhigO50FPQ+ky6nmSaHw/eZIHlg5y0gzXocpQ3b
	 F5Vc2jjlykLFs7lOZZ8BIIRyWe/rJzMq5/NKkp/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0879/1518] remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()
Date: Sat, 12 Sep 2026 08:50:48 +0200
Message-ID: <20260912065643.333475797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



