Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF613DBD5E;
	Sat, 12 Sep 2026 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207972; cv=none; b=plrq2ANTttsIH09vSZzCopJYfVYLBskJbbuBNsZ7wM3StQMN/BCrniwpzOhZJ54aDEZ/dORQQTXjyjFVHZ2DXdYj/pzKYoZzoYHdPKKam+rC4m4ttSaJFu6j8fgYUpOcBJETuaLewwOAm4qk0qxYPi1mphmZiotp4x2Hr39/K68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207972; c=relaxed/simple;
	bh=FxGOaXNuuLsYkD2LDRTlrNXp3Cinvj1kPwQIpoGuH54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYdN0OhUSO3q1lR9/aKfBdvouaejinotvkUftbVWwU2MoRambkaQyL41ICHd+bQ4VUrSd12JM8R3jyAJZzO+kUEBjwmgc7XMREZewxvCNbnZ7yVy8fQbiRBAd+S4OzUdOieVJTMFOj6hi8tai+NtB+ezLyHnDR+/yVIp/xWIVic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kSqW2aa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kSqW2aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389CF1F000FF;
	Sat, 12 Sep 2026 10:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207971;
	bh=YIvaBKN//QTg0gwJvCN7AQcQ3Nfow6Xvbxpftb+bJSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kSqW2aa7s6dZcLW6qj5OPwpWVq9LKx6VXieEfCCiRiI6LebBR6KljQ07/LQ/W+1h
	 9HEBqQK50Pw7VYK+PqGAMcZZak5GeLoPRPpVVLdufmnNdrby3Fwa/3+uSwjdthbOyY
	 WrmN2tGyUXbbapc5dZS/Q1af/bOKLy7F8+28diOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0523/1518] iommu/amd: Fix undefined behavior in devid_write debugfs function
Date: Sat, 12 Sep 2026 08:44:52 +0200
Message-ID: <20260912065635.277280543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 843e149989665f8309ad2efe6048dc76591e1f94 ]

When for_each_pci_segment() loop completes without finding a matching
segment, the pci_seg pointer is not NULL but points to an invalid memory
location (the list head). Accessing pci_seg->id after the loop causes
undefined behavior.

Fix this by handling the successful case inside the loop and returning
-EINVAL after the loop if no matching segment is found.

Fixes: 2e98940f123d9 ("iommu/amd: Add support for device id user input")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/debugfs.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 3909a1fb218e9..f7bb551d285f6 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -176,19 +176,13 @@ static ssize_t devid_write(struct file *filp, const char __user *ubuf,
 			kfree(srcid_ptr);
 			return -ENODEV;
 		}
-		break;
-	}
-
-	if (pci_seg->id != seg) {
+		sbdf = PCI_SEG_DEVID_TO_SBDF(seg, devid);
 		kfree(srcid_ptr);
-		return -EINVAL;
+		return cnt;
 	}
 
-	sbdf = PCI_SEG_DEVID_TO_SBDF(seg, devid);
-
 	kfree(srcid_ptr);
-
-	return cnt;
+	return -EINVAL;
 }
 
 static int devid_show(struct seq_file *m, void *unused)
-- 
2.53.0



