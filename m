Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E5D22E3E6;
	Thu, 17 Apr 2025 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913673; cv=none; b=c1Y2/dYYKLMQx9esvqZMEaB0rhlvK8fK/hwF3jTtF0GyAmoqUnDZ45kBOXX+ZMQSd1xoQA1Fa4y7PlwIaFk38zJSH+voF9CxrD3nZujB8ro+RVAC16ECiDespfrCvP8koU6WIFxE3xuR3Sb6e5Kwo5PxLkHrklUqDiEHinpcViQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913673; c=relaxed/simple;
	bh=/ELY6GlMKjmJeoFJw9cl3lsC8ixyExFRCllVoZ7WfgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIlon7ZobQo1rq64otBjgdXIURkeUYup90VVqXpgnR3JynYK779MwS/AOmfqeCM9zu7Cu5VMQOYXhH4FgdfALMQ3hMirt2njJsQLzOfYIzrpN9X+XMcsho6AQInqgATiDYUxLxH0KnbCLjwwMkqhb9YgDUXnknUk4twEHKBkVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIeKJYe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIeKJYe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6E6C4CEE4;
	Thu, 17 Apr 2025 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913673;
	bh=/ELY6GlMKjmJeoFJw9cl3lsC8ixyExFRCllVoZ7WfgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIeKJYe7eczIyz3Xl1PRWHdjGZWpTilVUtT7sLpQJ5xDnz1xwDXn5IdMW6KQ4u7zQ
	 yu9Z7uAkINMBz4suI+OP4ROFD1P7cdv8qeb1lUOilTZVKwXeoCyeLttbBJLwlzM7fi
	 iN30597l3V2Ft4oNLS5vkCP9rtUjTsp9QWVQm6V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.14 415/449] misc: pci_endpoint_test: Fix irq_type to convey the correct type
Date: Thu, 17 Apr 2025 19:51:43 +0200
Message-ID: <20250417175134.991515999@linuxfoundation.org>
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

commit baaef0a274cfb75f9b50eab3ef93205e604f662c upstream.

There are two variables that indicate the interrupt type to be used
in the next test execution, "irq_type" as global and "test->irq_type".

The global is referenced from pci_endpoint_test_get_irq() to preserve
the current type for ioctl(PCITEST_GET_IRQTYPE).

The type set in this function isn't reflected in the global "irq_type",
so ioctl(PCITEST_GET_IRQTYPE) returns the previous type.

As a result, the wrong type is displayed in old version of "pcitest"
as follows:

  - Result of running "pcitest -i 0"

      SET IRQ TYPE TO LEGACY:         OKAY

  - Result of running "pcitest -I"

      GET IRQ TYPE:           MSI

Whereas running the new version of "pcitest" in kselftest results in an
error as follows:

  #  RUN           pci_ep_basic.LEGACY_IRQ_TEST ...
  # pci_endpoint_test.c:104:LEGACY_IRQ_TEST:Expected 0 (0) == ret (1)
  # pci_endpoint_test.c:104:LEGACY_IRQ_TEST:Can't get Legacy IRQ type

Fix this issue by propagating the current type to the global "irq_type".

Fixes: b2ba9225e031 ("misc: pci_endpoint_test: Avoid using module parameter to determine irqtype")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250225110252.28866-5-hayashi.kunihiko@socionext.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -830,6 +830,7 @@ static int pci_endpoint_test_set_irq(str
 		return ret;
 	}
 
+	irq_type = test->irq_type;
 	return 0;
 }
 


