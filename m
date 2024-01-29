Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F6315FB0A;
	Mon, 29 Jan 2024 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548645; cv=none; b=dPik/832XzKMwxwjmDa7frt72Y6eJ2hoP3pEmHk/0M17KBtFXI+dwMDMpTemr4Y66dQmY+fZ9eDq/C7LSfthU27Bl07GU5I0BcIKaJon8sYjGL2hzf6bVKQSDJKDVbilPy+SaP/tVQNIxW84Hf2z7VrmVwgzJqnZU/6bVs7cE9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548645; c=relaxed/simple;
	bh=f7gC+o7u3rMQllsOYNzFTVpaQX3x8+lbLKc7MgybKb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hvf1GWvXB6dYON2mV9H8/2g/w2A48zcHrSz8vi89eN8bEswFUqTWdJAD+ByQ7Sq4uDOC1pMALVP0CmjWCzPGl8FG1O/O8KAG0hkZznRG0sJuLiZuR3/Ojd4Hd/6U4FSKLcDHcDKSDSMv69hXef/3c5dsZ3tztIt8mf3E2VWHzVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQJERa6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQJERa6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4BAC433C7;
	Mon, 29 Jan 2024 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548644;
	bh=f7gC+o7u3rMQllsOYNzFTVpaQX3x8+lbLKc7MgybKb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQJERa6gXeXvk6iJBUwIwEEwGr/pQK7dwhK9e01VuRFR8c5qv/G/OTa4CG3eCy1XU
	 jZX24rHNRhsGl42UgmlMNlv4Eu8ENNFJ030wFDSCHMCEYj7p2Jb6VR773zbjDGlFtU
	 8xrkrU34aVkmxXWgQ0bFfzIUacTIcWQIavuFrBRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/331] MIPS: lantiq: register smp_ops on non-smp platforms
Date: Mon, 29 Jan 2024 09:06:26 -0800
Message-ID: <20240129170024.299031724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 4bf2a626dc4bb46f0754d8ac02ec8584ff114ad5 ]

Lantiq uses a common kernel config for devices with 24Kc and 34Kc cores.
The changes made previously to add support for interrupts on all cores
work on 24Kc platforms with SMP disabled and 34Kc platforms with SMP
enabled. This patch fixes boot issues on Danube (single core 24Kc) with
SMP enabled.

Fixes: 730320fd770d ("MIPS: lantiq: enable all hardware interrupts on second VPE")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/prom.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index a3cf29365858..0c45767eacf6 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -108,10 +108,9 @@ void __init prom_init(void)
 	prom_init_cmdline();
 
 #if defined(CONFIG_MIPS_MT_SMP)
-	if (cpu_has_mipsmt) {
-		lantiq_smp_ops = vsmp_smp_ops;
+	lantiq_smp_ops = vsmp_smp_ops;
+	if (cpu_has_mipsmt)
 		lantiq_smp_ops.init_secondary = lantiq_init_secondary;
-		register_smp_ops(&lantiq_smp_ops);
-	}
+	register_smp_ops(&lantiq_smp_ops);
 #endif
 }
-- 
2.43.0



