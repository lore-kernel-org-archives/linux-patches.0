Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9743C1974;
	Thu, 15 Jan 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498141; cv=none; b=el4tpqMiGdisyp0CSzf3nKGOlQb4MYhh3nBKgUZGbVtkcA6LwMQrsHioZ6NLm2KC62/uGhJHvkeXVBZxSF7sWdOHo/SM4WjYOMCPvnJ7kRwVAWbk+NsoJegBJuM6FTb/j9FJugvymduFz4xrDrwLGUCPaStE8set3+FtqRSUs2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498141; c=relaxed/simple;
	bh=z6Vm7ul6JQzgJNppDz4Tkmh4RmCN9I14UHai3+eQbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2d1XC2pVvSnsFzarj9OOPNEJNj8qEcDaAK+Vz+3bGQsyJiZFICqi9R+es4OCNHF6keOscCDJJHZvaHCntXV6sTQyztO0Rgqfyu89rnyyWIBkZ8cpQkL1ubGogbU8nzJM4JgRaUzQy0CBz2oPNqmNkOMeqL11scXoUyy+9dHAPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+tOkSYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+tOkSYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B41C116D0;
	Thu, 15 Jan 2026 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498141;
	bh=z6Vm7ul6JQzgJNppDz4Tkmh4RmCN9I14UHai3+eQbGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+tOkSYI/S54IQwIDPCd+PLLrMmlt7iMCjtC8rA+I8Xhg0iY9tTiUcSyAzyDsWbQ9
	 zDQrhKIAXCAOerevKlojaifJN4R28PI2qWHYCxiL76zXYzaJrvLhjCI5lR7HV1uNXl
	 XFBelb8wzKa/TUjAeKRFjFQHzqq78kLgYFwQcOs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 328/554] soc: qcom: ocmem: fix device leak on lookup
Date: Thu, 15 Jan 2026 17:46:34 +0100
Message-ID: <20260115164258.101910926@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


