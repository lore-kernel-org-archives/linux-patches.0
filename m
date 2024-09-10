Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FEF188A17;
	Tue, 10 Sep 2024 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961001; cv=none; b=NFQu2k33NuDxPQp/cRj3bYB3113bAlY/udgXqvrysRYXIe1Vg6IBYEcMw4XJqxYqbgVL1UCpE2aaiJSxX0YjLUNSXB+amoqf8MS6nEXGoFV5WkNUbj/0dxOHefeszTiqJNNFmF5hjnRafVgfavIK4Dp30vZrcAVnLZs9oex2y0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961001; c=relaxed/simple;
	bh=sye5gregCQ/jsQZGpUyuvTqO4cDsSutJyzK7+pbjnkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7jnkvrBr4sXzyKo4FbRbG9vRMnIyhw9lX4/IaARgRwLo0AV3eKlvuCMa7SIFBTSoLyUMY8j441kNRmwIjtoQ0Nd1/LEqE4uLi/Firo71acqe21FcgETvnEiagT6NMIYleonYY6zB2ldXDXiStu5sXxWQa8NvRjHJLjmZ9GLtdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7WrehUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7WrehUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5ABC4CEC3;
	Tue, 10 Sep 2024 09:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961001;
	bh=sye5gregCQ/jsQZGpUyuvTqO4cDsSutJyzK7+pbjnkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7WrehUiMoe7P2JMCTyImlKr3UgRFHDGk74S5DWyfnUMWWCwKBiyWJsL5CTUeZ0b2
	 8CmbO5xEWypY8B6No3KDcS8mGdIf33KkmbdNSNTBDbgCkz2pJjzy4OJerQaaJFBhFS
	 OIa+LfimsixMirq6/HVZsUTzzX/4G+t4y/Txzpeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 4.19 20/96] ata: libata: Fix memory leak for error path in ata_host_alloc()
Date: Tue, 10 Sep 2024 11:31:22 +0200
Message-ID: <20240910092542.311379721@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

commit 284b75a3d83c7631586d98f6dede1d90f128f0db upstream.

In ata_host_alloc(), if devres_alloc() fails to allocate the device host
resource data pointer, the already allocated ata_host structure is not
freed before returning from the function. This results in a potential
memory leak.

Call kfree(host) before jumping to the error handling path to ensure
that the ata_host structure is properly freed if devres_alloc() fails.

Fixes: 2623c7a5f279 ("libata: add refcounting to ata_host")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6221,8 +6221,10 @@ struct ata_host *ata_host_alloc(struct d
 	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
-	if (!dr)
+	if (!dr) {
+		kfree(host);
 		goto err_out;
+	}
 
 	devres_add(dev, dr);
 	dev_set_drvdata(dev, host);


