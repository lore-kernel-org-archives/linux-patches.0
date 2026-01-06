Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1565F3019BE;
	Tue,  6 Jan 2026 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720927; cv=none; b=b44h+B3AJKz1zYXN3ejTTRRH+8+VXaHP9vljqFYZIRjKtAIb/BL/6W5m1S6Kygqyio7meCqOkP2LZ8TPGMPecZBwowy1FVWzh6OWDlq8oBoErCyCU37iLIMP7/TnAlwGrZZ/dcCF0EdXjN9fXORocAuLxWiefHn7pwWYlkwMs50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720927; c=relaxed/simple;
	bh=i6O4UWBEX9nthptmSm3l+i3Eh9h4jbOrNvZHy89GBPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBmXyXyiIoe82UsPNvs5AU88Wiy4TWX1Zdh+5t9uxHIAYOgGVsEd7plj6wlCxWNxAeXv0Ilng172j5IHcXi0Fr52C+VuQfqhCTO0L9e0tOvDYXPuvCcU8fjHKNxBQa7dcRn4UeA+IU9Q2dcIY6lIlWB/jdE1UypreAmI35kPu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcRnaF5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcRnaF5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E7CC116C6;
	Tue,  6 Jan 2026 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720927;
	bh=i6O4UWBEX9nthptmSm3l+i3Eh9h4jbOrNvZHy89GBPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcRnaF5NMDDownrPjwEbYqfQHS7ygYpbkmXhlGjHQqjLFLnRHK3uwaVB91tkw4wKu
	 y/m2DCFClPRM7rmQ8fZVoFvUpa2q/+Z9os9qeM8SN+PEyThgyd8Bj1X6RptXnYRLpK
	 nUvnZfPCiVaMKndEo1bocHxTPOxK109biVN1GKYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 382/567] media: rc: st_rc: Fix reset control resource leak
Date: Tue,  6 Jan 2026 18:02:44 +0100
Message-ID: <20260106170505.473025671@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


