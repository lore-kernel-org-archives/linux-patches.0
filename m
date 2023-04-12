Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944182F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19581C433D2;
	Wed, 12 Apr 2023 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289514;
	bh=H1qmMxjG+fUZjN1Cp4bxsMl1HtKmBvjX7IbzJvHyxWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMrIuzo/W3NuxlwtFJy74TJMIXiE6f5kRxGQL0QxPp2SAQQCs1WEnh5Zmvou3bJFz
	 n/KZ0C267+u7ZEUCp73kiQ74ROGC2KshR54XNWB+d4q9osWedDvFo/M0Q9VPg8daQ/
	 3jmGteoBMmadFd6TtIcdcyeSLEuMS0Sf5IKZBLdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 129/173] ASoC: SOF: avoid a NULL dereference with unsupported widgets
Date: Wed, 12 Apr 2023 10:34:15 +0200
Message-Id: <20230412082843.361858470@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

commit e3720f92e0237921da537e47a0b24e27899203f8 upstream.

If an IPC4 topology contains an unsupported widget, its .module_info
field won't be set, then sof_ipc4_route_setup() will cause a kernel
Oops trying to dereference it. Add a check for such cases.

Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230329113828.28562-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1686,6 +1686,14 @@ static int sof_ipc4_route_setup(struct s
 	u32 header, extension;
 	int ret;
 
+	if (!src_fw_module || !sink_fw_module) {
+		/* The NULL module will print as "(efault)" */
+		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
+			src_fw_module->man4_module_entry.name,
+			sink_fw_module->man4_module_entry.name);
+		return -ENODEV;
+	}
+
 	sroute->src_queue_id = sof_ipc4_get_queue_id(src_widget, sink_widget,
 						     SOF_PIN_TYPE_SOURCE);
 	if (sroute->src_queue_id < 0) {


