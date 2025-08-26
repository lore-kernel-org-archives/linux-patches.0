Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC0352071;
	Tue, 26 Aug 2025 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218338; cv=none; b=C3eubm5d7+gWu1iV/a+rSuATuAw35QPr7k59pZ2b/V2YTR3zXkh+G1YKn7A7eHaTO6SFC3rfQb3G+0Pm8+s4JoLlDqtcDdDXABxa9PxpP9pyfLnBnTT26nY4CAA9rHHECN0Lny8/VN19fcUeqWCykr1P+kPY9egnxv3p8pzBHuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218338; c=relaxed/simple;
	bh=UHXDjpYFTj59MXY5mm8ncKlCeDBTXyVizshzBejTnHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eX7EljQE0h6C4D6aB+3NiMeVS0GcIof5ou9bC3UB0qIoacikw+mUf3dSNxjOC7Xju5DvFnBK1dbbjFCkFPr6iz11WsdNOAb7JMGNVr2hcLBhTwuiIvi1sL+AiL2GncsSLJHiFznXNu4b0O9fEvgNQLeIXg9JCA5PCjunH+gjthM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya5fUiEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya5fUiEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330ACC113CF;
	Tue, 26 Aug 2025 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218338;
	bh=UHXDjpYFTj59MXY5mm8ncKlCeDBTXyVizshzBejTnHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya5fUiEhYjzdNK5zqjb/eiSlrINVPLozHB20h+nHRLGtzYdU8MEXIzZiYhCdgb7k7
	 atqbTcIm5BcmtCbI8YRg9nAt4trWuOfMKGIsfmKhZS+3FFmwv/iW5gr1z2xpvuJ0HT
	 25DhIhXkUSJUIMSUf/POqdL+G8/x9tbVx/bvmSbM=
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
Subject: [PATCH 5.10 485/523] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:11:35 +0200
Message-ID: <20250826110936.410617860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1620,6 +1620,7 @@ void venus_hfi_destroy(struct venus_core
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


