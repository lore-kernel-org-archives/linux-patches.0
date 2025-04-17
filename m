Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6170C256C61;
	Thu, 17 Apr 2025 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913667; cv=none; b=JhDVcngDbMKYRoYtyyfHwKSbXDatVhFqXbTRAUo/R3Af00BAS+EPQhmN655TOsd+HsxrU1sYqhVxCDEZsLIfzjgQGddMgZj3onsiJWKKAGpjOzOUbQ00/pGHhcc13k2p7sZ8I3EDrK18gWhTe6e/oRX+qWs7uHEYdV7PfyQ3ZX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913667; c=relaxed/simple;
	bh=Lakph9fYxWbiTKivdWjocYB26LCQCT3zHeIInoc+hwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8KokBrZAJSMsDPgMkiTi0WJbbS1MkZPvyVLX0ck3M62ZN0KsMA+WtXB4NVUWDw9IEEaQ7imKWU3vQ9F+i9RVmX0mHz8V4cdW1VD79vNVbtjDL1qM4cRvenquw7hxjGBe02UN5lCqBvEIRM3SSUbDJH3i2p76PWQ/dbhDjw7S+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6dbTgq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6dbTgq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B4DC4CEE7;
	Thu, 17 Apr 2025 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913667;
	bh=Lakph9fYxWbiTKivdWjocYB26LCQCT3zHeIInoc+hwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6dbTgq+LMjs/IlXqQlyXv9YM8nrD/iCQzp6gliCpHOA7Ggh3GMQLxBE7bz2ibGTd
	 QR1vVtukuy1YhUSkhOSw/GyfjnWmD9Ep0D0ZTHLXYJdlQxc+ooAbOE2La0h1iExz6P
	 gq/JmB0hgjPB3oogWJVGivtFXL1TIbg/zfhxvhl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.14 413/449] misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error
Date: Thu, 17 Apr 2025 19:51:41 +0200
Message-ID: <20250417175134.907745733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -258,6 +258,9 @@ fail:
 		break;
 	}
 
+	test->num_irqs = i;
+	pci_endpoint_test_release_irq(test);
+
 	return ret;
 }
 


