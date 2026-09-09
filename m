Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D82550DA6;
	Wed,  9 Sep 2026 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962707; cv=none; b=drqN0nFU/9nyfQlYorOsbPkG01CkVHpz4m/CAJU4JpB376gQ3Wtcu8Zb4GMWHKf6pH5Pp+lw9fDPjFM+OEPz/vWMtH7SiiNvR2hpd+674XQJoXHHVU1r2T6elk66aQcIq5mIsqSer6PERYAnNOMpzjAAA3J80kXiQ8Z6A7hQznI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962707; c=relaxed/simple;
	bh=GlH0rNybKtnxhGwOzDa4iEp6iTAlVTQexOyQjAGekNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msPQioq1dVf/daRpp+Rn8HRPWec8TlGPMYLu09C3VTxvMa6oUC+u21WTIXe8hfNmxkg1I+GtfRpnQRIXu3iUo1rqQOOr0ddrt8GRLHXMfIoTsuliFx49y1UkbD8WIT16IZSfUw9cAJ536yNKVukJDxYLSmWQuSdXoPMeeoiMUkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eghdZTDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eghdZTDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3578E1F00A3D;
	Wed,  9 Sep 2026 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962705;
	bh=uEGWeCULFSfkICxdYBhORk/INNM2FYPD7Wagx/prk2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eghdZTDAOCLF/BfOjbZtJT78A+00FA5QlU71XS6QGDDbnQhfHF3xJK0h88a0srWRV
	 zjOkCPCBGDZw65daG6ZnyINGTTAw5snHz5ok932O4Y6uKXtSqc9cZv22qY78gnyTcD
	 y73vsOh/10FG81reklEmrcFnBMuWnVMtlbODnME4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 382/556] media: mali-c55: Fix AEXP IHIST disable bit shift
Date: Wed,  9 Sep 2026 15:41:02 +0200
Message-ID: <20260909134244.118613061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 9a2925b823d541a23b8330f80056e6cca78c7677 upstream.

The post-Iridix auto-exposure histogram disable bit in
MALI_C55_REG_METERING_CONFIG is bit 16, but MALI_C55_AEXP_IHIST_DISABLE
was defined with a shift of 12, copied from the AEXP_HIST definition
above it. As the value is masked with the BIT(16) disable mask when it
is programmed, the result is always zero and the disable bit is never
set. The IHIST can therefore never be disabled, neither at ISP init nor
via a parameters block flagged V4L2_ISP_PARAMS_FL_BLOCK_DISABLE, and the
hardware keeps producing histogram statistics that userspace believes
are switched off.

Use a shift of 16 so the disable request takes effect.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-registers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-registers.h b/drivers/media/platform/arm/mali-c55/mali-c55-registers.h
index f098effde7b4..4cd13b702d9f 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-registers.h
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-registers.h
@@ -173,7 +173,7 @@ enum mali_c55_interrupts {
 #define MALI_C55_AEXP_HIST_SWITCH_MASK			GENMASK(14, 13)
 #define MALI_C55_AEXP_HIST_SWITCH(x)			((x) << 13)
 #define MALI_C55_AEXP_IHIST_DISABLE_MASK		BIT(16)
-#define MALI_C55_AEXP_IHIST_DISABLE			(0x01 << 12)
+#define MALI_C55_AEXP_IHIST_DISABLE			(0x01 << 16)
 #define MALI_C55_AEXP_SRC_MASK				BIT(24)
 
 #define MALI_C55_REG_TPG_CH0				0x18ed8
-- 
2.55.0



