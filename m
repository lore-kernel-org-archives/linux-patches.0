Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092C622333F;
	Thu, 12 Dec 2024 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019410; cv=none; b=Kt/wUwQWn/f5w/RnLPdDjVPGBatUZrXgS/yX9vDEC97CJWz0QiSKnfr93BDxunw3YBzemtpp0DLAJ6K3HrgrKya7A+uZX4Na653h+rpolcRWat4YVnM1hpnabpTp1wmHGSt4MwBL7Q0/KYppn6Xv5dkxqzezV2rvtJQ97Jpi/ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019410; c=relaxed/simple;
	bh=3LdtBErgPnMQLrtZLfdno9Zv75QojoT+I5t4Fiq8RMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V8T+Dn+iaq8uHI3Eh7d6w38hlCNl/U4bofJ1RqhubFCztqk/wVt5c2QK8t4RmU/vLOSqx1eyBEmDPNqjSctaIdKZNs6f1KN/+WFGs86u+WMjvUPFFUx30ezTxxi195thU3f8QbkVBdDX6neN7fv89EPmHK2LDgBdRDXZbvy7SYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb6W6wpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb6W6wpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C47C4CECE;
	Thu, 12 Dec 2024 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019409;
	bh=3LdtBErgPnMQLrtZLfdno9Zv75QojoT+I5t4Fiq8RMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb6W6wpqf2yCOPqiFtLJlm8WVrigo5ag+UxXH+V63bdPZyvEqBHGpYJVQjL7QIgJk
	 +/IqpVYjStUIw36FTIGNLRcDW5A8ucUIjShSCDYn1BD5fjxDrDhPf7GfwmjGSFifT4
	 rA7PK+QLwN4nmO7uNMDSYSipnG3xjC3AGljCoD5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/772] unicode: Fix utf8_load() error path
Date: Thu, 12 Dec 2024 15:52:26 +0100
Message-ID: <20241212144358.249311307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Almeida <andrealmeid@igalia.com>

[ Upstream commit 156bb2c569cd869583c593d27a5bd69e7b2a4264 ]

utf8_load() requests the symbol "utf8_data_table" and then checks if the
requested UTF-8 version is supported. If it's unsupported, it tries to
put the data table using symbol_put(). If an unsupported version is
requested, symbol_put() fails like this:

 kernel BUG at kernel/module/main.c:786!
 RIP: 0010:__symbol_put+0x93/0xb0
 Call Trace:
  <TASK>
  ? __die_body.cold+0x19/0x27
  ? die+0x2e/0x50
  ? do_trap+0xca/0x110
  ? do_error_trap+0x65/0x80
  ? __symbol_put+0x93/0xb0
  ? exc_invalid_op+0x51/0x70
  ? __symbol_put+0x93/0xb0
  ? asm_exc_invalid_op+0x1a/0x20
  ? __pfx_cmp_name+0x10/0x10
  ? __symbol_put+0x93/0xb0
  ? __symbol_put+0x62/0xb0
  utf8_load+0xf8/0x150

That happens because symbol_put() expects the unique string that
identify the symbol, instead of a pointer to the loaded symbol. Fix that
by using such string.

Fixes: 2b3d04787012 ("unicode: Add utf8-data module")
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20240902225511.757831-2-andrealmeid@igalia.com
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/unicode/utf8-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/unicode/utf8-core.c b/fs/unicode/utf8-core.c
index 67aaadc3ab072..c887edc4f527c 100644
--- a/fs/unicode/utf8-core.c
+++ b/fs/unicode/utf8-core.c
@@ -198,7 +198,7 @@ struct unicode_map *utf8_load(unsigned int version)
 	return um;
 
 out_symbol_put:
-	symbol_put(um->tables);
+	symbol_put(utf8_data_table);
 out_free_um:
 	kfree(um);
 	return ERR_PTR(-EINVAL);
-- 
2.43.0



