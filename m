Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63E038DC46;
	Thu, 30 Jul 2026 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427211; cv=none; b=Mb/vOWwxNPF96agItKPCYTBxvrJGeAh9arL7J8rOf6vaTeYOBqKjt0rCKueUhjukf83z122Vo5VCPdgM3u87yAz5OZkFT05aK/lI4jAgHKiiZpP7ZkIdchjLPPuOn9E+wcJ6I04+VHPWrRVJ6KyNhXJF53P7IYVthR2YoJoTcbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427211; c=relaxed/simple;
	bh=DMQUCD2z0mHX8i4+V5tlmi+SCEASQjv0LgSrHm4aebw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqP+M1FgQ1UIHGxCbvnLAeMH+ifucTNq+4sf78ZChKBOHWQAj8cjLbktZf3DxMuXqljDg0nV//8X+QMGNBxQCWhn/TaRBKT5Oul7+xIxakMRKLWQ+WINHa6Rmf6yf0rKOs/MvVK13eroImw1+bs/tdTYSs9s62B2YAizyTBuJFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Onm5vDRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Onm5vDRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAFB1F000E9;
	Thu, 30 Jul 2026 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427209;
	bh=VNIM0QDIFx599BMuF1W5DRpMJHBZf8Ewbooqlb0DLnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Onm5vDRJuYXlLcLqpCCLErg9mODhELYROQ6rW6V9Ib/mYU035RJHXpW638AlfsgK2
	 vz5jb1IE6GhI3DT78TV0Zj9PiK2D6qEMYhV4flRe/2QJ277vNubF4RLd4PSD5JjDDG
	 MFZ6x8WZ4QL1ce1RBj/eLmTbwlvUXXxCHdot4GA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/484] firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()
Date: Thu, 30 Jul 2026 16:08:52 +0200
Message-ID: <20260730141424.187482836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ece91d8d820b51..2309a31549e25a 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -582,7 +582,7 @@ static int ffa_partition_info_get(const char *uuid_str,
 	uuid_t uuid;
 	struct ffa_partition_info *pbuf;
 
-	if (uuid_parse(uuid_str, &uuid)) {
+	if (!uuid_str || uuid_parse(uuid_str, &uuid)) {
 		pr_err("invalid uuid (%s)\n", uuid_str);
 		return -ENODEV;
 	}
-- 
2.53.0



