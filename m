Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A023D4112;
	Thu, 15 Jan 2026 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499551; cv=none; b=iAJQSnBki89xwsYkhPYlMviqJ1xbB+ChSU73UlksdieaP38tK3fV/ahWm7GCVxh+3FlO1yabbKqfmNDGZenX4yH4RcTXPqDEtTaXEbF3OdwpiWjI8W3qYKI9AvYhLcJAQMEtBEpE0uOImnQgEGH7OjnVWkP/alsS36TUSeL7AY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499551; c=relaxed/simple;
	bh=0deYh9QofRe1W/vTO9Mzo2lCDuQWGLDBhG4E4OVSdAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWk349az56WW/vMmVMo0sHSoiuX2smVfrGKx+P3WOIFi8yN2GgdKdTTTricvBiV8HyTbVB+hS7m5n8b9NW38X45WJtRfFGN9oittd1MS0hp7DuHe+zAm5X0OgfteOF1JA9YOGgVjEbDIsZONjGUCSQqg890cg/99zQmZnFgxX+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOZL/edK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOZL/edK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B16C116D0;
	Thu, 15 Jan 2026 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499551;
	bh=0deYh9QofRe1W/vTO9Mzo2lCDuQWGLDBhG4E4OVSdAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOZL/edK28S/bex74HCSfo73x1XH2HM5IPCGRsYvBvq0Xf2M06wot+8vXxGrv458C
	 8v0GNX1kDW4vs9qUtYqb+fxSfkw+GSxvYqvnApuqGD6/uP0yY1sOSmz8ZIz6oRXGXp
	 evBKTe/a+xC8+JWKhY2cY+liweBaAtqbfA97Oi88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 265/451] soc: qcom: ocmem: fix device leak on lookup
Date: Thu, 15 Jan 2026 17:47:46 +0100
Message-ID: <20260115164240.472449597@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b5c16ea57b030b8e9428ec726e26219dfe05c3d9 upstream.

Make sure to drop the reference taken to the ocmem platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Also note that commit 0ff027027e05 ("soc: qcom: ocmem: Fix missing
put_device() call in of_get_ocmem") fixed the leak in a lookup error
path, but the reference is still leaking on success.

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Cc: stable@vger.kernel.org	# 5.5: 0ff027027e05
Cc: Brian Masney <bmasney@redhat.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250926143511.6715-2-johan@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/ocmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -211,9 +211,9 @@ struct ocmem *of_get_ocmem(struct device
 	of_node_put(devnode);
 
 	ocmem = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ocmem) {
 		dev_err(dev, "Cannot get ocmem\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-ENODEV);
 	}
 	return ocmem;


