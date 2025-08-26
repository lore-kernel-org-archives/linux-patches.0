Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3339A196C7C;
	Tue, 26 Aug 2025 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213684; cv=none; b=o/tSMVlxzf1VbHfIFagrRLQD2wVFO2WomFdgKgzf8Pmf/fw3UVvNjpwbOmr/e+gNASaP9SO/5TI9rZyzJt3fbAjF/33YX88I7LQn1yRbq6WnMI+tjuw8EWmc9kkjdH7qKOlHvXo8dU8TjdAE46ZjmV7JJKyRkvROcoTaKqK7BB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213684; c=relaxed/simple;
	bh=+KerZY5bc6x4MIu0m/uL7jUyry1HSnaGur+uJDomP0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+uyARicdDj63M03F4OpuSpNOYpI9lpyox7QwMYCJ7pF8HOio+z3NvalrGJGbXoxb6nq1935/2kLEVAomrjGG/uy6p7BP236OxDVDXOFvXrFRBXYgHZa+yU45fWQ5wWLUhWPU4Lp3GP1LCGOd4pCFdUHrBs+0R0+IoYTGlCF724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMENdrAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMENdrAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8A5C4CEF1;
	Tue, 26 Aug 2025 13:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213683;
	bh=+KerZY5bc6x4MIu0m/uL7jUyry1HSnaGur+uJDomP0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMENdrAgx9nMMWDoFjg+yGaDVDUJeMvZmvaw4dvMNqbKn/MzeazUdowQOOs1EzK1a
	 ndGhmOveYY8QLiHbQGU0KEzRGSXbRT8OgLID7dbaric9w1J4DvkdCS4aPyEWfE1CVd
	 OD3TU7YAGoVg5Q/V4dMr63biqVr3GQkYJHMmlq0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 413/587] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:09:22 +0200
Message-ID: <20250826111003.441559563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
@@ -1693,6 +1693,7 @@ void venus_hfi_destroy(struct venus_core
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


