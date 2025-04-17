Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32AD2566D3;
	Thu, 17 Apr 2025 17:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912708; cv=none; b=GkEQfrK70jrTtBgJyxStep8l1+B0ruLe/Wh5iTZO3k7r2JqK9hI7uU+DRI7JR9u7t6wa6ZaX/Aj0nKbTB8Ule//AGvYyHOefAWHiV7DRbmxLmYAt2tetA/Ew/+BHZDoeW9KyXgER+5yU2+n66ymszyQuABoOLoxAX48gcF3sKzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912708; c=relaxed/simple;
	bh=mnl/8V2lL2j4Zrfe+4hMmKDg1GWsfxR020MCs6S7Q2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4+cea1iMgQMQ4c+XiOmkuYGbSjNCzVoXRNgmzv4XE7PYKo3QgJxhYOQ7RMwunHwAC75TNv7arDhdHNJrw7hOkkK5IRxiZCnl0gCVSyld7hed/qH9mt+pt57eF/bHH9j8RxhtFuFCGQlxXFBhaqKi+byLHh4gnjxRkRHnidTgko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtwP+1r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtwP+1r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20753C4CEE4;
	Thu, 17 Apr 2025 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912708;
	bh=mnl/8V2lL2j4Zrfe+4hMmKDg1GWsfxR020MCs6S7Q2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtwP+1r8DsbSJrxe2ajDYeTqyV29Ic6o7XeXlPfMPhbk8k8TGEQsl+BCpfUTIZbAV
	 roTAJv0od4tKaGTHyN68uVxFYULIQcO9QfMUYq4peQh5cPBUqSzNjxpVvnGUy/m+ii
	 oO4hG/MQJjzL8gwsDFULvkdZmNVkVzaDhQ213x/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 069/449] ASoC: SOF: topology: Use krealloc_array() to replace krealloc()
Date: Thu, 17 Apr 2025 19:45:57 +0200
Message-ID: <20250417175120.759220604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 688cc7ac17148..dc9cb83240678 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1273,8 +1273,8 @@ static int sof_widget_parse_tokens(struct snd_soc_component *scomp, struct snd_s
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



