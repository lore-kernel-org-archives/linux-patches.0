Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046592;
	b=I+fSrnBKqi19kvbok2cEp7Ncz8D0UrOMOnX9TZbQ1cWjyg3gDPv6o49aJoC5JPNJBcw4
	 HXB26RVJ6gApAE+YBtWMPVxh3zsNQjQ8uCscjo7Yhr1KyMC9HvWTvf4LdQ6uF5jls//i3
	 41VieX59Qm8Ewn5KgMHG64VnF5qBEVVsl9wUfAldb0z9UvsBRji6EX6BHiTyiV43ncTHQ
	 jhjnsDtbqqYe1GBUsRO/8t+r7Ac5rtG1qM3Uc8JVQOiQNI/qFun2dJdBioLiWzon+Xc3p
	 jiSUj/aSlrGOf0Ye/HIO5XiwySZO8sdylYJ6Gk+CcPaOEYmJAOQACVtJDa4wqExvwTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jcLFfKO4vRvClm9rjd8nK/ytY8Jr65f+Wo2vwwosi+c=;
	b=lGQISpIZDBk/P0T98o4zaTnU1wH9k8HgZ9PqmbXr8Mm+viKOtBeaJ1pVx2n1DWfBKUf3
	 2N5brqpoNaBfko7kttOL875A9cn6qunugjBuZzy2I1OaWHfCQ2r1baHoeuDPE9Dd99wxY
	 YipP7sDhHbbNEkQe/YW02/18piJnR67rlOywiQ1vbb3v+hphvKJ2PYu+fAT+jGWTJrtlh
	 igs0B4H7PYZmU8Mv5sna7lzh6jkoiJ6HC0GOPVXHBRs6nR77dDZAn2QheIixRPPCnITYT
	 HrDAkvnshECNJuTAdiR1aBI8WV4T6nLgqCj6iny5oNOHCgAD42VClGIvSt145chvdHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5PrEbCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D858606A320;
	Thu, 19 Nov 2026 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5PrEbCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F581F000C4;
	Thu, 19 Nov 2026 00:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046592;
	bh=jcLFfKO4vRvClm9rjd8nK/ytY8Jr65f+Wo2vwwosi+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5PrEbClNP1xKwr+wv1Rv14Ht4U6+OQf9GP89Qutuh3vMKZlmI8CCN+40X+B0ABc2
	 Ct6n/X5goTc4anCjbnjOVQhBCNxovym6Evk48mwtk9Z/als+xtke1dJaIqwg9XngUs
	 pIXTHOZjANqTIMmWx6MkzjrlnwWPMg0dQd9SgY9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1295/2857] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Wed, 18 Nov 2026 15:38:49 +0100
Message-ID: <20261118150248.113344863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 29b8758b4700357909f06705a0c48c7a60c556d5 ]

The host side does not know how much valid data will be returned by the target
so it will typically provide a buffer larger than the amount of valid data in
the ANA log page.  The memory allocation used by the target does not guarantee
that prior kernel memory contents will not be returned past the end of the valid
page data.  Fix this to ensure that the SGL is zeroed before copying the data.

Fixes: 72efd25dcf4f ("nvmet: add minimal ANA support")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 9d4180ceceb23..b62f40d0899e1 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -280,6 +280,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	u16 ngrps = 0;
 	u16 status;
 
+	/*
+	 * The header and one descriptor per enabled group are the only bytes
+	 * written below; zero the whole transfer first so the unwritten tail
+	 * does not leak stale kernel memory to the host.
+	 */
+	status = nvmet_zero_sgl(req, 0, req->transfer_len);
+	if (status)
+		goto out;
+
 	status = NVME_SC_INTERNAL;
 	desc = kmalloc(struct_size(desc, nsids, NVMET_MAX_NAMESPACES),
 		       GFP_KERNEL);
-- 
2.53.0



