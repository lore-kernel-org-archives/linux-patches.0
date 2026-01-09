Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF754224D6;
	Fri,  9 Jan 2026 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961028; cv=none; b=Tvy2gXhUUUf/wWa7vcU2ZKSDnwgtr/OoxAtvNvL2Lx0O7I2IeqwF43wuAVEPsmnq4k3ZKbkXZ06u8YZKZ07GIAvDUPSZ/1vSK+Jv+erf6FCcttzuFYEAxTmgPkZo0y2fL+iA6ccUE6h81zXWr1BNhZDlUYV2rtH3iV9I4TeyjdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961028; c=relaxed/simple;
	bh=qAMOiOHxWkRXzttlX20JBOzKzf/0Lw/qeU23Xgb3r08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jujRPVgzlV3vK2wFAcO/GZcA2/smoegwlAaUnBsSv6sLGsXtLEMaIGm41LESArt3tjutRsdooNU5OkWZgLrbZ3DK1d54ld3+MEOFPJZdw51CZce+1xed0Emvmw2mUqRS7xwCkW5THAtAjoJvuLmQSZrDx+35i2EUBUgUq11eK3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsUTETHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsUTETHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE58C4CEF1;
	Fri,  9 Jan 2026 12:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961027;
	bh=qAMOiOHxWkRXzttlX20JBOzKzf/0Lw/qeU23Xgb3r08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsUTETHAY4cMSuGFNvko+10wo4e7xprvcTFkCm9oT92RZDW5OO9yk6vU7b62A5NuZ
	 3xlphRsZRtBz3KR0kAC6VNeRFUGqTQM/LPSLNEURJGGpCBcNp/mJzRp+8l86r9Iegj
	 w2U/VzYMgqjmaQUK6wkcyqA+qpqq1aE5fipwuous=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 610/737] fjes: Add missing iounmap in fjes_hw_init()
Date: Fri,  9 Jan 2026 12:42:29 +0100
Message-ID: <20260109112156.951880003@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


