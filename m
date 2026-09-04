Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFA83451AB;
	Fri,  4 Sep 2026 06:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501756; cv=none; b=YM0GM7kq9u5LHkKYsZMdOmYa/ciTjBZLXsDlaDUy/6nYj+SBCev1WAoMnrNYklsPJaB0l3saGTTv+JzlhKLtSHQBfCha1bC5Y5hbAI6be2SWKl7MnJDdk+uprSiSU/NmL6s0X3E/Sk66iZh4iWmnGO94zkWNzQJis/HcQLg/TQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501756; c=relaxed/simple;
	bh=ckp2vV2IbXMHxPC78j/3YiwKjV/BSy9RFXmAIrxElBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNmPy9s29Dp+dFuzo+sL0llgf/ZRI9DJ5tzG1dJb0BvR9J6LBBy2Mn4PWzkFmdOS3mSPdI25WxnicOLYoOREe9Cc78qiBSNGjZZDi6uQlSq/Ru0Rw+kjPcQTZ3mZFlxNkqQ8e463oBunySfFBWjcMvtFpgzvsmuxSZic211e/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8gN7J6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8gN7J6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695DD1F00A3D;
	Fri,  4 Sep 2026 06:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501755;
	bh=efANy5+hqrJAMSewJgs+f2iMQJR2o8OHPFRmOes91nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8gN7J6resnbrx1gmmxL0cEv8eq08QsJA6FaAqI/xeXvZ/njzQy6JxI6Cr3eOHP9n
	 JMT7CCBCiZ6ej1Yk9c7rjCXa4SuVpgx6hvSXJkXohhxza0O+oVyTJGN7wM5q00VtnT
	 Jnh3mEHCMunn6Sy0mTzsk3B0truZYbm2R1/8ahz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 520/552] i3c: renesas: Clean DATBAS register on detach
Date: Fri,  4 Sep 2026 07:01:17 +0200
Message-ID: <20260904045802.418535393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 797ed83c0cd495be4b345750c59e0363bf4d6207 upstream.

The controller uses DATBAS registers on TX/RX logic. Clean the DATBAS
register for the detached I3C device to avoid issues.

Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-8-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -906,6 +906,8 @@ static void renesas_i3c_detach_i3c_dev(s
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct renesas_i3c *i3c = to_renesas_i3c(m);
 
+	renesas_writel(i3c->regs, DATBAS(data->index), 0);
+
 	i3c_dev_set_master_data(dev, NULL);
 	i3c->addrs[data->index] = 0;
 	i3c->free_pos |= BIT(data->index);


