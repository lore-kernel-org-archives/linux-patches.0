Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F820F079;
	Tue,  6 Jan 2026 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720636; cv=none; b=XzLS/cJOM94sYvOYEHI84Qeqdx7L//lbQCzWDwOp7Kj3hiuo8clo+O8MUpaR8uUxFpii6lULwDKM7TJEKRZ5i104Ut1TBjU0UE83PScbotCcEzR0S0hzmOjCJ4X++DwT/sC0SHFIKcol6vvSRghKd5VEjkGo7Khwmlb2N/imSFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720636; c=relaxed/simple;
	bh=VzfdIdt/p/qTTu3uDEJH1zfzqWOjDFaP/ZQhFKSTTeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPZzg8sFbU4lYP8sJY1iZq18DdFm/DM//ZQ8uuf5+yEgNkFdOuFXTa98cznvyrETTVI2AGVb7/mTwOzuCCz5yrvE75+3AcwglCijRi8Qn7CL8Cy+VACcjuT4ktVNZYH4K7k4V515a47fCBLYs9GgqyiceVazgZyL1vSSg5EzK9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBolGYKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBolGYKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE717C116C6;
	Tue,  6 Jan 2026 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720636;
	bh=VzfdIdt/p/qTTu3uDEJH1zfzqWOjDFaP/ZQhFKSTTeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBolGYKJEqzdzcVqvTWNIRvGdiA1tjitWmDjsMUQ6kdfYm5p6ntvvxgEXgr8cvOed
	 Id2Pmma+aSPsvqqRyvAL32VNgta/dg278fm28aYLqiyY9dRhg4cnhUcAViKhQJy5ow
	 xvfj5ak//bGO4UVFzAptMJUuZyfqs1g8RvD63wBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 279/567] soc: qcom: ocmem: fix device leak on lookup
Date: Tue,  6 Jan 2026 18:01:01 +0100
Message-ID: <20260106170501.649226117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -202,9 +202,9 @@ struct ocmem *of_get_ocmem(struct device
 	}
 
 	ocmem = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ocmem) {
 		dev_err(dev, "Cannot get ocmem\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-ENODEV);
 	}
 	return ocmem;


