Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7635425CC5;
	Tue, 31 Mar 2026 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975600; cv=none; b=TMrJL/gERcKbHRS6rd8CYvVYBtbX6oOcGeJfGKRVFLxXPv/O4n5GLO2Q756Gn1M1oLpacWv6zK6H6l3qnWOVUq3SPrftAWs3/XAVV3ZWeEyeKW7VPOoxo9cBT0cZyvwZPCqfQeEH7LDP/Qo2KwBTZhPsvoC0d8OCHW+IKe7rIRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975600; c=relaxed/simple;
	bh=ltBvlmIW8oHR70bqMMnWjzLFEtfy4oUJo7zGpShYML0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCizWx+kQkkX9JZDhY17VvuJq/a1bphjNt0S9rDkb5HmTx5vAJt/ICAipUFVhV0cH0NS2wqG94bnKVKBX4utBbFnld3RyiTzGpU9othautcbvRpdytOsvfuIFkZ5IPgaZ28KO6NUL6HKqZLeHWD3467vpfCoe8SjHUZh+QyQ+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q38E+S4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q38E+S4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC3DC19423;
	Tue, 31 Mar 2026 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975600;
	bh=ltBvlmIW8oHR70bqMMnWjzLFEtfy4oUJo7zGpShYML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q38E+S4d49qw3+1ITS4HRlYJGZO42p2K2WQL122/UgkQMwXAnq7cWIvE9f9po0yYy
	 xmJhkqFQZ7KBPd1cXyXqBYhtGuN7Rohu1NjfYV6YZTV+F+21pV8a+4POQEPWZykpJn
	 qN0JKKn8amcMA8sGELRIjsNhj0ZSXMy06vKoF51A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Hodges <hodgesd@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/244] nvme-fabrics: use kfree_sensitive() for DHCHAP secrets
Date: Tue, 31 Mar 2026 18:19:25 +0200
Message-ID: <20260331161742.269320174@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 0a1fc2f301529ac75aec0ce80d5ab9d9e4dc4b16 ]

The DHCHAP secrets (dhchap_secret and dhchap_ctrl_secret) contain
authentication key material for NVMe-oF. Use kfree_sensitive() instead
of kfree() in nvmf_free_options() to ensure secrets are zeroed before
the memory is freed, preventing recovery from freed pages.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 2e47c56b2d4b2..fdcd655ee7434 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1262,8 +1262,8 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
-	kfree(opts->dhchap_secret);
-	kfree(opts->dhchap_ctrl_secret);
+	kfree_sensitive(opts->dhchap_secret);
+	kfree_sensitive(opts->dhchap_ctrl_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
-- 
2.51.0



