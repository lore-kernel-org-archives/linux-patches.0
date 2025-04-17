Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4261F1A3178;
	Thu, 17 Apr 2025 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913691; cv=none; b=ViwaoHljEk6/UaQjN4GXXKqRG8bAo9Y23CoX7Q0/vvlyOE8KIGwRgX5cm5PDBAfQf4dHF2m/bkqnaBDx+G4tsBUZOC8L+1E2Usp3KSlUhC372N+Oi3417kzpPadDmGWDuvZDBT+E2HEOTzd3wBQ6uq/aGFsXFVggDBOdALNgsQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913691; c=relaxed/simple;
	bh=cvDFnpFfWrD0tmWZEF+5AdSWp30TcNBI8PTRFZIQtEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY0+gEvxbgXSYA4h036hFVHHiXYd+1bQ4IbQdISM40Tir5bHw161kr7h6ohKh6hEMXa9izshtUA/9x1TkttEn/l1Zxbgtc/DSs8yY8YNkjjIMVQvBO8tDqILdF03/oRp6kBJPskNbRfaDI5tPt4mgGsB/5+CBQ3RhoTu6udKexA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTQRVMYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTQRVMYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC386C4CEE4;
	Thu, 17 Apr 2025 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913691;
	bh=cvDFnpFfWrD0tmWZEF+5AdSWp30TcNBI8PTRFZIQtEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTQRVMYV4YRLXPZXOPXypZAlnWxg7D1TM8XXvzESZq8QMt2RuBeWkwFV0Ayr/ZwKG
	 dtITohOLHL7FRw3JCwqbEqBUhhs3FRE/WoOeDCiOuFSlAGomMccFxS/VGLKc+X89Mf
	 iHoTMNBdFVKamCbzOx/sSKdfd5m9FXjeB5iC0on4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.14 420/449] of/irq: Fix device node refcount leakages in of_irq_count()
Date: Thu, 17 Apr 2025 19:51:48 +0200
Message-ID: <20250417175135.196121885@linuxfoundation.org>
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

commit bbf71f44aaf241d853759a71de7e7ebcdb89be3d upstream.

of_irq_count() invokes of_irq_parse_one() to count IRQs, and successful
invocation of the later will get device node @irq.np refcount, but the
former does not put the refcount before next iteration invocation, hence
causes device node refcount leakages.

Fix by putting @irq.np refcount before the next iteration invocation.

Fixes: 3da5278727a8 ("of/irq: Rework of_irq_count()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-5-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -508,8 +508,10 @@ int of_irq_count(struct device_node *dev
 	struct of_phandle_args irq;
 	int nr = 0;
 
-	while (of_irq_parse_one(dev, nr, &irq) == 0)
+	while (of_irq_parse_one(dev, nr, &irq) == 0) {
+		of_node_put(irq.np);
 		nr++;
+	}
 
 	return nr;
 }


