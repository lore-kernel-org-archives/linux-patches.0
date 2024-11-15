Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BC3185B5B;
	Fri, 15 Nov 2024 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652904; cv=none; b=HTF6MMiBKAyIKxkoO2jgR9+C3PqozdtaTvTJ41wm+TLIDiadbC827ZQYKiV92mmWixsJommt6NG+cC4PVitTvPih75pKKQV40tKbeeTurFCAUKfsjVyOXvLHYzED6XUIYl5/TudS2JejbjfGy2vJIjYu9m1T1KVDAVTZ1WjlBQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652904; c=relaxed/simple;
	bh=VMfRkuPeDM2vQz+M7+LYTDXIJ71hSq12gWxVO5vq4vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIFKBw7yC+73ZqbI7+qo4iJrQMA+OeBK6Sdh1a765nAExBCGDLLHE6ZXNLuOQ6EPQJ3kotp6bpRzD7TaKErvF+35lN5So2qTRkP6LIAZNkMtqEZeQyrZDYn2ED/fmx7Ek24r0pEgTNYOPLiqG2Cb7hIBjgEHSfPLRqHznK04yGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtMpixJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtMpixJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC3EC4CECF;
	Fri, 15 Nov 2024 06:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652904;
	bh=VMfRkuPeDM2vQz+M7+LYTDXIJ71hSq12gWxVO5vq4vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtMpixJen8YYB2ROr2HBEA05GKm9E40yIVGuNAgihsCyLY5vltRZc9fWx2/Zo6jsY
	 Tli+sd0+LoyaDVbheR7SjtN3sBg9s6Rzs0RHmP1/d2bsyR1Vp1NSRv5rMqZLkWJaOb
	 C4aOfOEQM/OlgGbo6Yth55iD0EGeVUjliIdpO6ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	2639161967 <2639161967@qq.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/52] powerpc/powernv: Free name on error in opal_event_init()
Date: Fri, 15 Nov 2024 07:38:02 +0100
Message-ID: <20241115063724.622552205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e71f2111c8c0b..676ec9fdd115d 100644
--- a/arch/powerpc/platforms/powernv/opal-irqchip.c
+++ b/arch/powerpc/platforms/powernv/opal-irqchip.c
@@ -289,6 +289,7 @@ int __init opal_event_init(void)
 				 name, NULL);
 		if (rc) {
 			pr_warn("Error %d requesting OPAL irq %d\n", rc, (int)r->start);
+			kfree(name);
 			continue;
 		}
 	}
-- 
2.43.0



