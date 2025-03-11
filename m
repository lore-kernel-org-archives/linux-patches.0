Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1661F25F7AD;
	Tue, 11 Mar 2025 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707472; cv=none; b=GDZUMIH4aCxO0B76zfeYQyJqToFSpj3PaXo+JA5rrzroA6vIzpG+1xZIbewiOEm/T+8iMYid5Hceg7pY1dTlFiTdylpKHA/CE9K9xhpOvq+cSLQukIlQRreWvy3eB/XOR0BdGlZUaRuBO+jVYjTOML5aylh1aHqEdhhd9lBajpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707472; c=relaxed/simple;
	bh=xHjqa3T5RSCJKZO58yZ34KEnz79/whLo2k3csbg/zlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxrCvl7+d9xwLu77I5bqf12JkHqeE8VXLKL59Id+VtbZHFJyunWsPek99jzSAbrb7HzSdYrhJ1bzEYRNs0rVkUaFtWUkUbbL2LMwYQMcSWV7sHtqfr/QgFoM67GV6RcD/8KTkwCJQRZyvvd1E77tJYNAHVDkPZ04SC2uHco919M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USVIa57C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USVIa57C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F22C4AF09;
	Tue, 11 Mar 2025 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707472;
	bh=xHjqa3T5RSCJKZO58yZ34KEnz79/whLo2k3csbg/zlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USVIa57Cv2g4hvRF6Jet+wzNhwnq7anxbQ3TwqAZm4TinMJRZepMFZG97DsAREzn7
	 bHnzlPwwp804V6dJNQzQqnz1ThTW7pu+ZbgRGg7qd88tWxj7X8z0/K4aoAfhcIpDYf
	 mpkSleTduu6F4VxGBIeSY9PHZ2lBw5Zdj/1z3CDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 400/462] rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Tue, 11 Mar 2025 16:01:06 +0100
Message-ID: <20250311145814.137534586@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e842f9a1edf306bf36fe2a4d847a0b0d458770de upstream.

The return value of rio_add_net() should be checked.  If it fails,
put_device() should be called to free the memory and give up the reference
initialized in rio_add_net().

Link: https://lkml.kernel.org/r/20250227041131.3680761-1-haoxiang_li2024@163.com
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio-scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -871,7 +871,10 @@ static struct rio_net *rio_scan_alloc_ne
 		dev_set_name(&net->dev, "rnet_%d", net->id);
 		net->dev.parent = &mport->dev;
 		net->dev.release = rio_scan_release_dev;
-		rio_add_net(net);
+		if (rio_add_net(net)) {
+			put_device(&net->dev);
+			net = NULL;
+		}
 	}
 
 	return net;


