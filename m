Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076191E3DF9;
	Tue,  3 Dec 2024 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242447; cv=none; b=jfBI7BUE6jjughJDzfdhZfiWfuPKCDazriguiSLptQiBUjipzE/2Ugq8CCxt6wjmcbC/AvyUpWx3C5eqGaOiNPBV3qAV+iOTynlbdqVua3dpykXWsjaArZc/VS4apLSTFWkg+ee9A4jkEnOFNNWZDRunNw9slHx6tem0gIZKzK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242447; c=relaxed/simple;
	bh=qYXXOGkp/7s+xvZMYO1702L9btVllvxbu7Tu0EMrS78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCHooNyotmfv0TpRkoKo8Cm/2MuEN/msn4cJHZg3yjzj1//I1jqNainl/rQ0t8UWLxwyqMa5lFlgsCc0gFMq/M/TcHlhLHa8ZGZM6DlgkiXdsMYJRXoB90hN/LCDDZzyUirrCkd0p/Mf1v1jPBS0vvgCCwwEVuSPnSA2m8E7A7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYJwGhv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYJwGhv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EFBC4CECF;
	Tue,  3 Dec 2024 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242446;
	bh=qYXXOGkp/7s+xvZMYO1702L9btVllvxbu7Tu0EMrS78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYJwGhv66VO10724EFzrI4VxcFyRWvzElz4snwjn1LW3Hf9aYrH8Ynh/E2nNqAz+C
	 FdhPO8Msmn90d+72/S/NMlwu2mVVlpl80aE+ipE1nxfDSEa1nweo8Nia8dPUI3vTWd
	 V9xBnCY38/KMtQb3s3qgzw/F9NcB30bDFSr0DTYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 706/826] irqchip/irq-mvebu-sei: Move misplaced select() callback to SEI CP domain
Date: Tue,  3 Dec 2024 15:47:13 +0100
Message-ID: <20241203144811.298593533@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 12aaf67584cf19dc84615b7aba272fe642c35b8b upstream.

Commit fbdf14e90ce4 ("irqchip/irq-mvebu-sei: Switch to MSI parent")
introduced in v6.11-rc1 broke Mavell Armada platforms (and possibly others)
by incorrectly switching irq-mvebu-sei to MSI parent.

In the above commit, msi_parent_ops is set for the sei->cp_domain, but
rather than adding a .select method to mvebu_sei_cp_domain_ops (which is
associated with sei->cp_domain), it was added to mvebu_sei_domain_ops which
is associated with sei->sei_domain, which doesn't have any
msi_parent_ops. This makes the call to msi_lib_irq_domain_select() always
fail.

This bug manifests itself with the following kernel messages on Armada 8040
based systems:

 platform f21e0000.interrupt-controller:interrupt-controller@50: deferred probe pending: (reason unknown)
 platform f41e0000.interrupt-controller:interrupt-controller@50: deferred probe pending: (reason unknown)

Move the select callback to mvebu_sei_cp_domain_ops to cure it.

Fixes: fbdf14e90ce4 ("irqchip/irq-mvebu-sei: Switch to MSI parent")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/E1tE6bh-004CmX-QU@rmk-PC.armlinux.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mvebu-sei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-mvebu-sei.c
+++ b/drivers/irqchip/irq-mvebu-sei.c
@@ -192,7 +192,6 @@ static void mvebu_sei_domain_free(struct
 }
 
 static const struct irq_domain_ops mvebu_sei_domain_ops = {
-	.select	= msi_lib_irq_domain_select,
 	.alloc	= mvebu_sei_domain_alloc,
 	.free	= mvebu_sei_domain_free,
 };
@@ -306,6 +305,7 @@ static void mvebu_sei_cp_domain_free(str
 }
 
 static const struct irq_domain_ops mvebu_sei_cp_domain_ops = {
+	.select	= msi_lib_irq_domain_select,
 	.alloc	= mvebu_sei_cp_domain_alloc,
 	.free	= mvebu_sei_cp_domain_free,
 };


