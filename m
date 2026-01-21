Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4DC366DD8;
	Wed, 21 Jan 2026 18:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020049; cv=none; b=ScaR0HVgTVLtpWYOxvGacle67d5NQ8UEx7XfyrAqmKIkgkUYVju4rhQ5XLsHOj5YS9kEayB/VWjJb7XUw/WX37klYi0nrfNG073KTI/sQjsugNP5XwJYgex8G0H+2bOaQnXmEJ+jzPe8wGoVDycjJw7IcYSnLHgL3Zva4YGukq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020049; c=relaxed/simple;
	bh=dbHDXAwvMSdfVtUeojMEMzdq9A2x9jSdMRszva18rnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6vPMnao6AiAIhs51nVF96OvrhkVhLwwpax1kf1LeYaF/NlFYbFuk0JOBUCcZxKBOeMnFC+wVRbMG0z+Cyk2B2sx7541kj7QLWTfz2v9d6afYDt+cwg4pVI+SQJQCP3vTGIKYcyxw5QpoJ6Kp1jslAhkcAhMdtgICwH8LcM2y2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbqEY4Ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbqEY4Ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A996C4CEF1;
	Wed, 21 Jan 2026 18:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020048;
	bh=dbHDXAwvMSdfVtUeojMEMzdq9A2x9jSdMRszva18rnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbqEY4ArpNVCoe7inV+prtmOjnPSm7W/5NgyGBS//NFJkd7TxIzSm6x2gyYNmG4kF
	 iTljRjPLe0qus0ZZnFuKxrpjZrVF08/0221I54g4/pNQaNwhEIvq3NwQVPWQZRrx+3
	 0EERbIMgIUXAdqp8IhJ4UwvFq1Q0KBBYGtWQC2KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/198] net: octeon_ep_vf: fix free_irq dev_id mismatch in IRQ rollback
Date: Wed, 21 Jan 2026 19:14:33 +0100
Message-ID: <20260121181420.172703702@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit f93fc5d12d69012788f82151bee55fce937e1432 ]

octep_vf_request_irqs() requests MSI-X queue IRQs with dev_id set to
ioq_vector. If request_irq() fails part-way, the rollback loop calls
free_irq() with dev_id set to 'oct', which does not match the original
dev_id and may leave the irqaction registered.

This can keep IRQ handlers alive while ioq_vector is later freed during
unwind/teardown, leading to a use-after-free or crash when an interrupt
fires.

Fix the error path to free IRQs with the same ioq_vector dev_id used
during request_irq().

Fixes: 1cd3b407977c ("octeon_ep_vf: add Tx/Rx processing and interrupt support")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Link: https://patch.msgid.link/20260108164256.1749-2-qikeyu2017@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 420c3f4cf7417..1d9760b4b8f47 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -218,7 +218,7 @@ static int octep_vf_request_irqs(struct octep_vf_device *oct)
 ioq_irq_err:
 	while (i) {
 		--i;
-		free_irq(oct->msix_entries[i].vector, oct);
+		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
 	}
 	return -1;
 }
-- 
2.51.0



