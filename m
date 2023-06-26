Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498BEC8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C6DC433C8;
	Mon, 26 Jun 2023 18:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804564;
	bh=iWLEbjyzYrV+chiF0vHRz9H9W1XQXVsQUNJ/de8yI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7J7yyXzodMvBIsDeHkA/xhc7irSJX10se5mmaID48E855HbvByV7oVZ8lizeaq9c
	 DIJUvZs8luN+dUDwdUDnPu5sV+LA/jQa87wrgErEkpEe5Sl/qZQw+FWdh100EF0LC7
	 lhxccQiVo2OimVcNeJ3PhbkqAQJxtYuz9KBjlNDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 08/60] media: dvbdev: Fix memleak in dvb_register_device
Date: Mon, 26 Jun 2023 20:11:47 +0200
Message-ID: <20230626180739.897780657@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 167faadfcf9339088910e9e85a1b711fcbbef8e9 upstream.

When device_create() fails, dvbdev and dvbdevfops should
be freed just like when dvb_register_media_device() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -545,6 +545,9 @@ int dvb_register_device(struct dvb_adapt
 	if (IS_ERR(clsdev)) {
 		pr_err("%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
+		dvb_media_device_free(dvbdev);
+		kfree(dvbdevfops);
+		kfree(dvbdev);
 		return PTR_ERR(clsdev);
 	}
 	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",


