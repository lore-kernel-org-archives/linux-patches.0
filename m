Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015361;
	b=ZYXdbS61CeGv3qxKawqD+MV4u6NX2H5bt3jBMnqAP38AqS1/uSYLxHaIjoagNM6NK81V
	 /Qg7EsQqvM0qcfwV67zIp2Kyq9DeX4Ex5AOm1Fv7Vbk4/hoiWWtB+K9zfg4rbVqpBeYvQ
	 CdlLJoM/XQEOLXWVwL0kSnX+uZbKI74ClDP8D5xiZO4Aruc5pDIOmcIliMz6NqhzoVszX
	 QXCC4qKdP/4/rXjsbVEaBVDFOVqIo7mYYU/ldAc0DNFJGKzSuRUuQ1/BqgJxUVyXGlkcI
	 nM4esTVQDM0j54YU4/0BwEYTIBscHiibeENXOCwWbQtEzkFarmaNSfS8xr/FWAYTjlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6IHnzmSCSPt/Qum87QlgRd+t+9K9pmzF9pb0FJkkajo=;
	b=CtGeWfNC1umFSWaj+0YdecSxDfFjPNTRFNKAdhMnIOt7Qx0SSeqsnnVI03f9nThelTtB
	 hn1LS5Fj9lWENBObJVoRrLhwFuZssIUpwEklC7wrBKJ9Wzab2uKz49jbfkB3OQuLJkpBs
	 OVUNnXv2GUusGDVNqJbMGHRmo1Mzc4ZCLdDesFWKgGgYyYaE3pASw5PqY0LAi6emTEgS0
	 L2WlVMXSTYM3mkkXCY3cLhwjxDXOospKZvq70rBsvTpuzQ7iyqKDoEZZV3AmnvgGMnHIm
	 WlrkOZbyM5qq9Z7X2OnWBnzI8i0PE51eHmqXJTu9FvkGCL3DbEu0x2ongU9bzsOGkug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oa472w4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B8260A2601;
	Wed, 18 Nov 2026 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oa472w4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2962B1F000C4;
	Wed, 18 Nov 2026 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015361;
	bh=6IHnzmSCSPt/Qum87QlgRd+t+9K9pmzF9pb0FJkkajo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oa472w4WXOgdLqq8DsKUa7ngITzfbCx2/SXmyyqm833LneGrB4masu+f2nwCQflg8
	 3L/86FlCSpxpB8KBHivdk6d/3lZzhCOWtoUPOP8/v1b1lUhjZKdjtZHL4OfEVsNwsh
	 e0QAqMBlPZfVbBXAiwESvb68FeEXMquxaFmK1bsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0145/2651] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:23:05 +0100
Message-ID: <20261118150253.072674313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit aeedf85beac51c7cd8f7bf4c918a0104dfdb8b78 ]

Every value returned from of_clk_get() is supposed to be cleaned up
via clk_put() once not needed anymore.

Fixes: c1120542b99a ("microblaze: Add support for CCF")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260526184105.18962-4-grandmaster@al2klimov.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cpuinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index cd9b4450763b0..32c508e85408a 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -133,6 +133,7 @@ void __init setup_cpuinfo_clk(void)
 		cpuinfo.cpu_clock_freq = fcpu(cpu, "timebase-frequency");
 	} else {
 		cpuinfo.cpu_clock_freq = clk_get_rate(clk);
+		clk_put(clk);
 	}
 
 	if (!cpuinfo.cpu_clock_freq) {
-- 
2.53.0



