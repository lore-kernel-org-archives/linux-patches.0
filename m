Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A1350D46;
	Tue, 26 Aug 2025 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219417; cv=none; b=pR4uBhUXb6ZnW7esQbFSCs3tDXLqi14VhLiDjU/qV/hWYUeiSnzuAlZDSbOya8irNg3e3gjbKOcO8zHt1jdA9BwTQP6cXvcJpAA2KpOmCUqVI2VCU8ZLSjBfWm00rCZ0J977s0Y+ZiSJfpYyFTHYEMOjxeuEjc5KbyYOmOK9ARc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219417; c=relaxed/simple;
	bh=J6zaCaLxDN2mID9zVUMdixePf0Twx3m5butJTvaMa/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIK4dt+o38tbRyzvW8LB8z3MzGhWYnQXFlgBNF/jH/6juxREjv8U63ifjMwy1WtycGyddbGZEPXo36ju9zXxcOdOq2WSjdHG6fS9pMr11YrfPJikDuFZF8YieC+rjCT275VAtMHAz98ruM+Tp0l0e9QdcGb6wyL7IhK8cOryJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Shw5+v8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Shw5+v8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3A9C4CEF1;
	Tue, 26 Aug 2025 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219416;
	bh=J6zaCaLxDN2mID9zVUMdixePf0Twx3m5butJTvaMa/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Shw5+v8xn9pcjS4ttQUcZB7RwQ48nHfhrfcWW9qAROqQUMPIZB0hi0WB3kqP1/Bfh
	 gYbFYgYYDMbzC7UbozQR2ZQoS3/FzFQ2+b32AS6kzqfPAluz6StDc3d0eXQMqOsjYX
	 c9QqgPWeHh5y2wBspZDMCCGmGvGd15XFgIpgQiwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 373/403] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:11:39 +0200
Message-ID: <20250826110917.321043179@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

[ Upstream commit 640803003cd903cea73dc6a86bf6963e238e2b3f ]

Ensure the IRQ is disabled - and all pending handlers completed - before
dismantling the interrupt routing and clearing related pointers.

This prevents any possibility of the interrupt triggering after the
handler context has been invalidated.

Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Cc: stable@vger.kernel.org
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Dikshita Agarwal <quic_dikshita@quicinc.com> # RB5
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1608,6 +1608,7 @@ void venus_hfi_destroy(struct venus_core
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
 	core->priv = NULL;
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


