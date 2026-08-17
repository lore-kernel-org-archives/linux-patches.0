Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F222854781;
	Mon, 17 Aug 2026 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976587; cv=none; b=H1w+CShB509suSKosBEiojZH5TT4ZFn7p9PPISOSNpc5IOsrvb9JNOCWuWbis4xV2cu8WK2YtlIENw2UJAJlLD8HhaHjWGs5jr/SILXoFVQXLj2W5Rp6myn21uQHvjkBNNRGV9s6ui0c67Np4LySJPTgAwGOoZZBiAj92KiMh1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976587; c=relaxed/simple;
	bh=dijKwbzxefpNP4PdL5edZhPKmeBb9CkLBKSmYoEKBIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWB4ScwtjwvRs4JJiHH3d1s/15TVY3OgoU6S15ylJYyQd4zDQ3f4VKLI/9gNnweGh70EFr0bXiDfiawdRZ+erFRW9Re7YCUyLsCWrSYDue5Kifa9y4BPLy0adJfpuSmlsf+a4yE322dHI80x27UyNBpo1nuYTng1wGwJPyY5d3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc3Pa5dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc3Pa5dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B101F000E9;
	Mon, 17 Aug 2026 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976585;
	bh=f5dqx7l4w1ULDOxtUMRe8tNQ4IjOPu5m7xlLsBJp8oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xc3Pa5dzx5ExZX38GLj4ZnJDsl72nzeUd7EWbt+U0ZJfbZnaMtHMMOy4LTDgd5YUy
	 YiymZFhRiQ0JiCsOE3yrp0PSqG/2JV0JSyANHfauuhrCKANQhNNArlGmCJhvmwARcm
	 9BWScijM0YNw3OUjw1nP81jIz32DUkby/mh4T1xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/456] firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()
Date: Mon, 17 Aug 2026 15:26:47 +0200
Message-ID: <20260817132540.585268348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 34351f8c4d6f36..2f8c95d9362f44 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -558,7 +558,7 @@ static int ffa_partition_info_get(const char *uuid_str,
 	uuid_t uuid;
 	struct ffa_partition_info *pbuf;
 
-	if (uuid_parse(uuid_str, &uuid)) {
+	if (!uuid_str || uuid_parse(uuid_str, &uuid)) {
 		pr_err("invalid uuid (%s)\n", uuid_str);
 		return -ENODEV;
 	}
-- 
2.53.0



