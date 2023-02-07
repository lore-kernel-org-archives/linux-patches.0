Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C392CA7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83B0C4339B;
	Tue,  7 Feb 2023 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775276;
	bh=aeOOcVlDUq5dp+agrOXRkAlYcfRvAernryLhlWz8Hzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/FXOzZcEaMaor9izQiu6tKhR2BjPh0KuaFIgnQO594p06dm1FPn7rEXcweMYtMHM
	 8RVS+bma0Jg2GTTFY8y4vDZAX/ahR5aDtasbwqapMms/UTBiW0kibo1UVdnCs3jRHC
	 PxmhyuJdbE3Va9L4Adx7YunVdHaZP16aXvhGGjqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 195/208] ASoC: SOF: sof-audio: prepare_widgets: Check swidget for NULL on sink failure
Date: Tue,  7 Feb 2023 13:57:29 +0100
Message-Id: <20230207125643.321338758@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit fb4293600cc651cfe4d48ec489f1d175adf6e2f8 upstream.

If the swidget is NULL we skip the preparing of the widget and jump to
handle the sink path of the widget.
If the prepare fails in this case we would undo the prepare but the swidget
is NULL (we skipped the prepare for the widget).

To avoid NULL pointer dereference in this case we must check swidget
against NULL pointer once again.

Fixes: 0ad84b11f2f8 ("ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230120102125.30653-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -327,7 +327,8 @@ sink_prepare:
 			p->walking = false;
 			if (ret < 0) {
 				/* unprepare the source widget */
-				if (widget_ops[widget->id].ipc_unprepare && swidget->prepared) {
+				if (widget_ops[widget->id].ipc_unprepare &&
+				    swidget && swidget->prepared) {
 					widget_ops[widget->id].ipc_unprepare(swidget);
 					swidget->prepared = false;
 				}


