Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8E5446B6;
	Mon,  1 Apr 2024 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986563; cv=none; b=ZAQmjqBd4NKow6NTmVKYurLBWFRNB/h636DL1SiTs7cu+MKwXKhPSuGWLQ8A2RX25fqiZtjqChrswNLSw8yJjSD+HR3sEV2hUTCCmV49xY2xexe4FUI5AtqVG4S3Lu3Tit6b8wPWnTA5/0wJl3gD+ejBGi/4slWfLYAidNXdhfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986563; c=relaxed/simple;
	bh=ojeeiRXf9bGLpZHBjg8MCwsRO4MQeS/DR8+Gz81ksnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDcyZJac7icrdoFdoFmiHcIlsitAUAeE8Q6b5dH90UasqchMj454PIi6GtfEZgdsQ20F8e52iFckH8F0ifHO+7uIURjnF3+rY3Uktl9jxrC5wdgsOB4BegXZLURurOBX6zcbNLMLBzKxuERwRyOAbGljwD7CVL7Jg6sPolNpGds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRe5Nt/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRe5Nt/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4A6C433C7;
	Mon,  1 Apr 2024 15:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986563;
	bh=ojeeiRXf9bGLpZHBjg8MCwsRO4MQeS/DR8+Gz81ksnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRe5Nt/zCuwJLZb6ZYmZOARHgTkZ0HXAti5wBtFvq2Mmw9OEyqsQzWoBygbvLLvBO
	 Hg+h7ZA5eY5fbiCsGhwE7ae00zLVy5m2HItrsNHBcsO9CeZq8ATJ1QM2Q9JprNpwZs
	 DNHT3/xyxDhVr5Cx0w/lA+0HC3prGzXfor3dnxAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Philipp Stanner <pstanner@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 015/399] pci_iounmap(): Fix MMIO mapping leak
Date: Mon,  1 Apr 2024 17:39:41 +0200
Message-ID: <20240401152549.615505131@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 7626913652cc786c238e2dd7d8740b17d41b2637 ]

The #ifdef ARCH_HAS_GENERIC_IOPORT_MAP accidentally also guards iounmap(),
which means MMIO mappings are leaked.

Move the guard so we call iounmap() for MMIO mappings.

Fixes: 316e8d79a095 ("pci_iounmap'2: Electric Boogaloo: try to make sense of it all")
Link: https://lore.kernel.org/r/20240131090023.12331-2-pstanner@redhat.com
Reported-by: Danilo Krummrich <dakr@redhat.com>
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/pci_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index ce39ce9f3526e..2829ddb0e316b 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -170,8 +170,8 @@ void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 
 	if (addr >= start && addr < start + IO_SPACE_LIMIT)
 		return;
-	iounmap(p);
 #endif
+	iounmap(p);
 }
 EXPORT_SYMBOL(pci_iounmap);
 
-- 
2.43.0



