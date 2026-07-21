Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383563B1034;
	Tue, 21 Jul 2026 20:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666078; cv=none; b=ScVLcSe/cfvQJzok2SPmSPrdomN8LFZbNI1sWa0Xx55f8UPryUEUVGJ0/Km3wJS3uXKtq9vLzTrXFov6CpuAF9noF0vlZMI9mZ7TviqBtYJ0PXwJpf4KISsDsG99l4b6ypdxAc2pflNC5/xow8SCzANMOkOlLJwfQXdYNNZLVY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666078; c=relaxed/simple;
	bh=TYaPkyfLwmhR9rL8FFRT99Vz3p0x6vBtZUP0UnVN28I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYgNZQqomiY64GXAgc3qFx0FvQMisUI9VnOZVjWbhD+o+LuLBC2XwhwoedG8Nx7MtFGydmwFo6unBlli21GirKmC7/dEa4At+v1uMilvWqidoaOVUmWh3KCGuEsvQZC87dP8H1+kQJbS9mfzMZDv4tQ6BZ9nvLVJ/1q8LuOOziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKDPFlM3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKDPFlM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2401F000E9;
	Tue, 21 Jul 2026 20:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666077;
	bh=6FPwCqiX9NPo5R59vtn+3G9FRJX3ALhHoPTZDSe7lzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKDPFlM39DQ9nKMNiumoQ/NubGAK3DMynG0FoALLeLi1sV04S51qE/RkaZXQGg6SE
	 3lxddZN+kMSuSsYaJeopyYbJx27+kEvXzikSSamrUFoUjkN/fj2z6HIYfsx1U2Fjzq
	 0eBtKBcWaC6+wyumu5Gh211NjFtDtqF1re4anzqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0544/1266] cxl/test: Fix integer overflow in mock LSA bounds checks
Date: Tue, 21 Jul 2026 17:16:21 +0200
Message-ID: <20260721152454.038176236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 0ed100617d9937..6d4ffcce326dff 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -940,7 +940,7 @@ static int mock_get_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(get_lsa->offset);
 	length = le32_to_cpu(get_lsa->length);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 	if (length > cmd->size_out)
 		return -EINVAL;
@@ -960,7 +960,7 @@ static int mock_set_lsa(struct cxl_mockmem_data *mdata,
 		return -EINVAL;
 	offset = le32_to_cpu(set_lsa->offset);
 	length = cmd->size_in - sizeof(*set_lsa);
-	if (offset + length > LSA_SIZE)
+	if (offset > LSA_SIZE || length > LSA_SIZE - offset)
 		return -EINVAL;
 
 	memcpy(lsa + offset, &set_lsa->data[0], length);
-- 
2.53.0



