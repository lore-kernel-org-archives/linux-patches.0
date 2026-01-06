Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9F623D291;
	Tue,  6 Jan 2026 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721142; cv=none; b=b9jGK+zAcznB4J9WVo9l3zzNc6VLbLjxN/a2RUn/J7OZYtUW8u/CGYl+xPAU8kDOK3J/OiljN7uQm0dtlU2b9vMEP5O2T9qkW2aWimOglUDD4QKL8ExJtVRWD3DsU3MB3xA23287+BLJG31xos5WxR9HaowDrh+7lkdCmk5cHao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721142; c=relaxed/simple;
	bh=twFJA0yZP5HAkuKtanjKZKTigsWuIGLqTTrLlw9YJ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBS0XA7bO66H/mRxYpj0s6R3IYfyL4reBXTi7GWJcAfMVqlSK3i/q0chiKdSgin+MWJgn6MxoiJhhRa2dwDdD3c2jO0inR+8bAo3kIq+OLHXXCmu/VsnrC70aVOHCYhByFZuwxagBXyfhnPmqDYmw74XEt83hUrGjwXX2Z2ocIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YnMhv7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YnMhv7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6C9C116C6;
	Tue,  6 Jan 2026 17:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721142;
	bh=twFJA0yZP5HAkuKtanjKZKTigsWuIGLqTTrLlw9YJ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YnMhv7Q7qUrnvQCHFQxpxlIJEEpqMdNz7PfPXPcpyo5+4CWp4VTD/qlyMk16qebc
	 yfWouAnbkcqLcqPvOzmqN0gsqDA0Vx0LdEN5oqBIAp7pivi/v0sF9BrdUDB+V8WQea
	 0hFbDn/B9HXcNvZfzD5NewWVij3Q2nNqm3Z5l9Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 448/567] fjes: Add missing iounmap in fjes_hw_init()
Date: Tue,  6 Jan 2026 18:03:50 +0100
Message-ID: <20260106170507.921029599@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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


