Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66822222C0;
	Thu, 13 Feb 2025 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457151; cv=none; b=F/+n97LbcNbGLPhi3SUr7b+gqH82LUT6P2Te+eDXkbS93+PO2dI+6iEp2vqtUuJnBVuSxA4sj/Ke1QbNydD6pcnGEh2Kgvp+d5XTFx1Qh9q+3SM0fNSvUUES8F+Bv56K/ztIqCq07LAPPcqwUBlhblazcjN+vmmTka8v8LR8XNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457151; c=relaxed/simple;
	bh=2H4PCNgqpR+rgJdZEeKOpE1phNcj1By6woK/F3akn4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDvvQ3vlOFDMNomfsHOayxTgR43xTbWYQbvxaOAXd3eJctdRGCCMBxRmvZFwqrTdKFS9eeMpuHmt5w2NdUUh1eKwqzsxrKboJmwwgLMDe6NJShJ507dDwPZ/vD+4rfoWI6zuih/C3K11f3U9ef/qHHtcwZJaCBR6zYRtBLgTMT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lede7fcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lede7fcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B254C4CEE8;
	Thu, 13 Feb 2025 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457151;
	bh=2H4PCNgqpR+rgJdZEeKOpE1phNcj1By6woK/F3akn4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lede7fcNRFi2+prPJMNIC759JZHNPVJqeDh2sSEdjX9UE0QnQrmcauxVaXDGRlu0Q
	 OZ106EbO4VxlucZ8U6K+A6opCEtSBLDirihA2ECa/Kru1hHpwIpINopSdKr0QXZ4v3
	 E0TsHXGCRW7MBnN16l2kAFZwPGZVdkvKwk6JX6bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/422] drm/amd/display: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:00 +0100
Message-ID: <20250213142437.757005069@linuxfoundation.org>
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

[ Upstream commit 819bee01eea06282d7bda17d46caf29cae4f6d84 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-4-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 08c58d0315de7..f35ec11086eaa 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1036,8 +1036,10 @@ static int amdgpu_dm_audio_component_get_eld(struct device *kdev, int port,
 			continue;
 
 		*enabled = true;
+		mutex_lock(&connector->eld_mutex);
 		ret = drm_eld_size(connector->eld);
 		memcpy(buf, connector->eld, min(max_bytes, ret));
+		mutex_unlock(&connector->eld_mutex);
 
 		break;
 	}
-- 
2.39.5



