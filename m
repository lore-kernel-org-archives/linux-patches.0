Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E51C5F26;
	Wed, 19 Mar 2025 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395061; cv=none; b=t+m3XcC8Z0g+Al7TFLzJ9bRrN60XWc5yjSRKvu8Fi3HWsSSyAUd2BbuHd+dY7aFbXbOHNdl+qfTxPOqE4LV0Dh6NkWdYzpe+l5TCR1nhXUWY6YwCT77zWKJTHqf+RuHQA2BcbeNj3De8h3Zsny133NNA6Q4s4p43VRIIH14Ghek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395061; c=relaxed/simple;
	bh=duLTdOu8nGpIhQZ1LluwQnQ4TNoPLei0446tmalqt+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b31QU3eu7v+73SkYvPvwmVPskvBhTIS6GGQQa5fdBHsq9swcbxfYOXwscU6fE62zAY5i55fxLrwYK9vjcpI3Eyjyq6tZi3017YIG200dATdHozt2FkbazPw94YZih5XQnshMaZk2ihfce2uTxT493PrqBd8XqLmBGjW2elt7KXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/vzmJAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/vzmJAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A064C4CEE4;
	Wed, 19 Mar 2025 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395061;
	bh=duLTdOu8nGpIhQZ1LluwQnQ4TNoPLei0446tmalqt+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/vzmJAPG0DN22T1lx+p9iNUzLBPEq2HGjhi7VJVwF32WV1xHWGHhaCu2wnZrUKhE
	 FsjFwIo6WHsQzoBz4eGISdLA4Ok0DWJdqA/2RKfOZQu+1YGi5Q1vyWoNIKDwyVO/Ax
	 mQzjQkTYm5G/v+iwIAGTu/HHYSe38njubPKf4Axw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/231] LoongArch: KVM: Set host with kernel mode when switch to VM mode
Date: Wed, 19 Mar 2025 07:29:48 -0700
Message-ID: <20250319143029.189673123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 3011b29ec5a33ec16502e687c4264d57416a8b1f ]

PRMD register is only meaningful on the beginning stage of exception
entry, and it is overwritten with nested irq or exception.

When CPU runs in VM mode, interrupt need be enabled on host. And the
mode for host had better be kernel mode rather than random or user mode.

When VM is running, the running mode with top command comes from CRMD
register, and running mode should be kernel mode since kernel function
is executing with perf command. It needs be consistent with both top and
perf command.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/switch.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f8184927..1be185e948072 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -85,7 +85,7 @@
 	 * Guest CRMD comes from separate GCSR_CRMD register
 	 */
 	ori	t0, zero, CSR_PRMD_PIE
-	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
+	csrwr	t0, LOONGARCH_CSR_PRMD
 
 	/* Set PVM bit to setup ertn to guest context */
 	ori	t0, zero, CSR_GSTAT_PVM
-- 
2.39.5



