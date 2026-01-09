Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B784224D6;
	Fri,  9 Jan 2026 12:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961014; cv=none; b=p/63TZxAItKCwHmHoEOpmVkl9CeE6bHynIrzoxeMHVlqWduVi9ed2NuVfTDpZJqX5ZxW2pZhBhs64INUGzATmLsIrayA29GRRYtMdfA9JjTJIuv1BxDcjTuSv2kB5Ny5LXdHenQ9xWiRnon6KT4z5JRZ6A7FrFTOP7+GPLtDfS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961014; c=relaxed/simple;
	bh=uAIf1msWD76s/V+joocgxpzXGKPveNTQDtwIV89b3rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReMveBdI7C+m5Rvp0E/515kWcpgGJKs4Izf/iNyiHDptLlMmabaXNqUHam05tVqsB5CyU792kkclPVQ1pACHXJxuePE8qeksq4fVLeUWZj4UPODbiwbXb5Azr9aeXYTXkxUaIRhHGAOTBKQN6i3aRDf8sX4cIWq+phhu25+aoVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPTVQNUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPTVQNUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494ACC4CEF1;
	Fri,  9 Jan 2026 12:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961013;
	bh=uAIf1msWD76s/V+joocgxpzXGKPveNTQDtwIV89b3rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPTVQNUpJP/uxl/m8Tq2xES1Ssmtl/KTzQUz3v7+mt0pSpHl2CoSDfGpjTkdbJ6tg
	 CT29z1NYi8A7JIYLakOL4XbbW5/UypA9IDF/K5IjnA0To0IR37ABzMhHh2f3TG9G96
	 9mmcBHn8XpH9IMSM4Rk8k0jgV1Qqi3S3+HO/syLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 572/737] media: rc: st_rc: Fix reset control resource leak
Date: Fri,  9 Jan 2026 12:41:51 +0100
Message-ID: <20260109112155.518813148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -283,7 +283,7 @@ static int st_rc_probe(struct platform_d
 	else
 		rc_dev->rx_base = rc_dev->base;
 
-	rc_dev->rstc = reset_control_get_optional_exclusive(dev, NULL);
+	rc_dev->rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(rc_dev->rstc)) {
 		ret = PTR_ERR(rc_dev->rstc);
 		goto err;


