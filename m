Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F1521D00E;
	Tue, 26 Aug 2025 11:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207422; cv=none; b=Ins07h32tibQfXhKnceUBCGkXAaQgU8yeVKLSxq9Qv6pfgN3Ji/nSekLEsD9n06TgNbp6TET2+ojWaVLi6xSGIOvUF8EKmieqSTbTSdtjU+kHC3JTK2pdSVood3BHZXoLRzNNjx8jOzxuq4y+lDKHgA/rKAxy755wqSpRjPpPtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207422; c=relaxed/simple;
	bh=7vnk67w4RqUh68D3mb7skYG0Lg9cIfJSNQFjsWs8p70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmkTedi8asRGU+fi8lClYK2izeBjYZKGf/zyVbMfxCiqCknLkSXbKA9/W/YF0AEMVEfjDzAgxDByvmKN2tbrt0Q0PVBdRHBEc6PyLg8PnNjnu4l7FtawdBNKzYG2zP2612LYNwNh6IWF0DdPbKGk59YBcqmfZPGT7l3faE0zv3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6xIGlcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6xIGlcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11073C4CEF1;
	Tue, 26 Aug 2025 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207422;
	bh=7vnk67w4RqUh68D3mb7skYG0Lg9cIfJSNQFjsWs8p70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6xIGlcGYo52eLjMRzsIdbAcyUalUrkZ5AqEjfzsk17vs4vST+2jsrm/vtvy7ql/D
	 ujT8bDHhycrw+4zAWhQ8IkU/tb5Dxz6oGAzDlwV1RhYfa/6sP3OMjyfHD7heTAYGch
	 R/kldRT+SHvvYy3qg+wuzt1x+dzMHZf3ufcMDbfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 148/457] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:07:12 +0200
Message-ID: <20250826110941.029914999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

commit 640803003cd903cea73dc6a86bf6963e238e2b3f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1682,6 +1682,7 @@ void venus_hfi_destroy(struct venus_core
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


