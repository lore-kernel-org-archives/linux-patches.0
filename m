Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879A51A4AAA;
	Mon, 23 Dec 2024 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970854; cv=none; b=hOPR7+U5z3eg6CzxuOp5+G8mFD6+w8VZrezD2M5h3cKN60pB2+pcC9gaElzW/enfoFvmEpIHinMLxcWYm7qLofehZ+hEh7sy07rZivDBOaidp6EHrIGKxkeFVPYfBzD4X1HO2R7MWJn1mVpjDyGQaQBAizJCbIYpfo3VBE2gJdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970854; c=relaxed/simple;
	bh=mOOfnfOi3y79is3Tp3jXjPf4KMKWF9uz+QZLIHsWHcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGFlT2qKJ7PLW1//qMPpH7LSaacupiy9EAtlj5E64HY5Lhvqmtv0kmYOnptuuV/qFRcSghWIQ/l11EDjKziCUFugIslopRM4Kyz6jqXc64sdRlcLC9izKPelQb/VwFEs9wm6f+t6IudnXvAqDzkEK99jv0WcqJCgprFSjtshT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNAbTsRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNAbTsRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F335FC4CED3;
	Mon, 23 Dec 2024 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970854;
	bh=mOOfnfOi3y79is3Tp3jXjPf4KMKWF9uz+QZLIHsWHcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNAbTsRntB3uKyYgPApPvMFeO1U0kaVb+kSo0WynIZwA7iGNCF3HCXSHK9Rf7j/Pd
	 8FtKgn5NJJY46BeeGPrP5cCWl8fAT7maYA7mNtGwksN2oyCYk8af9wJBYWtN8DmGtR
	 ZRPhcOOCbGQCk8BvlVO+nxj5uBgNJo7FMM3/gsJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 70/83] of/irq: Fix using uninitialized variable @addr_len in API of_irq_parse_one()
Date: Mon, 23 Dec 2024 16:59:49 +0100
Message-ID: <20241223155356.337452601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 0f7ca6f69354e0c3923bbc28c92d0ecab4d50a3e upstream.

of_irq_parse_one() may use uninitialized variable @addr_len as shown below:

// @addr_len is uninitialized
int addr_len;

// This operation does not touch @addr_len if it fails.
addr = of_get_property(device, "reg", &addr_len);

// Use uninitialized @addr_len if the operation fails.
if (addr_len > sizeof(addr_buf))
	addr_len = sizeof(addr_buf);

// Check the operation result here.
if (addr)
	memcpy(addr_buf, addr, addr_len);

Fix by initializing @addr_len before the operation.

Fixes: b739dffa5d57 ("of/irq: Prevent device address out-of-bounds read in interrupt map walk")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241209-of_irq_fix-v1-4-782f1419c8a1@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -355,6 +355,7 @@ int of_irq_parse_one(struct device_node
 		return of_irq_parse_oldworld(device, index, out_irq);
 
 	/* Get the reg property (if any) */
+	addr_len = 0;
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */


