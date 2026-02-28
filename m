Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C236F47CC82;
	Sat, 28 Feb 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301324; cv=none; b=VlZW7Db336oPmypQgLAoIrH8NjT/RqLxoJsbFiUIsNqxkhyJNTQP4KGAfjmxax49dskeTIliVhHUfL0qgpwLWZzGpuOeVmSx60kGtLe0EdBXQppFigp+SXfFnR8S6zXOSbIYvTLZncDoNDjhf4TyaBAjAF9+Bkuri7BJWHk31bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301324; c=relaxed/simple;
	bh=/4+hOPyePWoc2cQ7a3fOGo9JpaAr/zRNdwQUmgjfWPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5hnajtS/eyhlCNx3nfx3l9yhtbyu/cZbsyFtEyE2QbXwceUQ5ctNc8fSIrmoMaDN/T0AIA4q49l4c1buoBDj8005ppRzRLUzhJG+KvCU35uyal5umxHlV0JPHVx4dZaEqF2lpS3F1/mMYH+P1toHswvMFHPLeXAsDCrqzWm12Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFj/kK/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFj/kK/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D303C19424;
	Sat, 28 Feb 2026 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301324;
	bh=/4+hOPyePWoc2cQ7a3fOGo9JpaAr/zRNdwQUmgjfWPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFj/kK/BrH5QoLGoUKRhWxBHUyqU/L54SGYPoCJj1YixBEyZDV5jfNfWvjYnxlN4d
	 P7OXWzg9XPVy/Qc1Km2tuEEXFW5zIni/E/arP5saGS/pLKHUO1RvVYtusgrKAP6DFn
	 Ap0pnKR7HylEXGknl2JNv7hAXVmE/G4nStWslsVACoo3V1vdWPsYQsQWycEbAWXvjq
	 y7M4O/3rZSJEAUEUlItUNIiKSwQj7M//bJvHJf3smzs47MnMozpB9hmFU+8LFKnSPD
	 9Q4MK42sybonVy8eXC6von2wr39HPHrxw6TRC8+it2QRjjunGMPuiYlSpUArIYWURU
	 gQsIDMI6IKYoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 511/752] media: cx88: Add missing unmap in snd_cx88_hw_params()
Date: Sat, 28 Feb 2026 12:43:42 -0500
Message-ID: <20260228174750.1542406-511-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit dbc527d980f7ba8559de38f8c1e4158c71a78915 ]

In error path, add cx88_alsa_dma_unmap() to release
resource acquired by cx88_alsa_dma_map().

Fixes: b2c75abde0de ("[media] cx88: drop videobuf abuse in cx88-alsa")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-alsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 29fb1311e4434..4e574d8390b4d 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -483,8 +483,10 @@ static int snd_cx88_hw_params(struct snd_pcm_substream *substream,
 
 	ret = cx88_risc_databuffer(chip->pci, &buf->risc, buf->sglist,
 				   chip->period_size, chip->num_periods, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		cx88_alsa_dma_unmap(chip);
 		goto error;
+	}
 
 	/* Loop back to start of program */
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-- 
2.51.0

