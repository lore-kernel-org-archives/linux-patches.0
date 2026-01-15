Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F153C00AE;
	Thu, 15 Jan 2026 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499735; cv=none; b=CVeaX0+87+5KmxjUvYv1bthg3oKk0GNrz2gxK5lsjh5uNsN0KmLwQOf/U/jQ7FRosknbN6/Vto1+t/gIm+OXkmv4HWM6fnmbvZrTyEhbislxxxyO5nxlBY5y38kfG6tSZaRN8i2XJIaMQrE6NaBtDIJcZMjXnTK2sG8goN/Rz+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499735; c=relaxed/simple;
	bh=LdrmKX+K4EdigftvanCNw6DRysLBfYhUhBphOfjrqEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blvUDNAWwSMGVquEr0TXSQHGHqISRb6t+AYSISeVVWX1WVu15HhCgnh0fGMbraUiBTDH8u5RiMiN23GtBFJ366tN0Umrk9YYKWi/W4bkL4OEnZNu2CDpRPYT3ip8gaDttz+DMFQHmZ1al74bWP0bLaPne1jHkYePArXCcIPLhSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9tuXDa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9tuXDa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F20AC116D0;
	Thu, 15 Jan 2026 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499734;
	bh=LdrmKX+K4EdigftvanCNw6DRysLBfYhUhBphOfjrqEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9tuXDa80mCxOKgTg7cDF9I6gDqxy60i9CK1/wNgDJ9+u1QNRbLgNCcMGCyRH2FT4
	 GXHlBMvWnsVUU2vsuKD+aNnRetXmwmK+2HoDU/uUJiVgRn/vVupnpL6NHE5DYoyfi+
	 tvjVYco26aKkHILOSp1yLCT+CtxzKxVEQq1lQsvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 331/451] fjes: Add missing iounmap in fjes_hw_init()
Date: Thu, 15 Jan 2026 17:48:52 +0100
Message-ID: <20260115164242.870397214@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


