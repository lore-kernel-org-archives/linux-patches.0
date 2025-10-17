Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4F330B1D;
	Fri, 17 Oct 2025 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715750; cv=none; b=emou6QwqkKZjmKRzQHs1AjG/VNisSkQ6SooDliAz/3yYrmAL3vSlcThJV3xtF6Kba27svP7Fi+h0PIQ7AbWlfdjxCMfYjSm0bcah02RYMOKfWbgSpQ5R8tEOrV7oa9PG4owaxs3DLMk7DgPoY0EK2V4MItPPlaoQnqL1TEJd060=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715750; c=relaxed/simple;
	bh=/aUdL+2AV1gHbAoH3g5q8JpNs7ZF4edgjOLSRaO/QKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQYzFsNMdaw1dISgH/WLfpRKNKDjKc+GHiWHCWO/wEJTvjw5wNbOpcQ0IeTTTJNGUX+0StS9WXlkEgGw8dntJUWUcelY/9Vi4GN9RQyt2TfHLyfMmj9xS/c67rIRz4MbMmyWK+BGEeoovSAZ8w5/Wqo3z42N1LZooSnRbP8m9Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oS5nTDNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oS5nTDNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06DBC4CEE7;
	Fri, 17 Oct 2025 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715750;
	bh=/aUdL+2AV1gHbAoH3g5q8JpNs7ZF4edgjOLSRaO/QKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS5nTDNn4LNf5SMeEAgmmpcIJe0hkrHWaw6koWkCaTA7pbsSSBtP4UHd4bDHgaWna
	 L6dGEchi5ssBuDcM7V4jBtEI6UHX+32lPfaKqIuUVcFxaH6YyZDT6eYU9GPrLxzKdZ
	 O2T+cNcJrnmI9LjijJBzCFo83t2nzil9h7ZIHoHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 324/371] media: iris: Call correct power off callback in cleanup path
Date: Fri, 17 Oct 2025 16:54:59 +0200
Message-ID: <20251017145213.799830149@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 2fbb823a0744665fe6015bd03d435bd334ccecf7 upstream.

Driver implements different callbacks for the power off controller
(.power_off_controller):

 - iris_vpu_power_off_controller,
 - iris_vpu33_power_off_controller,

The generic wrapper for handling power off - iris_vpu_power_off() -
calls them via 'iris_platform_data->vpu_ops', so shall the cleanup code
in iris_vpu_power_on().

This makes also sense if looking at caller of iris_vpu_power_on(), which
unwinds also with the wrapper calling respective platfortm code (unwinds
with iris_vpu_power_off()).

Otherwise power off sequence on the newer VPU3.3 in error path is not
complete.

Fixes: c69df5de4ac3 ("media: platform: qcom/iris: add power_off_controller to vpu_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu_common.c b/drivers/media/platform/qcom/iris/iris_vpu_common.c
index 268e45acaa7c..42a7c53ce48e 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -359,7 +359,7 @@ int iris_vpu_power_on(struct iris_core *core)
 	return 0;
 
 err_power_off_ctrl:
-	iris_vpu_power_off_controller(core);
+	core->iris_platform_data->vpu_ops->power_off_controller(core);
 err_unvote_icc:
 	iris_unset_icc_bw(core);
 err:
-- 
2.51.0



