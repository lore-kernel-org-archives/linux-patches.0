Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810492F617C;
	Sat, 12 Sep 2026 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229556; cv=none; b=WQyUkg2m0rq+CmGBvTXTGRU/5H3E6rbngEt6rtXoWWn379VupgndvnvsfySNBKJ0bSflgcmz5ow6e0h3HNH5h+qFQx8mxrWealxSi7JMPloJ8kGTot0KEuK3Q9NtVAKqTiA19QsOwY0Z8LkAUKhcmxgB5lx5HsrtcYn6evJXvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229556; c=relaxed/simple;
	bh=2y/HXKA6sGugAEvrY8qMZXThubopYINoo7mi9N2i/bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krpAUK0jokalqeYK6QJLHqeiv0D08dNXJZpBiAQHrBb0kuUMIaxhS/Wd1UsXzVu+rAqAggNBBkl8XPnwAYMt5JBEm0BTNPvlamKY1TAqA5mriDaWzl2XzpTHYSEv6gLRmohMg49GwLRs9HC1t3xZpY97hqbHQjmctUJOV92Vndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j715d8cP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j715d8cP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F6E1F000FF;
	Sat, 12 Sep 2026 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229555;
	bh=LCprIP4LgVvNdL7k4Bih55kXH2D7Ma4CH/OOzWZsxVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j715d8cPO92iCDHob5kBCtypmSLWxAFJEOOKtPz48u8kPqSFHo2wpKd9nIYIAUW6a
	 XQ3KzIVVTiyKw9B9l4znZlF30aFU/drqHoQ0gFE9/5kIFu4596Iqw+1ZlC++f+yIN1
	 8KKfzDcmpNZnZpNz/krjAOG/4gIXSxLlnipSIzeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0615/1191] libnvdimm/labels: Bound the on-media label size before the shift
Date: Sat, 12 Sep 2026 08:55:43 +0200
Message-ID: <20260912065602.065366864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



