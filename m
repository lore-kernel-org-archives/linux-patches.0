Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BCE4CCDC1;
	Wed, 30 Sep 2026 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782362; cv=none; b=tp6STm/Tjv93ZcDqUoB8muLwuetegyqnUTAUXdOuTe655ORBkc/+oAfY5og2s37zVfp9xJhnThaSXZ8lSOgrdzftiBQrY+R7rlJtD6yPUE5G+6MUwRzNdthxaStuiI58gsPeAYi+NDDPVwQYoNiEJIw7sjaEPYr02NfcEV9z7xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782362; c=relaxed/simple;
	bh=YtdhcYqSnS4wp0QkZtRNPzLk5E8DBYgn6lVSmcC70Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uswnrn7SAo7DWkbb1263/8x89hGBKlknacS4Wg1q7lOBwz8zz6pyZ0wwjz/Jdwy4XRpnpUwGI5+3JL5TyCb9zwof7ypAhEYdUL/RYSYz0/7AipqqytCwKrCFV7dMOEfxdLK/u3LXYVyFFRgh4ULTXX5nyYuVCPMHlD/vDe5LS74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idVLONBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idVLONBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E596A1F00898;
	Wed, 30 Sep 2026 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782351;
	bh=duvfrHfDnXLtI+IAfG0/WDkVcoPrKHMeRk5pjEKoQTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idVLONBozdHsfbS5fAVro7kwkSWJPAQuWCyXR4QxnPcTCo39ch9ruPiZtAwn7nj4g
	 IkXHtu+/LJQMgx29vZmCILRxCa1TUPPFUvplYrZNwyBl0U+7lYT+7QedMuLSugs4wY
	 j/IgWl2AAgI4uTGO7lHIYt6hiN4H2n6UkYQCe198=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/595] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Wed, 30 Sep 2026 17:18:17 +0200
Message-ID: <20260930152347.809323151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hirokazu Honda <hiroh@chromium.org>

[ Upstream commit 1a6e94a8ff32e7879effd1e4a45bf112e506edc1 ]

On ARM64, shared memory can have MT_NORMAL_TAGGED attribute when using
the Memory Tagging Extension (MTE). The OP-TEE driver needs to
recognize this as normal memory to allow sharing such buffers with the
Secure World.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/call.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index f8f1594bea435..8bfa8315b56ff 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -571,7 +571,8 @@ static bool is_normal_memory(pgprot_t p)
 	return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
 		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
 #elif defined(CONFIG_ARM64)
-	return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
+	return ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL)) ||
+	       ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL_TAGGED));
 #else
 #error "Unuspported architecture"
 #endif
-- 
2.53.0



