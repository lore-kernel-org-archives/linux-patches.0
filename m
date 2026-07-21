Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A4244AB68;
	Tue, 21 Jul 2026 21:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669088; cv=none; b=OUsCisNikQ48fQEKZV0U3Cw/dbfqWKsXAS0pyaEOZoCST+FkJYmqUygPOYqzhwhxKDTzO6S79xqL089EDre7rWTQfZw/XnGyV7RY0Pv0tGYdi66sE5pN3y+C/qs/MLoY6TAKylWoZpv5VV05zXaRfxKnaZKx9fZFtY+UGlWRe7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669088; c=relaxed/simple;
	bh=JlsV3+VlY9e372Z4lAsXsYad8iLbByeStDXkFjlXyv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDp4an6+KxHcnptVLFpD7LzlV4awWDCAN7WoMA6ALMO3BxqDSWbX3elI1vs0Glc+huRSngQOgGZYtMduK7R+SNCYNFjOpzGrfKxuaMS7QTq8QWznDyWDMYF89eSRyKcL0bojnh4IyvYYDCjR6CtRSHyXLfXMvDbgxPXkFkH8Ass=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygphq7dA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygphq7dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DA81F000E9;
	Tue, 21 Jul 2026 21:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669087;
	bh=ewnS+Wps5EwBjL/31nkFOou4UwIunVR2kdhKgB6+k3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygphq7dAIFjiZMId0lEsVGKwBq49qgmrJmCFUs3bgZpMc6Hzrxq4XFAN2E0UyS08M
	 hmEFAoRFcsfYUNRJANCUv3v9p/yurtG+ojsySDsdjxazKEChkYBc+t0G9sn9u7eoMw
	 qXF3ZtQS6KiSUtTfPlD4gp9ncVZUg/M4fzyS3su0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0420/1067] cxl/test: Fix integer overflow in mock LSA bounds checks
Date: Tue, 21 Jul 2026 17:17:01 +0200
Message-ID: <20260721152434.016778941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 81eafcada109b653977c4dfbd2b6a72470025a01 ]

Pre-existing issue discovered by sashiko-bot.

mock_get_lsa() and mock_set_lsa() validate the requested LSA range with
"offset + length > LSA_SIZE". Both offset and length are u32 and, in
mock_get_lsa(), both are taken directly from the user-supplied payload.
The addition is evaluated modulo 2^32, so a large offset combined with a
small length wraps around and passes the check.

Rewrite the checks to first bound offset, then compare length against the
remaining LSA size.

Suggested-by: sashiko-bot
Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Link: https://lore.kernel.org/linux-cxl/20260605143748.235271F00893@smtp.kernel.org/
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 6e9a89f54d94f5..e171a2f48719a5 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -148,7 +148,7 @@ static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 		return -EINVAL;
 	offset = le32_to_cpu(get_lsa->offset);
 	length = le32_to_cpu(get_lsa->length);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 	if (length > cmd->size_out)
 		return -EINVAL;
@@ -167,7 +167,7 @@ static int mock_set_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 		return -EINVAL;
 	offset = le32_to_cpu(set_lsa->offset);
 	length = cmd->size_in - sizeof(*set_lsa);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 
 	memcpy(lsa + offset, &set_lsa->data[0], length);
-- 
2.53.0



