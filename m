Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE49329AB1A;
	Fri,  7 Aug 2026 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116646; cv=none; b=gbyykx6vuMMrGYowUvcbIz559TdsQ3csUYJOPngqBhkrxXGx6Kgd2DIHiKbBA0zTxUxzo0C+MeMK8mhEktFV7rr3WWsnK5/24YNrP8/eD9gcHjD57/b51/WA7z6WSBhy5cznMHug56X0HXYR+ByG//robBqE3NceXRMd+1myrPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116646; c=relaxed/simple;
	bh=ll5o1ZRSDHtBPDiMQ0tJhMz34knoOVDqwtl5hMY/7gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOK9fuWbePdCZHD5iIh8GoXCP5ZN2Qqtsawy+lIVFh/G+MQIs4YkYSSVoD+rDLHr4PKzLT80WOJFDJ3V3+tJDniWDUWO6rAG3OL3hQqtn8fOlEbtMyPk4k5Ni8YYQsntulSL1N8Lm2A+duVQODS8c+sxTcgD6oCA/LDWopn7FG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLPQ30Yn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLPQ30Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466F21F000E9;
	Fri,  7 Aug 2026 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116645;
	bh=w7j5FMHtFS3G/BbBoz+2fnakynLYAs2azJsQyXQi+I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLPQ30YnTJ4Aw4T6Iwg5Mxm2j79PDegmB1pgtUe9H09H4ZJQodRdxYY5rfqYO4gEw
	 DFaf9OHu0TqIEwFOK4trl6nsCKQF8YbbzXEyF6ThSpW2Yoxf8DiW5lM2gOLsycyUMj
	 xngqve2g2M7jXPce44TntDB3gwZxwZYiplB3D9GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Xie <xieyi@kylinos.cn>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 041/438] mshv_vtl: fix fd leak in mshv_ioctl_create_vtl()
Date: Fri,  7 Aug 2026 16:33:57 +0200
Message-ID: <20260807143428.877382715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Xie <xieyi@kylinos.cn>

[ Upstream commit ec08dd5b9ffa52980908805bdc8a55a8f1bc6667 ]

put_unused_fd() if anon_inode_getfile() fails.

Fixes: 7bfe3b8ea6e30 ("Drivers: hv: Introduce mshv_vtl driver")
Signed-off-by: Yi Xie <xieyi@kylinos.cn>
Reviewed-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_vtl_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index c194007014678..3ce4b4d6c11eb 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -129,6 +129,7 @@ mshv_ioctl_create_vtl(void __user *user_arg, struct device *module_dev)
 	file = anon_inode_getfile("mshv_vtl", &mshv_vtl_fops,
 				  vtl, O_RDWR);
 	if (IS_ERR(file)) {
+		put_unused_fd(fd);
 		kfree(vtl);
 		return PTR_ERR(file);
 	}
-- 
2.53.0



