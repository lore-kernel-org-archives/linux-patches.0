Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E8A1DE2B5;
	Wed, 19 Feb 2025 09:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957549; cv=none; b=DLF1ntXOpPWQF/hgCitZ2U9hQoMKag+E9sPWjPGYk3q7IDfVt2BomL7GXDPemQ09Ps9ZJwsgTOairpfWXEjSMdX+N4nGnII8PjVEtEcrsuOWtFG7ZbggqbcAqxGF6rKG1eRylu2azQQFMpm+s/nYxxoK50eCebB5FYRLIjoGg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957549; c=relaxed/simple;
	bh=aKCT4wrgd1gNusgL/bk1ar8b3XXDg87BmFYJpbEBvso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkKMJavD8PxZ6yXUz+NtnGazQcLEWZncmL37DrebkZTRPgpuC3gl86StdFZwXG3KH9h+M0qQxuPMCkQwfWy/2S6vqHjm5e/BZaD8EViNQChgg3ntmKwCKPok0YyPDtnsyJB8bmGbM4XR7kXnnsPXC+sooGEe9uh2FRsIBFkn6DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPL9TKAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPL9TKAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223E6C4CED1;
	Wed, 19 Feb 2025 09:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957549;
	bh=aKCT4wrgd1gNusgL/bk1ar8b3XXDg87BmFYJpbEBvso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPL9TKArjexcIHhaPVAmMZiuAZWVq/3+Nhwj5NfExFHNRaxrFCSAQ22carKXhkmV4
	 OGvsTLmiaPw97sfeJxWjsM0rE4dAc2cJgpUWIiLPYZ8ovzZ1rALXYtxzSmXH8e+fDo
	 avRF7un2KoIocPPYDY5uVgCSQGeBN6cBmWWh5kp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 565/578] i3c: master: cdns: Fix use after free vulnerability in cdns_i3c_master Driver Due to Race Condition
Date: Wed, 19 Feb 2025 09:29:29 +0100
Message-ID: <20250219082715.186471230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

commit 609366e7a06d035990df78f1562291c3bf0d4a12 upstream.

In the cdns_i3c_master_probe function, &master->hj_work is bound with
cdns_i3c_master_hj. And cdns_i3c_master_interrupt can call
cnds_i3c_master_demux_ibis function to start the work.

If we remove the module which will call cdns_i3c_master_remove to
make cleanup, it will free master->base through i3c_master_unregister
while the work mentioned above will be used. The sequence of operations
that may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                     | cdns_i3c_master_hj
cdns_i3c_master_remove               |
i3c_master_unregister(&master->base) |
device_unregister(&master->dev)      |
device_release                       |
//free master->base                  |
                                     | i3c_master_do_daa(&master->base)
                                     | //use master->base

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in cdns_i3c_master_remove.

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Link: https://lore.kernel.org/r/20240911153544.848398-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/i3c-master-cdns.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -1667,6 +1667,7 @@ static int cdns_i3c_master_remove(struct
 {
 	struct cdns_i3c_master *master = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&master->hj_work);
 	i3c_master_unregister(&master->base);
 
 	clk_disable_unprepare(master->sysclk);


