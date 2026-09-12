Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4142978C9C;
	Sat, 12 Sep 2026 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241314; cv=none; b=fEOAmhgjagxX3zRTSWnnk3/kH0mHxoGVfSp/WTdfgMhW5BIWiN0IAaZLVGgULynVeP8qlOr6WJe7VqKFtVwas0A4tTX68HZT4dvoYJzs1yd2I7LkcSUtca+zXwlAOQ5bKESsY0WoSG83dER0v8uszGUyVqSKXNDV/nN2NCpW9wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241314; c=relaxed/simple;
	bh=K4kEclMfGNG1Zhg6AjoLFQDrr90hI+CTVpUYRkvx6uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwwUOpd5qMq4vj9t+St92H6nBAesOtzezAxf2T8CwdbMzTPSF2a0/+/Kb5UjHncNepvQG7H46gchQaNv3MvtLQS203J4XAReOF/BdaCJNNS3646vDOvwMgtx6zCt9zt6w2mC/T+mMXFKoB5Shg37yRcopTbqdeR/4dwzfnBRjzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgH8P57X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgH8P57X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2181F000FF;
	Sat, 12 Sep 2026 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241312;
	bh=plDWXqS4omtVfOv7g/RRSZnazn7EKQVBjrFbEMyHIw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgH8P57X2bfP5lUbizsteZ2pTLJIlxhh3y2bjYMW24U8fuy8K3o/B8G/I2jyLu9kh
	 T/1Dg0BLS7itAB8EQGZ7CQq0LXyNzFlVJPCzwItVll/dF0e4/OaXr3mKMOgiprH19V
	 fKviI+oLk5D6Ie1MxhDbWRQ1YuQx6m/8rrDG7jzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 111/798] regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata
Date: Sat, 12 Sep 2026 08:55:39 +0200
Message-ID: <20260912065519.506594081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit 7c8cc25d8d86f9eb3979255935cfdc7d062ad746 upstream.

In max8998_pmic_dt_parse_pdata(), of_get_child_by_name() acquires a
reference on reg_np which is then stored in rdata->reg_node, transferring
ownership to the regulator data array. The subsequent of_node_put(reg_np)
at the end of the function releases the last matched regulator node's
reference, leaving rdata->reg_node as a dangling pointer for the last
entry.

Remove the spurious of_node_put(reg_np) call.

Cc: stable@vger.kernel.org
Fixes: 156f252857df ("drivers: regulator: add Maxim 8998 driver")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260626160326.54457-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max8998.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -611,7 +611,6 @@ static int max8998_pmic_dt_parse_pdata(s
 	}
 	pdata->num_regulators = rdata - pdata->regulators;
 
-	of_node_put(reg_np);
 	of_node_put(regulators_np);
 
 	ret = max8998_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);


