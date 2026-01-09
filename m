Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ACC35CB91;
	Fri,  9 Jan 2026 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962818; cv=none; b=hQAujc7LZYURFTM5aibm5e1sAwvQmNUdmvUhMMVHmS6mfKsoDYmk7AgfkevAlBZSnysHJ4egfoWXrEPFvQjvNCzvnyPEJYAimGhlO83bpj5QAwMCElfPjID/Mm9yeF4GouUJ2bJYiVrH8KIdSFvfQR8g4nAbkCOstTgSDPQIL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962818; c=relaxed/simple;
	bh=FdeGjckiERDjxF8DSiOEfqlRI2TaSIeOFJvFOEF+ZHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyYYsricPNBCw09G2vusYMpEk6GHfmuPHOPP/GsYnjXGBmsgOM3L9lzl4HhUNOhldlR87fezTFyPV0gWeQF1Rlr4cibS/4lgNUGGN0JWFJ4+MWycDjRQZ/BQUo1+SVK9kbZEdyXT1vt0hlHODRKkzWG4eawFvVGDKlnHPCo/0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOkyaguk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOkyaguk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B02C4CEF1;
	Fri,  9 Jan 2026 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962818;
	bh=FdeGjckiERDjxF8DSiOEfqlRI2TaSIeOFJvFOEF+ZHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOkyagukeUyWiRCT+dHdYfkwdQq2OyGUYEcPQ45JZ/v7AjY0sC+I2uBQ3GcRpL2lP
	 TQjdrYM01AXpuOAezpqB1H4R87VJFBVR7UFnhfbhxYnnmUl6LpUPBS6B4O9kHjZ0yP
	 lVvw5SD9vWkfN9TG8NgXyCzpAr9cWpJKIlSwhVgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 499/634] fjes: Add missing iounmap in fjes_hw_init()
Date: Fri,  9 Jan 2026 12:42:57 +0100
Message-ID: <20260109112136.322874719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
@@ -334,7 +334,7 @@ int fjes_hw_init(struct fjes_hw *hw)
 
 	ret = fjes_hw_reset(hw);
 	if (ret)
-		return ret;
+		goto err_iounmap;
 
 	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_ALL, true);
 
@@ -347,8 +347,10 @@ int fjes_hw_init(struct fjes_hw *hw)
 	hw->max_epid = fjes_hw_get_max_epid(hw);
 	hw->my_epid = fjes_hw_get_my_epid(hw);
 
-	if ((hw->max_epid == 0) || (hw->my_epid >= hw->max_epid))
-		return -ENXIO;
+	if ((hw->max_epid == 0) || (hw->my_epid >= hw->max_epid)) {
+		ret = -ENXIO;
+		goto err_iounmap;
+	}
 
 	ret = fjes_hw_setup(hw);
 
@@ -356,6 +358,10 @@ int fjes_hw_init(struct fjes_hw *hw)
 	hw->hw_info.trace_size = FJES_DEBUG_BUFFER_SIZE;
 
 	return ret;
+
+err_iounmap:
+	fjes_hw_iounmap(hw);
+	return ret;
 }
 
 void fjes_hw_exit(struct fjes_hw *hw)


