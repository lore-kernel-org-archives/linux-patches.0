Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD27FEAD0;
	Fri, 15 Nov 2024 06:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653433; cv=none; b=NOIKePBuhVfAZU4DABeA7ErQPkgSF1tgmWgVCj6i0/cGfROwrcqLo3XdLV+uMG2WGIA5IaIaCy2YhrN0EoGlM0tsJbMj3WAPoYH8Hol9En5LSaC36sE6t6yBrREgQfkSoyZ46kjvo4nQpv+ncsbGR+FPC6DbjbbcWN+F5V48VXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653433; c=relaxed/simple;
	bh=0Rkfer+V2V2wTI+IJQpKTYqUeu4Ga8ivha+TEStgodI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPoBNCI0bCeaCn4+KmBFAYlapDZ7akgZPlJTpsaOxGNVr6R1RZrgxNAOf5mKck+hGpE9UE2da09hrE6cqIy5SAMgm+z9sktnTtfLL6TO/6IUgt1N/hnbTRdmdg3nXiGjUpbivv4Q5qDKKUQ4ZTn0ZpcS0cueUyTzdEs3ORgbSnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sdpnmei1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sdpnmei1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE8EC4CECF;
	Fri, 15 Nov 2024 06:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653432;
	bh=0Rkfer+V2V2wTI+IJQpKTYqUeu4Ga8ivha+TEStgodI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sdpnmei15P46zj1caHESvtJcMGPzv4BAsCN7hl1OS7Fbwolo6RHsqu9rkFrYzirqZ
	 uwBvI1EaXGO0YG1/wNHrc0JjWy9WVrmJoN6rqAnkgdhziROFIk3ZLxNy/+s4HeN/qb
	 HWl8x/HWvjoJCqmiGibvrqaPjGCBOoUFqwFhGyUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	2639161967 <2639161967@qq.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 20/48] powerpc/powernv: Free name on error in opal_event_init()
Date: Fri, 15 Nov 2024 07:38:09 +0100
Message-ID: <20241115063723.694077222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 56a1f7ce78d2c..d92759c21fae9 100644
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



