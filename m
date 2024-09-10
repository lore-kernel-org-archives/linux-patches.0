Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89DC188CAD;
	Tue, 10 Sep 2024 09:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961373; cv=none; b=dux7u4fWPOOekvrbOnrj8+ARz9r9TWwFU3VSHStFZ8hYBYPChxbR8Si+YgtZbMKDL3UyceV/uqxE4GwAvQAhVkcVB27iCH2SlgnPeHHJ2UxpyvvCubbhINFwQwjS2ol8GWgAJSiq0uqv5kvnoYzvJvmkR8h0iU8suQdaVEWYazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961373; c=relaxed/simple;
	bh=Q0qmVI7R6ZoVjcpvUuT8PNvkk0GGzWHVla+P+/+7/0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJDcTRiHzdJQBQobB3eNKe3qBcGrPyIAuHaqA/z/hCxsSjurHvJ1jTzTdZqawQe/qddR6wcFKI0UvzlXw1ObZlCwSe1+Rn0405uKv8yk0kVmLIcQ4LG8PRaA4DgiRMJ5BvtBhApX1YXIbHkmTc6aKq+HgkosZ+cVGGDeBY/3sQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AefTFrok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AefTFrok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F01CC4CEC3;
	Tue, 10 Sep 2024 09:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961373;
	bh=Q0qmVI7R6ZoVjcpvUuT8PNvkk0GGzWHVla+P+/+7/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AefTFrokWFoavQ7LP3seQYpotUVjhIkiourY6hm7kRtlYfPynXY3WwUx9Gmh3r/XV
	 48osX9EpdSPWDl5hCTSArE8++1YUFKMkQx3UpAaIcKxzMib7U3MgYik8gFSGGRfu6o
	 +AOGt7lLWTwcro1Crc+Bpu7mOFhucInKM2IMdPiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.10 020/375] ata: libata: Fix memory leak for error path in ata_host_alloc()
Date: Tue, 10 Sep 2024 11:26:57 +0200
Message-ID: <20240910092622.946941559@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5583,8 +5583,10 @@ struct ata_host *ata_host_alloc(struct d
 	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
-	if (!dr)
+	if (!dr) {
+		kfree(host);
 		goto err_out;
+	}
 
 	devres_add(dev, dr);
 	dev_set_drvdata(dev, host);


