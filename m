Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8FF3C1999;
	Thu, 15 Jan 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498360; cv=none; b=tELz0hPjxPpYDuQN0BptO62GQIWqvVBtnuqKysAFuBfvtvO5fI3INhk8o2K9RzXNVn3DOarHln89Yy70AXNTPSHJ3QlFApd4ca64wFckR9eazZL6Lg2L75KxyJWogZfgCAPO6j2Av8H7ml6ZTFhYhHalO+7XsDkOT9WDsthLi1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498360; c=relaxed/simple;
	bh=gNGax0mcKcLkTsz0w95tpyFmOVWt+K3LGWMoNb2GugA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se+UDQ1WJjzvcE8UkydbioC+k/6XAc4F9Ku3nH82WUXfUcdC2OvGOCCGuocGIkHpOZgJPO8Y7bSyTRz/v+OsfW+3LFPEnsLCoN66oY4Raja8AtwooJ3gHzJbHnJQtTsN9CwgxVKdKblVD6Zc1GqVfjFewdOYjKeKlCzhhEQgLgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUaHZfRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUaHZfRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2927CC116D0;
	Thu, 15 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498360;
	bh=gNGax0mcKcLkTsz0w95tpyFmOVWt+K3LGWMoNb2GugA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUaHZfRInWhvcfeKEqRZaJIq0jb+f5/g8/61B41m2q8n7Xg01tHrZrL2GO919QJ8Q
	 CwFSraHeY2qH5lkxUH47yEf0U+bemmgJ0E8YM4IEBbpQJXJoyzs/vkncC0SGGhBE9+
	 MyVO3ghMdjieScaF6t9OxY9mn0N0gk8qm9uWcMFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 404/554] fjes: Add missing iounmap in fjes_hw_init()
Date: Thu, 15 Jan 2026 17:47:50 +0100
Message-ID: <20260115164300.857904056@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 15ef641a0c6728d25a400df73922e80ab2cf029c upstream.

In error paths, add fjes_hw_iounmap() to release the
resource acquired by fjes_hw_iomap(). Add a goto label
to do so.

Fixes: 8cdc3f6c5d22 ("fjes: Hardware initialization routine")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251211073756.101824-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/fjes/fjes_hw.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/fjes/fjes_hw.c
+++ b/drivers/net/fjes/fjes_hw.c
@@ -333,7 +333,7 @@ int fjes_hw_init(struct fjes_hw *hw)
 
 	ret = fjes_hw_reset(hw);
 	if (ret)
-		return ret;
+		goto err_iounmap;
 
 	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_ALL, true);
 
@@ -346,8 +346,10 @@ int fjes_hw_init(struct fjes_hw *hw)
 	hw->max_epid = fjes_hw_get_max_epid(hw);
 	hw->my_epid = fjes_hw_get_my_epid(hw);
 
-	if ((hw->max_epid == 0) || (hw->my_epid >= hw->max_epid))
-		return -ENXIO;
+	if ((hw->max_epid == 0) || (hw->my_epid >= hw->max_epid)) {
+		ret = -ENXIO;
+		goto err_iounmap;
+	}
 
 	ret = fjes_hw_setup(hw);
 
@@ -355,6 +357,10 @@ int fjes_hw_init(struct fjes_hw *hw)
 	hw->hw_info.trace_size = FJES_DEBUG_BUFFER_SIZE;
 
 	return ret;
+
+err_iounmap:
+	fjes_hw_iounmap(hw);
+	return ret;
 }
 
 void fjes_hw_exit(struct fjes_hw *hw)


