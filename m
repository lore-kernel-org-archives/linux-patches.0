Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59D1221571;
	Thu, 13 Feb 2025 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457149; cv=none; b=oGT8tmJYPeeTSMW9JGBfZ1wH+oDGVr1gsiYTKiWFCd3klPZsTzmqYCo3qeNmpoAupdU+VYgSNDWPZx22x/EXk5TYTCfwHXUcNLjMLxfUBN6JLrWrK5hMJUvjG0G+PMykSzuIcG4AJk1gXUZSmlFQhtLyFrSKm952Y3SK3tyNlBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457149; c=relaxed/simple;
	bh=IrHxXXz5SmKsl3tcE3Vi7aZHmRn43RUp0sJQ7KwLOHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqLuGe8EKnfp2rBvPMx9Yg7UoTTGmPlkrhwEiBg1TCI0OngotS9gWqfSv6aYdJbi11C+hMr61BPwhZKX7VHlGbCfPEAez+tM/zTDyKA2NjmHrFU/CXM2qmUd+nFUWHmmXNw7oMMqFdHTrKPoDnW7TFwa/BIPlkMavXYT+FOy6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agVWJYch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agVWJYch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F55C4CED1;
	Thu, 13 Feb 2025 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457148;
	bh=IrHxXXz5SmKsl3tcE3Vi7aZHmRn43RUp0sJQ7KwLOHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agVWJYchaHbeC62MWQAMSBvpCqb45Xw3hhgP47cRV+qTOCSxUQ7R+4nfbwzfPeM2v
	 DqybSEI7Prq/lxs5l1uy+gb4zoaAb9P8st3DsfpZ8T9KuHs/Fkppbiw/64D8fSfzxR
	 E/ZfEPcnp0KMSvHNH+97DRJHr6hWxhnAbNnA4QFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/422] drm/bridge: ite-it66121: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:22:59 +0100
Message-ID: <20250213142437.718331992@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 39ead6e02ea7d19b421e9d42299d4293fed3064e ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-3-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 925e42f46cd87..0f8d3ab30daa6 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -1452,8 +1452,10 @@ static int it66121_audio_get_eld(struct device *dev, void *data,
 		dev_dbg(dev, "No connector present, passing empty EDID data");
 		memset(buf, 0, len);
 	} else {
+		mutex_lock(&ctx->connector->eld_mutex);
 		memcpy(buf, ctx->connector->eld,
 		       min(sizeof(ctx->connector->eld), len));
+		mutex_unlock(&ctx->connector->eld_mutex);
 	}
 	mutex_unlock(&ctx->lock);
 
-- 
2.39.5



