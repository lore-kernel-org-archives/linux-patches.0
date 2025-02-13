Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6631414AD2D;
	Thu, 13 Feb 2025 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460096; cv=none; b=OVjfcxtt3VAbvoeUkBuwNdI/rlysbiYOrjjn+Lg6Bit4h+6H6CfDamMBMmQeolcuu/P5zWF4cbgWC/8KWLhcjXLjF8FDYLKQesIrsZrZ3gn5gAP61yvm4VOADzj19KL46V3TmJpBZInxq6gK5kRtrvyhPk8emjDFOIukovjjH4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460096; c=relaxed/simple;
	bh=wepWsbj4VwyY1ik1IDI08+UBH4/IBFY0Ag1AemuLn5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/g2yOE9BPrc5Su3/c2HGw+7XUDjaLnBerktuI755tMquPJdfATSYJvCzZtrN5bO8QABbO/16ERu3hGrPhjHmKr6kUPF3hINyJnimb6Z98TsE1aKwyowoLLrlPmGpF9YSDNodKixpIqfJ0JQQs029w6cXL2wFmdti6Q5tob9Y1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaDCnIqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaDCnIqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF846C4CED1;
	Thu, 13 Feb 2025 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460096;
	bh=wepWsbj4VwyY1ik1IDI08+UBH4/IBFY0Ag1AemuLn5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaDCnIqN/WbNGBoeV6XvfhcJFJ+SnMocCouBOFTjv4H9rCzf7vBXrOlZv3e+5Y6BM
	 uwLIrOqkhPMTkGs+xfLyTkKaIfmvhl1T83bG3aBclEhcu+KSDE2/+ST95wfo4CR+ye
	 qnC/jaB0ApfXi/o8zwZe9gTzHo54BaTGVXxKOtQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/273] drm/bridge: anx7625: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:26 +0100
Message-ID: <20250213142407.926144108@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e72bf423a60afd744d13e40ab2194044a3af5217 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-2-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 412c6575e87b7..ddf944651c55a 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2014,8 +2014,10 @@ static int anx7625_audio_get_eld(struct device *dev, void *data,
 		memset(buf, 0, len);
 	} else {
 		dev_dbg(dev, "audio copy eld\n");
+		mutex_lock(&ctx->connector->eld_mutex);
 		memcpy(buf, ctx->connector->eld,
 		       min(sizeof(ctx->connector->eld), len));
+		mutex_unlock(&ctx->connector->eld_mutex);
 	}
 
 	return 0;
-- 
2.39.5



