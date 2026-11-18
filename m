Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037837;
	b=AUbwawnGUgYDh6WYfXlgXui3ykMSKgOsLXYrsH3FNOwL6VU06Ihx28aa8J2wRjRtQGSk
	 k1Yy3L2IKonQXLfej7u0xnomkQRroLOTDmjEu4aHK1HBa/77M/1A+j5MovOuXxFsy6lUn
	 e+JX78ZyghCWEzviBnKny5jltQEQxy1JmtvCEKx0jVA8YLgljZ3zQEvwiOXSjNrH7TJf6
	 ixBNdbBGizGY/nyV3/JHynpMUHw1V0IZoQ1tyNkPitCsA3ZB/HsTsz5zUb59uzpV2axn3
	 OFaV55XIPIlMngdqn4rg943WytJJOaaH/R9FLwadqsGIFBczDO5x0m7xQylqksIw3ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VJ4bp3AIA8ZTMJ6CSd058kOmE6YGrl8qnaSttzGWA2w=;
	b=lc4LAKYnNP8HiptH0Xisz9oujr90bp9C8N+3/Fzh+bAQBl9ep65QN67qfb0H3IhEQMFQ
	 31lKqPkmWIp5RmlMZAZWcPJ0+dtCdMBP8VawFzfpDzVBaWm7pg2vMpqB/b1B2tZDHAs4k
	 aUlGw48eBXxc59o62ZjkvZ38vDW4fFnIPmx4o8UV3+yfRi5dvtJrpRvnzZL6URujFki2m
	 olWZVV6Fp3f4gacZBFGRXbo7NgvVFV29Yygdm+J6pK2HESQXVbzO4SkJmhsamvUGsDNha
	 pfxOTgIVkbb3JLtt4qRrmcyZBhoKlV+XMxKFxH9fL8p0TWJ50oZQtc9sLQuLqz8Aqmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VcxD+O28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC6C606A32A;
	Wed, 18 Nov 2026 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VcxD+O28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36EF1F000CA;
	Wed, 18 Nov 2026 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037837;
	bh=VJ4bp3AIA8ZTMJ6CSd058kOmE6YGrl8qnaSttzGWA2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcxD+O28sbGj9/5io7lUK/UILrCJJusqzwCr4E/+mhSX8585yVvFipgWxYrfMOoUb
	 /OAH0WYmygJ7kOf4k8DpztPwWiFoHSQPjgtF0sy7y7Ip14gdRNbM4vGVDcFVSCtynF
	 RX0G85E18mbgW4C5LKIRKOQAgiPJ7KsSdDRv3iqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1535/3318] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118150407.025055569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 32f01c00dc416..a033d8dce5aab 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -282,6 +282,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
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



