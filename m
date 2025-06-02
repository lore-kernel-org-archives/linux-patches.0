Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A6229B21;
	Mon,  2 Jun 2025 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877203; cv=none; b=ZIysp0p9v1K2ulkCtuVKOG6KliJwMpGiFZPIcQoYxDa9JhLNMpL7GlP9uXlncVY/RTzZu1UrXJuRxlrQVDRPhS6rBWZdCmwHCXLjO4/s1zm/BwwoToaJ4xmrajPjBFotyYD7GISTWsuU0HHJkzAcLpYWpzV5UwQPc6a/RnUrx20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877203; c=relaxed/simple;
	bh=1pioOie8xmX9sKfnJ2NhfTLgOOb8Yi5Jh+UDaM0NejE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmdeox5O5o5SdHBwCggqWyDLNdpcuRfulBX+utCQCqyPabnF7j/mEhNbnPi12i9s0ofLEPzVyWnykCCE6KOkWpF1UIgsuIfjd6xp900ESSDWQszmcbVMPy44BHIEjlqK0qhxRelqqLF2mdpihZUaSmO+0D4mDgWfsMIIKDTvTic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhgIfOHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhgIfOHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F98AC4CEEB;
	Mon,  2 Jun 2025 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877202;
	bh=1pioOie8xmX9sKfnJ2NhfTLgOOb8Yi5Jh+UDaM0NejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhgIfOHocrFlpdqOxUfBroyjRXMu20NUUyA+t8qfHL1KLlU+hX5qHX8DU9416b1Ns
	 ft4uebo9XoPxaDdn9vT0Pi9FLBuWph1OcU8wmlyCBvaLBbQI67kOH2FwBnEiy+rq2k
	 KTVBy9SJGGoNRjpRzeT5SR909tiOrZs6ekwdDr/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/325] net/mana: fix warning in the writer of client oob
Date: Mon,  2 Jun 2025 15:47:58 +0200
Message-ID: <20250602134328.004205061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d674ebda2053d..9e55679796d93 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -995,7 +995,7 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 	header->inline_oob_size_div4 = client_oob_size / sizeof(u32);
 
 	if (oob_in_sgl) {
-		WARN_ON_ONCE(!pad_data || wqe_req->num_sge < 2);
+		WARN_ON_ONCE(wqe_req->num_sge < 2);
 
 		header->client_oob_in_sgl = 1;
 
-- 
2.39.5



