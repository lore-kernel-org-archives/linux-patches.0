Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D677C3B102F;
	Wed, 23 Sep 2026 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172740; cv=none; b=YJ9PGl8Bpsf41GyfhgAhgTBe3mkAK2m/zkGrvYuHDNgDHwwoVlwt0C8Sr0HaUiVHBp2M1AEabXz6Ge8LMrW732NuDhl+myA5JbpyOpy3xLZVz9yevAnbjQCRB51KAMEqlKPRnV8hNdR7sVcPqEoOXjQ4Qbj5SgiaHBwBRXU/n/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172740; c=relaxed/simple;
	bh=zM0Um1iSFIKRflTiIcOqoHd63G56HqWB40hiT1UqPhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GttsqUdUOk4i4MOZlF/hH6pEM2Yrn2Hop1UwsDQWBZj6J6d+tRfoNaCPImWUkKykVlscHGR2szcoC+LjVEIKOP1H14xD3PxXS0CZGKr+B5QNSea8T/hP6D+ezTeIItPtD5ZNwIqmVVEBJtwYuD6qxuAjhngTWCm7aHjWN5noEFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPDjq1tv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPDjq1tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173291F000FF;
	Wed, 23 Sep 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172738;
	bh=uWBzQzNA9CqJU3QCov/7Z3HnrNZJajNhmccZkx3zdXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPDjq1tvuoF3fonRFIdLgcbfkrrskUnQTPJHSYEtzz6OE/+we8QYMDYuDD0Q9hDyZ
	 vpwgOWdRb7jHwNvkxv5WJ+VQr7lWdvEe497AA4Sa4IxIobBGUylO5H8VruWgMHmpP2
	 cE1rEmP5KeuU8UYxvJVzMH+Q5rzcopXk/Gkqn92k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 021/438] firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS
Date: Wed, 23 Sep 2026 16:00:42 +0200
Message-ID: <20260923140645.325342958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 32471d84a487c7fd74532bc96be56f8028cf4a3f ]

scpi_dvfs_get_info() already rejected a zero opp_count, but still trusted
any larger value from the SCP firmware. The shared-memory reply only holds
MAX_DVFS_OPPS entries in buf.opps[]; a bigger count over-reads that array
and then sizes the allocated OPP table incorrectly (garbage OPPs / OOB).
The missing upper bound dates back to the original SCPI DVFS support.

Reject zero and out-of-range counts in one check and return -EINVAL.

Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/022802f0b38f.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 2acad5fa5a286..6eeb0ad9b0085 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -631,8 +631,8 @@ static struct scpi_dvfs_info *scpi_dvfs_get_info(u8 domain)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!buf.opp_count)
-		return ERR_PTR(-ENOENT);
+	if (!buf.opp_count || buf.opp_count > MAX_DVFS_OPPS)
+		return ERR_PTR(-EINVAL);
 
 	info = kmalloc_obj(*info);
 	if (!info)
-- 
2.53.0



