Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA123EAC6F;
	Tue, 17 Mar 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766223; cv=none; b=mdQeaiFJAY5jLyhaPOx9lj+eCa2fSWmLT91bmearmvT7lEpXDPFKnfkdn8D8xcmsezvJ8vX3gRfY5uJQ7IlrWv18cmDes7dFZWs4y/PLxozAHldUMm8P4Kh6+48BItWxMOWwWWlyUeX+eJOc4anbJB+vyPFx7WU0jh7xhwc06c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766223; c=relaxed/simple;
	bh=AdqGyu9wNPqu5eAoYgGVHXo/KdRRwgyR2NPVJrSUJqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAGZx7stcsIC4TQEyzEIKxPyDuv4YA0Bvz/iWT6SeswyQbhBINNvQELoo/BiCSBHyTKdJ2ZANpZGprVKz/zPDuJJ/HeoxjGMKg+gphwj7JWPdJ3TAKw027xutfTZlqpTowSIZdEi1sxOoOzUackm3q19qgs37dKP0hbpwsKASbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI1w5Zoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI1w5Zoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788C3C4CEF7;
	Tue, 17 Mar 2026 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766222;
	bh=AdqGyu9wNPqu5eAoYgGVHXo/KdRRwgyR2NPVJrSUJqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI1w5ZoaGoAgnlxSKbrngmv9CVWLAviAElNrZOUmOgO8gVghk7v3raS3IKJreBsbq
	 mGVwoUG3zZpJNClfXq2VKfeGoPiqsk8OarhLgJLwx6dsdR8OQNsTwe4pavyhWLxY+c
	 0uDzcyEAJCjsVs4R2XExmb3KRvPrk/Qthf7xs0Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 195/378] mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()
Date: Tue, 17 Mar 2026 17:32:32 +0100
Message-ID: <20260317163014.179743023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit af12e64ae0661546e8b4f5d30d55c5f53a11efe7 upstream.

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In of_get_dml_pipe_index(), it does not release the reference.

Fixes: 9cb15142d0e3 ("mmc: mmci: Add qcom dml support to the driver.")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_qcom_dml.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mmci_qcom_dml.c
+++ b/drivers/mmc/host/mmci_qcom_dml.c
@@ -109,6 +109,7 @@ static int of_get_dml_pipe_index(struct
 				       &dma_spec))
 		return -ENODEV;
 
+	of_node_put(dma_spec.np);
 	if (dma_spec.args_count)
 		return dma_spec.args[0];
 


