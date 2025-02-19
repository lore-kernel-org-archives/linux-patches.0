Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323DA1C548C;
	Wed, 19 Feb 2025 08:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954611; cv=none; b=Vv4vjiSj5Y9jLcm7i6SYqyjWhVLQvniN5DFSHsIacN4E9sRJ6Ue+GnFdsWCtPP3ElZ05a0UwMdVYsyzdMHy9YeQWgg1n67SU7IQd7jY2ioYtIsC+Tw5hzNALDxjAMZDIFoLv6DRFc0sXx15jBTcA9obJbP/UpbYM2BLnzsdMKHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954611; c=relaxed/simple;
	bh=7QgqcQdtcLKkM+OD6/CVt2O3/AsSdNBtQqW4S8KKPL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qA/Mv2+m9mMmjRXSLQxJocpGEqKdEmMZ1njdHEYMQsexaXINkr+ukwoUog0Z6QBefoJmAM5VdI/X2mmE8V3vEsC0jbD6aQLqFm5o4Ef+hqNaI9i2D8dgX1bbz8sKsrl+LhM8HEZ+QyQu8Y94qRH1oy+RoAjTqXFR8Fp1yLT4/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dcpQ3pW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dcpQ3pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B24C4CED1;
	Wed, 19 Feb 2025 08:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954611;
	bh=7QgqcQdtcLKkM+OD6/CVt2O3/AsSdNBtQqW4S8KKPL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dcpQ3pWB6CmtYF6KSDvbBAUViwtLMpMbcyTCIbBe+6qByq4PECwjrIeii/DGHizm
	 IvIzHf/6K0a0pC7wiTLLwe9//IPyf73CsbQihDMfKJW46id6GmIYX0P30msnwPwMgN
	 dFueEL6r+wNkAoUSOHPKafoJALM3Jm3m+nVBphX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Lausen <leonard@lausen.nl>,
	=?UTF-8?q?Gy=C3=B6rgy=20Kurucz?= <me@kuruczgy.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>
Subject: [PATCH 6.13 258/274] drm/msm/dpu1: dont choke on disabling the writeback connector
Date: Wed, 19 Feb 2025 09:28:32 +0100
Message-ID: <20250219082619.679843492@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit d9f55e2abfb933818c772eba659a9b7ab28a44d0 upstream.

During suspend/resume process all connectors are explicitly disabled and
then reenabled. However resume fails because of the connector_status check:

[dpu error]connector not connected 3
[drm:drm_mode_config_helper_resume [drm_kms_helper]] *ERROR* Failed to resume (-22)

It doesn't make sense to check for the Writeback connected status (and
other drivers don't perform such check), so drop the check.

It wasn't a problem before the commit 71174f362d67 ("drm/msm/dpu: move
writeback's atomic_check to dpu_writeback.c"), since encoder's
atomic_check() is called under a different conditions that the
connector's atomic_check() (e.g. it is not called if there is no
connected CRTC or if the corresponding connector is not a part of the
new state).

Fixes: 71174f362d67 ("drm/msm/dpu: move writeback's atomic_check to dpu_writeback.c")
Cc: stable@vger.kernel.org
Reported-by: Leonard Lausen <leonard@lausen.nl>
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/57
Tested-by: Leonard Lausen <leonard@lausen.nl> # on sc7180 lazor
Tested-by: György Kurucz <me@kuruczgy.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # Trogdor (sc7180)
Patchwork: https://patchwork.freedesktop.org/patch/627828/
Link: https://lore.kernel.org/r/20241209-dpu-fix-wb-v4-1-7fe93059f9e0@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
@@ -42,9 +42,6 @@ static int dpu_wb_conn_atomic_check(stru
 	if (!conn_state || !conn_state->connector) {
 		DPU_ERROR("invalid connector state\n");
 		return -EINVAL;
-	} else if (conn_state->connector->status != connector_status_connected) {
-		DPU_ERROR("connector not connected %d\n", conn_state->connector->status);
-		return -EINVAL;
 	}
 
 	crtc = conn_state->crtc;


