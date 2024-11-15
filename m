Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D934E153800;
	Fri, 15 Nov 2024 06:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653593; cv=none; b=lHI2nfJ391ZeuGtdNLkGqpc2L3+NF4No1fTW09EDFavn+65IeNV4OvC9naBzcY4Xh/ucIgAjb+UPj+QjXf8oEJxy7HHcJcgc4FQSxBQSjVAOCIr+/w5YhDIBe9HfGbU55xvX0CSWR/9NtjV/PmXwhjY68vNK70GpdBnViQlf3g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653593; c=relaxed/simple;
	bh=q7pRiWCBPP2FdSSbR8+pCKpbb29af1rpLDFtPKzzE2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT0zJpuojlRy+edLv0lHsRfwaR4WQJkSFcfxrrktopGt5ntHf4effwewZO59F4XikS+Dn+HAH5/M431rItSeogWP92miFYrqOikfATollWJ2q8vJ4WDtWaZVHMklhrJytQSOWorwD/HmYKMhFTeO9Z4Wt8Yhv/5lbMxpBLp1S4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuUVh5Wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuUVh5Wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EC2C4CECF;
	Fri, 15 Nov 2024 06:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653593;
	bh=q7pRiWCBPP2FdSSbR8+pCKpbb29af1rpLDFtPKzzE2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuUVh5Wc9cz0Oe55Y1RF11nt4zAh+Bld4JFaA9ro8P5tnOLCiDrmN0oeHK6EqJXrE
	 Opw+U83oC78eLKUbpoxdFllIZgKVMhETNlCH5eMOpIEnPUVSuvSGEvWoGHA2E7q8Z6
	 sbeqGqTZxXcifpxd4Hpv2M6Pekq1eWUOLTrGta50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	2639161967 <2639161967@qq.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/39] powerpc/powernv: Free name on error in opal_event_init()
Date: Fri, 15 Nov 2024 07:38:30 +0100
Message-ID: <20241115063723.339771348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit cf8989d20d64ad702a6210c11a0347ebf3852aa7 ]

In opal_event_init() if request_irq() fails name is not freed, leading
to a memory leak. The code only runs at boot time, there's no way for a
user to trigger it, so there's no security impact.

Fix the leak by freeing name in the error path.

Reported-by: 2639161967 <2639161967@qq.com>
Closes: https://lore.kernel.org/linuxppc-dev/87wmjp3wig.fsf@mail.lhotse
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20240920093520.67997-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-irqchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/opal-irqchip.c b/arch/powerpc/platforms/powernv/opal-irqchip.c
index 391f505352007..e9849d70aee4a 100644
--- a/arch/powerpc/platforms/powernv/opal-irqchip.c
+++ b/arch/powerpc/platforms/powernv/opal-irqchip.c
@@ -282,6 +282,7 @@ int __init opal_event_init(void)
 				 name, NULL);
 		if (rc) {
 			pr_warn("Error %d requesting OPAL irq %d\n", rc, (int)r->start);
+			kfree(name);
 			continue;
 		}
 	}
-- 
2.43.0



