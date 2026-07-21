Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F346E00C;
	Tue, 21 Jul 2026 19:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662095; cv=none; b=nF3URmTYmo96BfNFBfz/QBZeCOWOMtKDN85Er89K54e79s+0gJym62KCsrjBGAYI32w0RZcijWHxPbEUoh0VVYPffeijlfWw9zlSzh3bmf9v9ejhGrubEZKttqcWlbmDjzVCdqahFslgBAzw6YVmIK4PINUeQDyjpk7oaqlIp7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662095; c=relaxed/simple;
	bh=qBvk2ajybXGNGCzGHO/+eZd4AkjwdfDz+6wxXUgT3Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/kXydQNMh5brbBMKih3kt+D3zyA6fap65a2HHXHjbodcf4lN/JSOIb0fRTpcpIpa8RXZzu/ER/wwZt9GqS+InlLb/HcJN9epakf9PUHPtC+QpRg45DdXtluTgZZoz4xneyOY4gQmU+CkeAygR0/9BUo9NxXeQsuCKa6OAfBCng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TScAJbKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TScAJbKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146181F000E9;
	Tue, 21 Jul 2026 19:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662087;
	bh=1I8R9gz7qUO4RB0+DMLO4QiCjDY7fmcGQMyer/JMATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TScAJbKP22E4QMs3/3DgiUT4rwxPL+16O3Glz8z75YQ5RqZVy/ziqUmx/YmZ3HsN/
	 PyCE4OBeVZ0o6//WmiRrAUbEhYIKQ+EuOZSXS4Si329668s7se4pszL7mQR929IAOy
	 Z8oG9bDe7e2xXte69d2FlATvFNjanaNbyd1m9CyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0311/1276] cxl/test: Fix integer overflow in mock LSA bounds checks
Date: Tue, 21 Jul 2026 17:12:34 +0200
Message-ID: <20260721152453.052352235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 71916e0e1546e8..15eeb1e5f0097b 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1015,7 +1015,7 @@ static int mock_get_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(get_lsa->offset);
 	length = le32_to_cpu(get_lsa->length);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 	if (length > cmd->size_out)
 		return -EINVAL;
@@ -1035,7 +1035,7 @@ static int mock_set_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(set_lsa->offset);
 	length = cmd->size_in - sizeof(*set_lsa);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 
 	memcpy(lsa + offset, &set_lsa->data[0], length);
-- 
2.53.0



