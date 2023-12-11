Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422B2C8C8;
	Mon, 11 Dec 2023 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyNAozVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF88DC433C7;
	Mon, 11 Dec 2023 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319595;
	bh=jBWgQCEBDdMu32Kw5Ju/5fllb5Sze/LzgUCrmbJyE00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyNAozVim7XwdhEhVNLLA89Ge2edJTl/vRrcJqJhM1zZGsTIDOJbhtOavHvSvYJEL
	 vXc2eWh8YV7XTgjG9x4ZpDRW3CVXX0QqFrq6dzcc0NXV3f7Ge5U23niMIEcyu+4Em7
	 SOSTTsnxukQilDGJp59AqwBViRMtWWB+vj2hWlPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 163/244] platform/surface: aggregator: fix recv_buf() return value
Date: Mon, 11 Dec 2023 19:20:56 +0100
Message-ID: <20231211182053.178174439@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit c8820c92caf0770bec976b01fa9e82bb993c5865 upstream.

Serdev recv_buf() callback is supposed to return the amount of bytes
consumed, therefore an int in between 0 and count.

Do not return negative number in case of issue, when
ssam_controller_receive_buf() returns ESHUTDOWN just returns 0, e.g. no
bytes consumed, this keep the exact same behavior as it was before.

This fixes a potential WARN in serdev-ttyport.c:ttyport_receive_buf().

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20231128194935.11350-1-francesco@dolcini.it
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/surface/aggregator/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/platform/surface/aggregator/core.c
+++ b/drivers/platform/surface/aggregator/core.c
@@ -231,9 +231,12 @@ static int ssam_receive_buf(struct serde
 			    size_t n)
 {
 	struct ssam_controller *ctrl;
+	int ret;
 
 	ctrl = serdev_device_get_drvdata(dev);
-	return ssam_controller_receive_buf(ctrl, buf, n);
+	ret = ssam_controller_receive_buf(ctrl, buf, n);
+
+	return ret < 0 ? 0 : ret;
 }
 
 static void ssam_write_wakeup(struct serdev_device *dev)


