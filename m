Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1252BB1B;
	Fri, 15 Nov 2024 06:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653333; cv=none; b=eboKYHzDKBKEsiMzOx725MIMFc7GpQ548Ryt3xc+uhx4qTSEqac8R43hfUrVrpR1tSnIMkw6+ulxnMZa0TRTnT8XsVRHI39d9MwMrebuwrrUwzUA5wo+TN+Lq6His9yGuoG3WJ0pKw44B40Od+wwl3Oyo2A2hUTNQr1PXkXfeUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653333; c=relaxed/simple;
	bh=FIx+BpA2pOY3jNOgiTIWbf6gZ4QHiwTyJbb2Xm3L77w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5LSuqOsoplPOjQIGVG79SZK9yztdf1b8belQ041XqOgpRUJbe5/dpTt27/UwWXiPAOy8F3Ybe3Sdpd2Kyhjc3HEFGEPQYZh1eX7WoBQ3Y714t9ILbs9HyIY4HtAw2QdiChQEXC20yID7J+qTu+w4I78Z0XBMmyR+yrS0xeh3/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/v8P0lY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/v8P0lY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E94C4CECF;
	Fri, 15 Nov 2024 06:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653332;
	bh=FIx+BpA2pOY3jNOgiTIWbf6gZ4QHiwTyJbb2Xm3L77w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/v8P0lYENP4HFm28hORDeDvyfDpQaSzk3UQPCcHRppjShInM8mERuu6r/masr4Y1
	 G8OYx1Y01Oym+NV7IjQAeMo6L6lGHhGlSn2Tu8eEO6uTXAeZJKDUb2vqqVnKjCngYw
	 LiBrFH6/wj+H050FaVKi9p6QbF6xOtK5Bhcl7s6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	2639161967 <2639161967@qq.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 28/63] powerpc/powernv: Free name on error in opal_event_init()
Date: Fri, 15 Nov 2024 07:37:51 +0100
Message-ID: <20241115063726.935970467@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



