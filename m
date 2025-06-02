Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB9238174;
	Mon,  2 Jun 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876325; cv=none; b=hvaPhxkzE38z17OO+GWAcZxhSykaw7QFJt9rQcci0U0O2ECIc24rtIaS1/abcsvbPZbS1BJ18bQSXjsBwEoI99R9gH1glvziOR4QKRJVUdA4A6AgcdKwTVWdLBrXEzojX9arSs4BI6gk29pe6eeEELE/n6G6bL1jtNb5QepfGLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876325; c=relaxed/simple;
	bh=JOWvlx6YVt9ipASdrXbDCwXL4UKqGrsaRO5Cwf2aeZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTrijagvLsxDP/J+1IJJ92uF1t/GH+LA6RshvtWbDX0mTFUOrBVK9V/xhHWBNG/ytJQqnGW4kJ8xPgJZS/5QhEWvWeyftemSZbrwgr6lAl7WMc3TPLs8r8XSBRR5HqjMYO8lZpaNN5QOPDIH4jy7gW95K8aCzrJgQTRO/Xno+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpvnWMZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpvnWMZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8FDC4CEEB;
	Mon,  2 Jun 2025 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876324;
	bh=JOWvlx6YVt9ipASdrXbDCwXL4UKqGrsaRO5Cwf2aeZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpvnWMZdsR6HG3C1UyctPcb/njiVP1CdE4gzlM09oCDNSbH1LSJkCNd++tJIOz8JF
	 cb5CsXnMvDlU87jnIEeY5xvcToVMaho8AW2CP7OYXSvuvtkVyDb+8Kh4U0w0U6BpGX
	 4OGsdYfUBFpQvlUtkLhPW7aOVyW52HjsgrPLx8AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/207] net/mana: fix warning in the writer of client oob
Date: Mon,  2 Jun 2025 15:48:33 +0200
Message-ID: <20250602134304.246059613@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 5ec7e1c86c441c46a374577bccd9488abea30037 ]

Do not warn on missing pad_data when oob is in sgl.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1737394039-28772-9-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 0fb42193643dc..7864611f55a77 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -957,7 +957,7 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 	header->inline_oob_size_div4 = client_oob_size / sizeof(u32);
 
 	if (oob_in_sgl) {
-		WARN_ON_ONCE(!pad_data || wqe_req->num_sge < 2);
+		WARN_ON_ONCE(wqe_req->num_sge < 2);
 
 		header->client_oob_in_sgl = 1;
 
-- 
2.39.5



