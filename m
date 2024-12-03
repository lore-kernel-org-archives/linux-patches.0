Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B8A1F76CA;
	Tue,  3 Dec 2024 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238802; cv=none; b=M5qYhDtzpqgz69vflDeUVFPuGwAXObTWkv6IUz0Yiyi7t2o6oTDcflOIK7D0e8d+nFYfHqNorY5r/6AFGuj98ZgCcJJ0Oiq1XRVjdcrkoSQU41j7BjZitYts9M2xgrD5oTSIafdhRPcFWLN0PNrnEWqOPpTaqf/9oEn+NRUU29g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238802; c=relaxed/simple;
	bh=cEkqAjkgqhBe9G2tv3shtJG0dOXUWJYtq1iuGAnHrSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiyGnlbNFr1vY/YD2JAtuPhwU3L3aVz4kKmzL60+ws32U0xrW67aZRdZR7mtmrysAweIAz6JCkUxb8ouUB6u1WwrqcrFIXTxngm7KEMAanLkApBYzngnmshJPPrgR+n2+YKvHWKAFziKUsf0wD7e0ijM3THSACHJllZdphWT+ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfg2Y3Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfg2Y3Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D549EC4CECF;
	Tue,  3 Dec 2024 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238802;
	bh=cEkqAjkgqhBe9G2tv3shtJG0dOXUWJYtq1iuGAnHrSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfg2Y3Vd0Is2mI+Vpbu8DMqp3PCVGAiaHm1+o6nfZF4OdYX3IgXrpK0fjRidH7vCn
	 tKjV33xigR+rXXakX32sWBG5WftE+RR9GDasorqm+L2zXjoDRX1uKS7zGN0PxaxQ5z
	 6o7fx5JKZnJdQ0WQVHFgcpUQqEsCWqVvysEomE4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 374/817] unicode: Fix utf8_load() error path
Date: Tue,  3 Dec 2024 15:39:06 +0100
Message-ID: <20241203144010.443849009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8395066341a43..0400824ef4936 100644
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



