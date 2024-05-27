Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B596017727;
	Mon, 27 May 2024 19:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838563; cv=none; b=ZhIKxliT4ZOr9cnDZSYyO3DbDNC8XrGyglPN933Z0tq4/ViI5v0NJY+V+gSkMmvfklwUAcuabrN5YzF80l/rGqHk+f/UYJg16yznrH+FqeAt6pnLuNZSMog7RY/y65K73eamR0sJvpmva4fa+XSDAjcy5kHENs40hFqVirrJ+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838563; c=relaxed/simple;
	bh=vE2iBW+2k84cZU30eJ/of6MJ3sTcTsxk7TTN+bI3smg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3sdPvhlKjconvwgIaCks5ajDXyYrg9TCJHWKp9ZvkE/C7vBmccj7fenJl+4ymLbvHtY5WBQDLTUKNwpNR8KaGnJBm4XS4JlilP2anXxAiM1Wv/z0j6aH4lkUnFbASxQfpoKgh46FbW+4sltm5on/grNVdTg1Eg4w93b5MRLxAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzWg5cnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzWg5cnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5611C2BBFC;
	Mon, 27 May 2024 19:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838563;
	bh=vE2iBW+2k84cZU30eJ/of6MJ3sTcTsxk7TTN+bI3smg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzWg5cnc7aYC+pYXW2eJJ5j5eep9bWLBXWh3Gr5YWUPZOrdj39no0wTThqTftHm5s
	 0lGPeLtK5CmlkujYmraoSB1NWabEv2gicbeH4+jd8cvBsIYkKrLsRYgZg4cl9erXkG
	 hYA9hBX0cGBwaoi21NvHKETfXRcwovVNBOWdWSOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 401/493] drm/arm/malidp: fix a possible null pointer dereference
Date: Mon, 27 May 2024 20:56:43 +0200
Message-ID: <20240527185643.396012683@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit a1f95aede6285dba6dd036d907196f35ae3a11ea ]

In malidp_mw_connector_reset, new memory is allocated with kzalloc, but
no check is performed. In order to prevent null pointer dereferencing,
ensure that mw_state is checked before calling
__drm_atomic_helper_connector_reset.

Fixes: 8cbc5caf36ef ("drm: mali-dp: Add writeback connector")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240407063053.5481-1-qq810974084@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_mw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 626709bec6f5f..2577f0cef8fcd 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -72,7 +72,10 @@ static void malidp_mw_connector_reset(struct drm_connector *connector)
 		__drm_atomic_helper_connector_destroy_state(connector->state);
 
 	kfree(connector->state);
-	__drm_atomic_helper_connector_reset(connector, &mw_state->base);
+	connector->state = NULL;
+
+	if (mw_state)
+		__drm_atomic_helper_connector_reset(connector, &mw_state->base);
 }
 
 static enum drm_connector_status
-- 
2.43.0



