Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3752F9E;
	Fri, 15 Nov 2024 07:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654050; cv=none; b=Bn7p2stdkhxret8KBSUuL9SHIwm5SxuXg5IKpZWyKvh7L0T+6podZueZHyTdLvoeZKuuZcycibRXbe8LH4z7KHNsN9VzUsqZYyv/eLO8A9Dp/LeO/py5eahO6eg3wZ2it7IRENiWJIIYqSWptvKOvm93G4slklM4Fn+SeaGrVxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654050; c=relaxed/simple;
	bh=PcWvCDkoVRyquqmSeDe4L9cMPbC0GGuSHP4+AxA2UMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzlAbGoq+I3DCkXwKFsol7TS3vTyL2mvcDsOIlloyNqTYfoePV3fRjVOrLS+7E0yV6KFtLCKHMoaO9u+GSnx7au56mtXzW3yZjh004euimqKutDHkX6ZG9/bA38s36ncotQWniJ4K31eDSb3syKK5FKjYHPmZFQnkPi/5rigBZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvX1+hSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvX1+hSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3371EC4CECF;
	Fri, 15 Nov 2024 07:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654050;
	bh=PcWvCDkoVRyquqmSeDe4L9cMPbC0GGuSHP4+AxA2UMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvX1+hSPch43WJVhi5mO+wb2t9My5YotqHIEwoq9jV1XVs2R3GaeQOs0r9qVU2LMs
	 XlVqwObwceGJdBhHEeabnbHliUPHoZN6Iafwp/slxs4Hn1q2gJKxj13E1DkY+LTc1y
	 dFs83g8PRTCi3bgu+KZPvrAW2/+KRci8a3bk60Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	2639161967 <2639161967@qq.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/22] powerpc/powernv: Free name on error in opal_event_init()
Date: Fri, 15 Nov 2024 07:38:56 +0100
Message-ID: <20241115063721.546784435@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



