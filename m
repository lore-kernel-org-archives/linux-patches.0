Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3D919E7F7;
	Sat, 12 Sep 2026 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198453; cv=none; b=WsLePIoqK16FpgVU82+ujouFMJ4TUBmg4j3GirVbx7aYs1cFVdb/KRvEfL37T733Zqp0nQ3aDFPXa2KalfJglPCTi7v72IpLHsZlS7Cv1s+c8aDjE4GdUEhtuK3VqAn+BzohfnUgNNfuK3+xF52zOYVlfXv9rkaQ0Rsj5rfnT3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198453; c=relaxed/simple;
	bh=4O85kKFoyzKjhPeNsaB3M7oG5Bn0L9/7MZRpzPhssvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Anq1N7N5YA5FZLUVqpiTygzHpnsTj3KkOrprZYJfGXmD64O0uiXiIRRv6pkf+qBjI3QpK9Z9qtNRs1maZkbvddoS6bEY5SR2BDEdi0wYwbBw+xFej6K2wc8gxjDRhN4osq/pwXEdJSduuW9O3+bPQEpJdGUBaaOdw4ed6BGiMgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUnJ87RV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUnJ87RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3837F1F000FF;
	Sat, 12 Sep 2026 07:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198451;
	bh=16reotddz+1hj30wWNnL8QfsHQqAAqZfVBPJjvTLgbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUnJ87RVyN+eiicTwjGIZgjZvpc7OdiUPUtL+CCMVG5OB9vYnpbmb4dDBBDbuP+tz
	 ab1vKmmBoS4KMY6U+809lzK2y1CNl3MBIdUkD0h5p11ZdGiuROU3dCbukZe/jv7Sr5
	 ggUENvEFAwbjFo1vy0CiZRtMM+lpmfTF39cVxVXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0383/1815] cxl/mbox: Break poison list loop on an empty payload
Date: Sat, 12 Sep 2026 08:35:33 +0200
Message-ID: <20260912065657.888258142@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 8b301c4afbce4bc3f94528441d8d5ce1366504ad ]

A device that returns count == 0 with CXL_POISON_FLAG_MORE set on every
iteration never advances nr_records, so the max_errors guard never
trips and the do/while loops forever while holding poison.mutex. That
hangs the sysfs-triggered scan thread and blocks all subsequent poison
operations on the device. The existing "Protect against an uncleared
_FLAG_MORE" guard was intended to bound a misbehaving device but does
not cover the count == 0 case.

Stop the loop on an empty payload so a malfunctioning or malicious
device cannot wedge the poison scan.

Link: https://sashiko.dev/#/patchset/20260702090849.47501-1-icheng@nvidia.com?part=3
Fixes: ed83f7ca398b ("cxl/mbox: Add GET_POISON_LIST mailbox command")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260709155714.1893280-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 94b1f71675882..241526bb9e806 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1450,6 +1450,11 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 		if (rc)
 			break;
 
+		if (!le16_to_cpu(po->count)) {
+			dev_dbg(&cxlmd->dev, "Poison empty payload!\n");
+			break;
+		}
+
 		for (int i = 0; i < le16_to_cpu(po->count); i++)
 			trace_cxl_poison(cxlmd, cxlr, &po->record[i],
 					 po->flags, po->overflow_ts,
-- 
2.53.0



