Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C109472520;
	Tue, 21 Jul 2026 17:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656616; cv=none; b=sRn0CcfWFeTEtvcI71FsMntcyb8vNXx247opGyxoLvJ9O8+3HZQ+Dy24DhZ7ql1g2fuM7vY4X3HfR4OxN1yCjnKuwPqCw6DmYon8Y2ABsDcIElmOoG3OVnyTWjNtIaa8D9Dwy+KBNKfOW0SYmeFAac40SNS64qJuPApCa1Wn05k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656616; c=relaxed/simple;
	bh=vs/l2WyYfqe2wm+K2K+g0vEcX8GLu4hwFO8t5157NdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFkLU0iMIqDIVgzeoygchV4q3L9xh3kGc0Unt/uLQVAjuepLS+VE1sR8Gy/Bp93zbOzKAbbBFV7lhotRfesXpjpMfDeNx7ePtxpnh680Cdv+TBWUq7K+X5woTI4vrLuGIPXPFkYvoW0Gzsp/kB/UE699j47BYfYUZCxG8YawZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2Gs3lnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2Gs3lnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7939C1F000E9;
	Tue, 21 Jul 2026 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656615;
	bh=dqjlNYnQGy09NWlm6bvq6vPwv8GtAiNxMSvfakPNaLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2Gs3lnximlZ1o5y9sFchVfg8ljsYTwi406szqgRO8h39yifvZXdoaZlzHT7K1k5f
	 nNkz/GWKhXfAl5cQuHPnGKy/4TDmAPZLST7rWujqA5hjScaVsDAIoj4p0ndTbnSCE/
	 bLf4Sp3q4FsoyqOj3Oxx0WwG0Drk6g4ujnuGkny4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0453/1611] cxl/test: Fix integer overflow in mock LSA bounds checks
Date: Tue, 21 Jul 2026 17:09:29 +0200
Message-ID: <20260721152525.494647570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index d533481672b78f..4474d5d74faf2a 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1054,7 +1054,7 @@ static int mock_get_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(get_lsa->offset);
 	length = le32_to_cpu(get_lsa->length);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 	if (length > cmd->size_out)
 		return -EINVAL;
@@ -1074,7 +1074,7 @@ static int mock_set_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(set_lsa->offset);
 	length = cmd->size_in - sizeof(*set_lsa);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 
 	memcpy(lsa + offset, &set_lsa->data[0], length);
-- 
2.53.0



