Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43A32550C2;
	Thu, 17 Apr 2025 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913961; cv=none; b=tEVNs7xFGR27AbeMGlX0pdPnaacK0iAw/hBxKq1z+WgqGTDq61U+LdXA2q4z+ajMllenj7szk/PCyWHp6yCtb+HsDn5uCW6KDuk8CfKVRVUoa/e4NPrxFAxSzVPETWB3ZlmQjzeprSrDsVBD4cvaZloXFDzb2RnFfsA7kt7Urm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913961; c=relaxed/simple;
	bh=dBP2u0AXKiOYMHBVlhy1F0EQu8orzZqHWx4T7YhnD1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3uptuIAKaVFGOTldwyTvM6xVDilqn/KAKBEmhGXeaS02tPDx5m/S/lmjKwGTFsHqhuZaDag+RjhYFHXbuc7/aguMx7fSGs2FBCcPwiBLyZ/jz3Jbff68p+AfgIFMLbRv2/3+KBc3PiF9GN6KhKUZSLly5KJCaBksC1dX8Rgsig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbkcDvI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbkcDvI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FB8C4CEE4;
	Thu, 17 Apr 2025 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913961;
	bh=dBP2u0AXKiOYMHBVlhy1F0EQu8orzZqHWx4T7YhnD1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbkcDvI14ZOQDwG/5F8LlJn4238GvlqtQXUD8Gxd/WFv3QTZg2Qnei345JDifcXUo
	 iYFtgsPWlE4XYfBVakD8Huw/3F5YW4cHutxxzJY+CwDwnfee6H8BBzW4XtUPWRg5nv
	 XYoQeXg7cXgMZ/9WhPg/fJVUUgJAK4CtBNdwS0Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/414] ASoC: SOF: topology: Use krealloc_array() to replace krealloc()
Date: Thu, 17 Apr 2025 19:46:58 +0200
Message-ID: <20250417175113.826382215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit a05143a8f713d9ae6abc41141dac52c66fca8b06 ]

Use krealloc_array() to replace krealloc() with multiplication.
krealloc_array() has multiply overflow check, which will be safer.

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20250117014343.451503-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index b3fca5fd87d68..37ca15cc5728c 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1269,8 +1269,8 @@ static int sof_widget_parse_tokens(struct snd_soc_component *scomp, struct snd_s
 			struct snd_sof_tuple *new_tuples;
 
 			num_tuples += token_list[object_token_list[i]].count * (num_sets - 1);
-			new_tuples = krealloc(swidget->tuples,
-					      sizeof(*new_tuples) * num_tuples, GFP_KERNEL);
+			new_tuples = krealloc_array(swidget->tuples,
+						    num_tuples, sizeof(*new_tuples), GFP_KERNEL);
 			if (!new_tuples) {
 				ret = -ENOMEM;
 				goto err;
-- 
2.39.5



