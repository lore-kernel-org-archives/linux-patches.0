Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83DB1F7545;
	Tue, 17 Dec 2024 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456689; cv=none; b=Y/yYvpzvvtzwENMWo6MyTHK1gazTsEOWD/BpzIMxN6yyWyavxRmI1j6sXPkcgOOYM4UTz+OWo+LgDHsV00cOan+dQ9a9+PK3XGb9n80KCuB6hTJizoDXwja9SjuMNg0UHmp2uHzHuXB+R4aGLedpE0q/NDrut/A51fNtA7oTNHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456689; c=relaxed/simple;
	bh=VHFeu48CeUqwwUuJ5xlHhJMTao7K/3eWVr6MC1njQEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPz/h0JfNPG8ICaSIQGjvWLwH78jwnKU5VLDR+IfyVd0nowFQ+fW9u51MxzUmxOtmZVfjGmIYy1atfpaTp1jd0wczyYAQ9AwXObMQcm2qQiXSDRWz51BB7w52Lv9DoWNXYcQrMd2dxhY8CCn+4gcMLUMQc5/G+KwYQ91twJM70A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndw4axNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndw4axNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61602C4CED3;
	Tue, 17 Dec 2024 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456689;
	bh=VHFeu48CeUqwwUuJ5xlHhJMTao7K/3eWVr6MC1njQEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndw4axNF74Z/N9rBW2ZRpli4ZKBEkE3HUnxS1/2xwFqgsXv1FMSO0lKxhih25iozI
	 m4HhIBX4GdXlcE9H0FKHxjUMapzM0ptysKjwmk0diGESkn3gOxDHpc/etFt0npXXQT
	 1d/3OnFdogMQeY0DPmpfUjdJQW06RuGqhdp4j/s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Yury Norov <yury.norov@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/172] net: mana: Fix memory leak in mana_gd_setup_irqs
Date: Tue, 17 Dec 2024 18:08:12 +0100
Message-ID: <20241217170551.979033749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit bb1e3eb57d2cc38951f9a9f1b8c298ced175798f ]

Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
doesn't free this temporary array in the success path.

This was caught by kmemleak.

Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Link: https://patch.msgid.link/20241209175751.287738-2-mlevitsk@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ca4ed58f1206..42076c90ce87 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1372,6 +1372,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	gc->max_num_msix = nvec;
 	gc->num_msix_usable = nvec;
 	cpus_read_unlock();
+	kfree(irqs);
 	return 0;
 
 free_irq:
-- 
2.39.5



