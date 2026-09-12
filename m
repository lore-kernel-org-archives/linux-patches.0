Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A12F90C5;
	Sat, 12 Sep 2026 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238730; cv=none; b=mP0hmKVdmSg4PGjLiWmgqzp5jEdCssh0DJ5D8qeWa6aI82HcVjNd4WbfcV6UvFOGIowyEo1q9OYQJFhPtRG5eQQZxqDmAoJE6EEHlgmVcgBjFM2zT2zoJPbGWLk8YjJyxDNn6Jlek1efHVAaczD1/264BPS+yegaIj6CDsmwy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238730; c=relaxed/simple;
	bh=cPzKJ7qBipscs/+IPfY+9MniIfxPqH5CdPAHxOocT9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkzhlcJA81w8ljxgPLcrdqUhFFrtdJOECcSl5jW0kPLyzqLzuoic9RUJrm58l7W1Chj+NpEkqeahhxqN+H3xYvQQsA2KW4vVqaodNz2BRnk1VTl2ui6VAQBAj0iROw8N4LezoPonIxCrKk+XFisJSuNDd4dK39Fj3gy5yZHNMBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhODlos+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhODlos+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160991F000FF;
	Sat, 12 Sep 2026 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238729;
	bh=Hdkjw4APRS507gIDJQcD4wjsAaJ2T9XaBD9FlTA//vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhODlos+SIaKrj0Kd7AmNe3Db/jmC5OVd1JyUH6e1v2csLvjjpM0tc6R5Alks+965
	 vtz5JWUVOLcD+fhyeX4C8byi9TPW7cRKFnlqOBH1k2tLQeiWZeeheOqwoMd0HecBCs
	 6hUFIdbtaQXh29nDohb70Hrnc6ITM0GKHzJ8BisA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 520/935] libnvdimm/labels: Bound the on-media label size before the shift
Date: Sat, 12 Sep 2026 08:59:10 +0200
Message-ID: <20260912065538.751394139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 148d45f570257..6c591fb03c066 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -137,10 +137,21 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
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



