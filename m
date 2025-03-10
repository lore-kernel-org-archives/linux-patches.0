Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97A722E407;
	Mon, 10 Mar 2025 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627998; cv=none; b=koRMl/vUI4imbf/aipuPjf5a0di35iFr2elgVbPEmicSo4KhwHqRdm4nN1eGY8nPssePAKu+EtGIohAmhx96DJYNeej7HiWpHR0Ki23FbkCNhPR5YEp9YwC6sPxI4OCfYU8m2f4AC6eMU8p88tYYTGcBw0E+vDqiSCiNkOQBxwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627998; c=relaxed/simple;
	bh=EkkgAnYT5zOjIFxCcTWQpJW+WIGa9bXJIqGoh7YuEbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r52iW6IuG8G8Ld33FWbmbznvrZ8tY9WF46RujsqhZG6rCMO5hSY+5ufTMQI5TfAwH6Q4MOLBPvTSoR5npj956AfkGPF/58o83GfjgY+D96ZPghtfX+ZtsPVoHe1qUlm9yX3oNs8P29svct4zCwg7bPSvL09UD2tMCM0vQrV66QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaWOPF6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaWOPF6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627B5C4CEE5;
	Mon, 10 Mar 2025 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627998;
	bh=EkkgAnYT5zOjIFxCcTWQpJW+WIGa9bXJIqGoh7YuEbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaWOPF6rw6Xr1BTa3IWTAZ/6/nG4WE4m8cdQZDhi9aKlUzFgaLKoI5ueCgHRZDxf9
	 G7SF/rf8jP/8mh3RV8BkC8ymXlQg5pFXT7iru7Oj6WWIWoFOYdUxFYEvlBk6MXgcJv
	 QaUc6v1c6SM96qf2x+CBYod1C/nQlSnGVHmidi/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 052/145] rapidio: fix an API misues when rio_add_net() fails
Date: Mon, 10 Mar 2025 18:05:46 +0100
Message-ID: <20250310170436.838091212@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit b2ef51c74b0171fde7eb69b6152d3d2f743ef269 upstream.

rio_add_net() calls device_register() and fails when device_register()
fails.  Thus, put_device() should be used rather than kfree().  Add
"mport->net = NULL;" to avoid a use after free issue.

Link: https://lkml.kernel.org/r/20250227073409.3696854-1-haoxiang_li2024@163.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1740,7 +1740,8 @@ static int rio_mport_add_riodev(struct m
 		err = rio_add_net(net);
 		if (err) {
 			rmcd_debug(RDEV, "failed to register net, err=%d", err);
-			kfree(net);
+			put_device(&net->dev);
+			mport->net = NULL;
 			goto cleanup;
 		}
 	}


