Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF573D4134;
	Wed,  8 Apr 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671656; cv=none; b=StCY4ZAFsNb5O4ifWP2XmnkuGqw7DIUkv5eGR6E4gsposrZcAor7DLlCfFqv0Q8kIns1xnetK7C2SrM1kCCdFbS4QubxH/cxGnPoGeqdghr3gdtVtrlCnJj3HwTSHDP1U+8F48d3UBGZsTex37/0O53jizk9GLnjKt3U0wHu/Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671656; c=relaxed/simple;
	bh=rrxEzA/mlPnZFtSJjrpa5EQgwBweA7rOwYibAu9Zvak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1IGTQX3Mw56MVCrJJNqP+fdJBTYPYTH0fHoTDdgclJWZ7QjmZjI0Yv04mUK+61rHcTcIgwgQzp+3oeP/N2UGwWsKjJydVq91eH8St5IZOFpFM6uhq5xl6sex2UtMeqP/iBj8mH950rH/YIcjskQt00PKLavxAQM3RDqSy/LFfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m45q6J+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m45q6J+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2C3C19421;
	Wed,  8 Apr 2026 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671656;
	bh=rrxEzA/mlPnZFtSJjrpa5EQgwBweA7rOwYibAu9Zvak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m45q6J+6g0zqLnicyUwMa+XQie6QjjDNK7V55JlWvC2NcHs32tmWFbONurkaT7LQ1
	 j8eQrafG408zQLI6zSy/0P6NxwS1rJwNaHEa1hWX/HRR9zVhQkKOR8r7ZJ3GOMaJ2K
	 0nhbvyLQvdTrAn+K8MgjMwrslTPYVqAEyOx7+mr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Hodges <hodgesd@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/312] nvme-fabrics: use kfree_sensitive() for DHCHAP secrets
Date: Wed,  8 Apr 2026 19:58:43 +0200
Message-ID: <20260408175933.961802538@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe621028a082e..24d3c6f0580a9 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1049,8 +1049,8 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
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



