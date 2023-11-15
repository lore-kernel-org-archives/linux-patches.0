Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB7E2FC52
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAnv7uFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAFBC433C8;
	Wed, 15 Nov 2023 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077527;
	bh=MjJME/eE70tV1lCSpWJcPiY0JVWjG6Vdre3pHtlvur0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAnv7uFQBiro08GR58dlncg3K4bJYcS9feZeYylQLPvppf3v/NP1fo0ibdGxdMak5
	 3MC0+DjOkc9nBWqkqfVOppphY3J+BsFMTIyg5SZ2oNGEjFlIY4hSaScdh7tvyUamyP
	 iAk98vTy98bNxfKQkv32680DTnhoW7oPtEegodvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 358/603] ASoC: SOF: ipc4-topology: Use size_add() in call to struct_size()
Date: Wed, 15 Nov 2023 14:15:03 -0500
Message-ID: <20231115191638.303364115@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 3746284c233d5cf5f456400e61cd4a46a69c6e8c ]

If, for any reason, the open-coded arithmetic causes a wraparound,
the protection that `struct_size()` adds against potential integer
overflows is defeated. Fix this by hardening call to `struct_size()`
with `size_add()`.

Fixes: f9efae954905 ("ASoC: SOF: ipc4-topology: Add support for base config extension")
Signed-off-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/ZQSr15AYJpDpipg6@work
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 7cb63e6b24dc9..c9c1d2ec7af25 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -895,7 +895,8 @@ static int sof_ipc4_widget_setup_comp_process(struct snd_sof_widget *swidget)
 	if (process->init_config == SOF_IPC4_MODULE_INIT_CONFIG_TYPE_BASE_CFG_WITH_EXT) {
 		struct sof_ipc4_base_module_cfg_ext *base_cfg_ext;
 		u32 ext_size = struct_size(base_cfg_ext, pin_formats,
-						swidget->num_input_pins + swidget->num_output_pins);
+					   size_add(swidget->num_input_pins,
+						    swidget->num_output_pins));
 
 		base_cfg_ext = kzalloc(ext_size, GFP_KERNEL);
 		if (!base_cfg_ext) {
-- 
2.42.0



