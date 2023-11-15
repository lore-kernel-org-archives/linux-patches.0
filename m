Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE98F364C8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4jRMpBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C643C433C7;
	Wed, 15 Nov 2023 19:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077823;
	bh=+9TmUekEk1EViBjY3zG7v9jvahxUUSiMGi7OMie4wMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4jRMpBYGWs2E0vOE5iWnb3Jw6EEoeAtyTojTR8k+ueGdBuhBpl10Jji3WNB3M4qw
	 0cpohJ/5L59wwjqkGidKSAf5IfiHOsi0S3hnhaw8l4ZqDrI5XdMW8eA2AxsEU6o3Os
	 yl61Db2uv+3NRS1uWv+no4TnjW3L+ndGKDQo2yBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 519/603] media: vidtv: mux: Add check and kfree for kstrdup
Date: Wed, 15 Nov 2023 14:17:44 -0500
Message-ID: <20231115191647.944228387@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 1fd6eb12642e0c32692924ff359c07de4b781d78 ]

Add check for the return value of kstrdup() and return the error
if it fails in order to avoid NULL pointer dereference.
Moreover, use kfree() in the later error handling in order to avoid
memory leak.

Fixes: c2f78f0cb294 ("media: vidtv: psi: add a Network Information Table (NIT)")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_mux.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_mux.c b/drivers/media/test-drivers/vidtv/vidtv_mux.c
index b51e6a3b8cbeb..f99878eff7ace 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_mux.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_mux.c
@@ -504,13 +504,16 @@ struct vidtv_mux *vidtv_mux_init(struct dvb_frontend *fe,
 	m->priv = args->priv;
 	m->network_id = args->network_id;
 	m->network_name = kstrdup(args->network_name, GFP_KERNEL);
+	if (!m->network_name)
+		goto free_mux_buf;
+
 	m->timing.current_jiffies = get_jiffies_64();
 
 	if (args->channels)
 		m->channels = args->channels;
 	else
 		if (vidtv_channels_init(m) < 0)
-			goto free_mux_buf;
+			goto free_mux_network_name;
 
 	/* will alloc data for pmt_sections after initializing pat */
 	if (vidtv_channel_si_init(m) < 0)
@@ -527,6 +530,8 @@ struct vidtv_mux *vidtv_mux_init(struct dvb_frontend *fe,
 	vidtv_channel_si_destroy(m);
 free_channels:
 	vidtv_channels_destroy(m);
+free_mux_network_name:
+	kfree(m->network_name);
 free_mux_buf:
 	vfree(m->mux_buf);
 free_mux:
-- 
2.42.0



