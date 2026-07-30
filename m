Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710B12D7393;
	Thu, 30 Jul 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423439; cv=none; b=mHvktLvIedWozJEWKdD+yh7MpnYg9Jz/0Namhi4tKByVFuL18VsmubGhkROTOnaii9I0ctQFTX2LjEA3kMfPpvaVTvXY519zviqF1d2mwoge26aDLE2NZlTQcG0aoUOIiAgkesOitAUDr6I8jyGBSMwpGue845BrDJ7rzsbiq7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423439; c=relaxed/simple;
	bh=CZokdSuSInQPNeojiMb8iu62XoxMhCkHHdSyD5UeeeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtfdKayXg6mzQIip7KE3QvjLiHlgqppnx56yo+9nfIvv+rIH44v96A5BSHqgTqFHGgsnJw5435DExbLqBnqSWXuIQeRyj21ArRdmRZfZslOtwqFfl3hS8k4dggYxgPU1nKQFVhCmL0a6L2tssPQsPU75JLB5DGz1xlNeWAj8Dlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPLL/2nq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPLL/2nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C826A1F000E9;
	Thu, 30 Jul 2026 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423438;
	bh=B2LZq7U3boS85un9BzteQJKhLK+JK2TiZVnAAxMqD3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPLL/2nqrnMB4yVgd9L5cwuW88u2zN8BLB9J4iJd7CvOWkP1DdsU1CSO44WRV85YV
	 FfcmZIuEuFKNS4DUh/fYpvaGaZwgtBZxs6E94SQ2JjH4EMpvFImCCtoSETERWDSAD+
	 RA1TVZtrqrM+41jVyQamwTI1GGl7gqGbekLmlu7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/675] firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()
Date: Thu, 30 Jul 2026 16:06:15 +0200
Message-ID: <20260730141446.079144059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>

[ Upstream commit 8ae5f8e4836667fcaffdf2e3c6068b0a8b364dd8 ]

ffa_partition_info_get() passes uuid_str directly to uuid_parse()
without a NULL check. When a caller passes NULL, uuid_parse() ->
__uuid_parse() -> uuid_is_valid() dereferences the pointer, causing
a kernel panic:

  |  Unable to handle kernel NULL pointer dereference at virtual address
  |  0000000000000040
  |  pc : uuid_parse+0x40/0xac
  |  lr : ffa_partition_info_get+0x1c/0x94 [arm_ffa]

Add a NULL guard before uuid_parse() so a NULL argument returns
-ENODEV instead of crashing. Callers are expected to always supply
a valid partition UUID, so NULL is not a supported input.

Fixes: d0c0bce83122 ("firmware: arm_ffa: Setup in-kernel users of FFA partitions")
Signed-off-by: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
Link: https://patch.msgid.link/20260617-ffa_partition_nullptr_fix-v2-1-bc801b4ce34c@oss.qualcomm.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index c76eabb8436a85..feded15bb5e921 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1133,7 +1133,7 @@ static int ffa_partition_info_get(const char *uuid_str,
 	uuid_t uuid;
 	struct ffa_partition_info *pbuf;
 
-	if (uuid_parse(uuid_str, &uuid)) {
+	if (!uuid_str || uuid_parse(uuid_str, &uuid)) {
 		pr_err("invalid uuid (%s)\n", uuid_str);
 		return -ENODEV;
 	}
-- 
2.53.0



