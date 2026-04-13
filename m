Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C8832B9BB;
	Mon, 13 Apr 2026 16:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099494; cv=none; b=EVi5E7GjqLBDFpU58o8r1REXNzyy1/3l4+lmeNsHCgC//D3ALa3OXhYDa88Z7M5aHVwunfj/Q5OxGIDsaz3etJ+NFYVX+OnCUPR2TF/PdduYPHoxVJmf1dRellaGBaxhbgKWuGyhZA/qxCC4UX/YbhNrl7mJ5wk+a4In7rwPvYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099494; c=relaxed/simple;
	bh=R9w8mOPTFGdP59EJioWGqiMOzkLlBBnWxsD9VZPzrZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiR99MxeeT64aWkar1Hlfxf0m92hhsPvgkVO+Z6z8ODPH1OPDtFDjaiX4rrwiAjIC61Nsq4Rfi2/hhcQFaN+wcpilF3ALUOO5D70PJJBCJ9jTsnNxL1tnWMtaT+A5DoiAXKVzyd+mHx56taA/L+PAomYtzglR42ZfM3OElIOWkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ug+yZwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ug+yZwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C696C2BCAF;
	Mon, 13 Apr 2026 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099493;
	bh=R9w8mOPTFGdP59EJioWGqiMOzkLlBBnWxsD9VZPzrZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ug+yZwRO+AZX7BM54rLA1v0rLqte8bHx/PxVs67cazUb+0sapBfb62Dslq66F13e
	 VxVI90syJbHIeXnC7tKEalGHpgcsbU9rcagQgDdfTZGmPlbHgQYrZpRitkCg0Yf0sI
	 CyLd54aeNd6Bf1gXV5nuKkr1q5xrwA52HCeAwhOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/491] hwmon: (occ) Fix missing newline in occ_show_extended()
Date: Mon, 13 Apr 2026 18:00:07 +0200
Message-ID: <20260413155832.589389626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit 09773978879ecf71a7990fe9a28ce4eb92bce645 ]

In occ_show_extended() case 0, when the EXTN_FLAG_SENSOR_ID flag
is set, the sysfs_emit format string "%u" is missing the trailing
newline that the sysfs ABI expects. The else branch correctly uses
"%4phN\n", and all other show functions in this file include the
trailing newline.

Add the missing "\n" for consistency and correct sysfs output.

Fixes: c10e753d43eb ("hwmon (occ): Add sensor types and versions")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260326224510.294619-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 1a6c8ebc32e16..2b088418259b0 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -727,7 +727,7 @@ static ssize_t occ_show_extended(struct device *dev,
 	switch (sattr->nr) {
 	case 0:
 		if (extn->flags & EXTN_FLAG_SENSOR_ID) {
-			rc = sysfs_emit(buf, "%u",
+			rc = sysfs_emit(buf, "%u\n",
 					get_unaligned_be32(&extn->sensor_id));
 		} else {
 			rc = sysfs_emit(buf, "%02x%02x%02x%02x\n",
-- 
2.53.0



