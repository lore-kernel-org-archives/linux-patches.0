Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EBE243964;
	Tue, 29 Apr 2025 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949054; cv=none; b=VA9/Ia1yrIYonQxlyGzewpxf7NHbm2GhwmMbtSmmDXgaPfPIchnuvxTNxKuR3sKb/2ZEyfbf/M+rngcgIZ8KrIru1avzrdM66NEiF5mqm3snvV/zKqvnt0zyIXsSZbVa2bfG+8TIWpJDa35W3R5wkvlVOi8jHu2ah018nfv0IY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949054; c=relaxed/simple;
	bh=jvnVXPGgWrFVZR1nqEVlYdqC7cAxQf05aSXdH3VYVrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bABcyawTYjraRPgF/rSn+SKV38tGzMDbBfpyVB/FmXnEY9dC64OhMSYpk85FiNHRW+qAbyeHATxxUOuPPGFetMPWlWDOaZIvSEDAgN/tgHPkxYo/yXKSEicFX86adB0EaK0ZCcJ/8t85JUaC1RbXWi4hil88xLUhQQupDEYDlTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFVGKKmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFVGKKmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6689CC4CEE3;
	Tue, 29 Apr 2025 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949053;
	bh=jvnVXPGgWrFVZR1nqEVlYdqC7cAxQf05aSXdH3VYVrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFVGKKmfeeWiKJmxqEIGvkEslsUvxDFa4TsXWB5wAKNFZSwlAf/lQ6hDkDp0r6Glz
	 63qAiPfaVRy+t0Of3AsCYy2Rl0pNtdY//At9WPCC65ZzJedzI3lTjW0A3pQ7aqypKZ
	 LYExqVX2mXlxhXiwBhHUA+oicxYB4l3bM6p0HveU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 5.15 200/373] misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error
Date: Tue, 29 Apr 2025 18:41:17 +0200
Message-ID: <20250429161131.395387437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,6 +262,9 @@ fail:
 		break;
 	}
 
+	test->num_irqs = i;
+	pci_endpoint_test_release_irq(test);
+
 	return false;
 }
 


