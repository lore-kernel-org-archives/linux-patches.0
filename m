Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CECA2E06E4;
	Sat, 12 Sep 2026 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215508; cv=none; b=atxYmgQqbl8xkul2iLIHbp0uVQxRSKMKOhw4FHupbQ8LY710AyWccmm3iDjPCIxChxfXtFK2c9hKYqPagyTYSXROctOmTr6LL8oReevuJisMRSapa1CzqRi8XBA49ArBK8BFVcG8liBWY02lKxz15kxuDFYmaEUWgZTDzmzgKiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215508; c=relaxed/simple;
	bh=rKuBBKITGivx3patbk69DxXdfEuf3cR8RX5CmTCeIgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGYKHinLOK4kCRNXvldIehpRO5y13U9RTtOhovbYzM+KNPzFxNvQfPSEIjlbDA4exg+MYKVpqO1ZwlrO/0Oa7u3ZjUCz9gtrUoWWxyy563gbli44mPYrhq+8fZ+h7tySpwJau9Ntb5KFPE8lpAgzXcyp2e3/VMFjUFoxbRP/f4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkpYMxHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkpYMxHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5EC1F000FF;
	Sat, 12 Sep 2026 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215507;
	bh=GW0pGQUIxp5stkf0FDXJkGa4kty+SVywqyTiq4qj/3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkpYMxHOcvy+rbwdourDN1ZsSJayfhvKg44EAT/03421b1liAAMIdP9IMLiDNaTyt
	 M7uMye9Ht1wi7dt57N+GtDPM9mMNbGbBrKn92pIU0Tkk/gzk41q3Gmqsa7iH7C22Tb
	 LMjr3Leu3eeYdgupzsdByeo0r4IsvP566DgEKvW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0545/1376] libnvdimm/labels: Bound the on-media label size before the shift
Date: Sat, 12 Sep 2026 08:49:31 +0200
Message-ID: <20260912065619.686823752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 18f9124248ed7a9da1c31973b629dceef76a9b0c ]

For a v1.2+ index, __nd_label_validate() computes the label size as
1 << (7 + nsindex[i]->labelsize), where labelsize is a u8 read from
the label storage medium.  A value of 25 or more makes the shift count
reach or exceed the width of int -- undefined behavior -- and 24 already
shifts into the sign bit.  Only 0 (128-byte) and 1 (256-byte) are valid.

Reject a labelsize above 1 before the shift.  The result was rejected by
the following size comparison anyway, so this only removes the undefined
shift on a crafted or corrupted medium; conforming labels are unaffected.

Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260624-b4-disp-d8279485-v3-2-cdb6cab28b41@proton.me
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/label.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 584a9c27ce4bf..93ff219d91fc5 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -145,10 +145,21 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 		/* label sizes larger than 128 arrived with v1.2 */
 		version = __le16_to_cpu(nsindex[i]->major) * 100
 			+ __le16_to_cpu(nsindex[i]->minor);
-		if (version >= 102)
+		if (version >= 102) {
+			/*
+			 * labelsize feeds the shift below; only 0 (128-byte)
+			 * and 1 (256-byte) are valid -- a larger value would
+			 * overflow or exceed the width of int.
+			 */
+			if (nsindex[i]->labelsize > 1) {
+				dev_dbg(dev, "nsindex%d labelsize: %d invalid\n",
+					i, nsindex[i]->labelsize);
+				continue;
+			}
 			labelsize = 1 << (7 + nsindex[i]->labelsize);
-		else
+		} else {
 			labelsize = 128;
+		}
 
 		if (labelsize != sizeof_namespace_label(ndd)) {
 			dev_dbg(dev, "nsindex%d labelsize %d invalid\n",
-- 
2.53.0



