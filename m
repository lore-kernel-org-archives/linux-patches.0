Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8448462;
	Thu, 17 Apr 2025 18:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913800; cv=none; b=HXVcyNaf0JKTjLxJE6/kVrSaNsCuLMOgsSJHyWszfDzgcs0JjBqHBsSfFdF4OaL84zxHFVKcbkT0U1xy7dX0L0r39aow0fp30VKy07pX3k/7X0DRTRmcUj9LppL3ibLRVOV75beJKEZlfTaEag69V1jFCgZaLesJ1S1Dvv6O2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913800; c=relaxed/simple;
	bh=KvEQ7aDYFbyNOUbOQ1No+BzUnutu6x6eMBmcE8lDwzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8nnaTDjg1ncObGY0GGpeb6VFfYWc26IJHWgT44DhB7k/URDDxNhwqtzamCMFxxczrB0Os8NEXwNhMO6zbu+kpT+3/HhnVSDiF/TkwTJnrPAx7RO1mHNJeGSU4x8vjebkAgN7G93SobB4ZitzyGcRirxfUuCX/ZTkn+4y5G/a84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OII8oD/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OII8oD/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC85CC4CEE4;
	Thu, 17 Apr 2025 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913800;
	bh=KvEQ7aDYFbyNOUbOQ1No+BzUnutu6x6eMBmcE8lDwzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OII8oD/l036mugIukjboPkyE27QMwF8WLnYDhqrp2Jpu9r1f2A9KBdvVFHKJ7qTT5
	 oe01oz38EMF9MGahBoCaIlt+sgoI1S0iZGZJwGj5ph3zTf3zlw9WinNDTq52PaftaI
	 /V+u779KOuTyRs1KYpzU67VA9N57D974I9J73+Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.14 421/449] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Thu, 17 Apr 2025 19:51:49 +0200
Message-ID: <20250417175135.235101697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 962a2805e47b933876ba0e4c488d9e89ced2dd29 upstream.

In irq_of_parse_and_map(), refcount of device node @oirq.np was got
by successful of_irq_parse_one() invocation, but it does not put the
refcount before return, so causes @oirq.np refcount leakage.

Fix by putting @oirq.np refcount before return.

Fixes: e3873444990d ("of/irq: Move irq_of_parse_and_map() to common code")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-6-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -39,11 +39,15 @@
 unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 {
 	struct of_phandle_args oirq;
+	unsigned int ret;
 
 	if (of_irq_parse_one(dev, index, &oirq))
 		return 0;
 
-	return irq_create_of_mapping(&oirq);
+	ret = irq_create_of_mapping(&oirq);
+	of_node_put(oirq.np);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 


