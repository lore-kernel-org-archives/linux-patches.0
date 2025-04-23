Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF4E2836A4;
	Wed, 23 Apr 2025 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421202; cv=none; b=LV0dITISAk2CdlkPCePs6D6qh1QepYm+kWX38AMaLeOJRffjcfzddRPr1yjYQLfuzaWHp33mypOToG1UWGB9a2mmqBSYMKQ2w2x9JpCFMo7rhfjYVo8I/QsyQMODFeefm/j0Z9gecNziv1l/wpZTlYmJowZtkfJLZg6PPQxWPCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421202; c=relaxed/simple;
	bh=Res+6Spr1NR3gcGRxFUpEOXFel2mErs9elgTOAlpalY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ex0pluC95PxoS+t4yDmuL6fEth+9RFhlffZmRPf0aW/NtXyfveCa1WW2KSgoHtxbO8+Z8lfj5V2SvSKBF/Yjbrm2wclU3Y0IzCsNee2luaDFwFvt8z4HRfqu4ektB+QME4sBTJWWZhaaBLUzX3bYGZqeRWgIfiYycQmjGc0ORzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFIllbT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFIllbT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A456FC4CEE2;
	Wed, 23 Apr 2025 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421202;
	bh=Res+6Spr1NR3gcGRxFUpEOXFel2mErs9elgTOAlpalY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFIllbT43WYgtQsnLsKadUfgZ6pUalikqCsLJFeAzUfgfJd/EfoKz7HlWuQQgXv8P
	 kwgeq0zx1QlZCcw+I/Q/R5582O8TeezgU7P6d6X1qy5Y9Erff6/EBiBIJxLnggD/rw
	 oaE/eod3UnwwpdbrOtkbGqHuEolZkWmCcj3gnT9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 200/223] misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error
Date: Wed, 23 Apr 2025 16:44:32 +0200
Message-ID: <20250423142625.317089491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit f6cb7828c8e17520d4f5afb416515d3fae1af9a9 upstream.

After devm_request_irq() fails with error in pci_endpoint_test_request_irq(),
the pci_endpoint_test_free_irq_vectors() is called assuming that all IRQs
have been released.

However, some requested IRQs remain unreleased, so there are still
/proc/irq/* entries remaining, and this results in WARN() with the
following message:

  remove_proc_entry: removing non-empty directory 'irq/30', leaking at least 'pci-endpoint-test.0'
  WARNING: CPU: 0 PID: 202 at fs/proc/generic.c:719 remove_proc_entry +0x190/0x19c

To solve this issue, set the number of remaining IRQs to test->num_irqs,
and release IRQs in advance by calling pci_endpoint_test_release_irq().

Cc: stable@vger.kernel.org
Fixes: e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20250225110252.28866-3-hayashi.kunihiko@socionext.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -251,6 +251,9 @@ fail:
 		break;
 	}
 
+	test->num_irqs = i;
+	pci_endpoint_test_release_irq(test);
+
 	return false;
 }
 


