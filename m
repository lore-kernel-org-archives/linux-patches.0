Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99C1364E89;
	Tue,  6 Jan 2026 17:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722021; cv=none; b=RhZaXdmefbnNXmr770WvlawwFKqLREEEKiGFqGW5Zlg0Dc7ZGZXSXatJNjbkxP1PiM9j+HWJmn0gQ1Dwxs2fx5+RvAop/R2rBZcpeRvNMjw5OHaFiXq7IYpmVpNa46YFhefBb9Y1Chrj6K/1Tj2pUiwGgmYO9Cb/JJU+agM+3ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722021; c=relaxed/simple;
	bh=MjkhwzmADecJFBFrgKe20EiSuyX85L14oVtepKkopws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=folKq7wuTRgnqxYsSZngNWyW6WwTyaR6GU24wHIaJfn4fiC9iuQ1RK6dEMAdOLm/tZpF6ve5AtQ1Weefa92HQo4QJNAgZAaHt6t+Sl/n4nmnfo3qG0H/Kkn0pNbbFQHSAU84btVp6UraLBSetaJ+y0PbUW5DB3Rs1LsvGnI6La0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEI2pUNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEI2pUNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5506CC116C6;
	Tue,  6 Jan 2026 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722020;
	bh=MjkhwzmADecJFBFrgKe20EiSuyX85L14oVtepKkopws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEI2pUNrQdg7FeIPS2SLrxA1+QK2yciaNUCeYkmfJDWeRFMx5SQHeoT4oFhvG5O3X
	 9Ka9mFt3zP9nmyOt9tokMRCNcn0A/+C5CXiJ5B18sJ4wrzK9JxuYvDMQgSkeVhL6pV
	 A33TRs+61C+utzqpgoIHu2YEJMn9K3Uxa5JVPo9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 142/312] media: rc: st_rc: Fix reset control resource leak
Date: Tue,  6 Jan 2026 18:03:36 +0100
Message-ID: <20260106170552.979508019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit 1240abf4b71f632f0117b056e22488e4d9808938 upstream.

The driver calls reset_control_get_optional_exclusive() but never calls
reset_control_put() in error paths or in the remove function. This causes
a resource leak when probe fails after successfully acquiring the reset
control, or when the driver is unloaded.

Switch to devm_reset_control_get_optional_exclusive() to automatically
manage the reset control resource.

Fixes: a4b80242d046 ("media: st-rc: explicitly request exclusive reset control")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/st_rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -284,7 +284,7 @@ static int st_rc_probe(struct platform_d
 	else
 		rc_dev->rx_base = rc_dev->base;
 
-	rc_dev->rstc = reset_control_get_optional_exclusive(dev, NULL);
+	rc_dev->rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(rc_dev->rstc)) {
 		ret = PTR_ERR(rc_dev->rstc);
 		goto err;


