Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D794C368D66;
	Sat, 12 Sep 2026 11:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212863; cv=none; b=twlIXYmOwzPDOtmnZVWvZxbNwAccHHsLwNY9qswRGQvRPdTvK37nj7BVOAaZjIJXL0r2iI/p7TjDS4Bg/tDQ8nTAi72QbMqLRMdzWUb6B/ihnNK8bazgKSMumnCN2etx+nbiVpQtmnhyXgprxkQj4bhwpiOv6z+O8DDTgo1swM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212863; c=relaxed/simple;
	bh=FRIfvaFU0P1AKrpZTPsWAilonPZnQ875+oLB6hyDlnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGSX3gwU4dV9Xqv9Xg/MRyXrqBk4qKaO0tMzx1r38/nfuqyoAHsqXpb8CCYf/tT0MtlmKrmoEOZr0alSN12Hjjzew5Gj2+OPs7uuL/KickQvhpE1ASljk509zLs8kwT7HugR1fB79Ma3SzaNzXHwTsIJYlTizG2wTWjbr4/USAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jzQwxLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jzQwxLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CC21F000FF;
	Sat, 12 Sep 2026 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212861;
	bh=dyc8gB6PSCYPB1QEPLzpy0teBtj4Y41LlUddvbD1bes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jzQwxLf227kpHYBvcxr2yVBPeEliRoDKBOy24vAvfKVdMOBrWizry9Nn7gEyo3+M
	 tdsPmL9OsP/4vaOBJIstM8lnCvED/p5HbCViEG8irBh8eHm66+1HTnPXRPgaiZ5r+6
	 QhPrsvL2hx9GZTUiNBL1SQqzd1SDyVAPLDRfW6tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shyam Sunder Reddy Padira <shyamsunderreddypadira@gmail.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 6.18 1516/1518] staging: rtl8723bs: os_dep: avoid NULL pointer dereference in rtw_cbuf_alloc
Date: Sat, 12 Sep 2026 09:01:25 +0200
Message-ID: <20260912065657.860588072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sunder Reddy Padira <shyamsunderreddypadira@gmail.com>

commit bc851db06045a40c18233dd76ef0562d7f8bb6db upstream.

The return value of kzalloc_flex() is used without
ensuring that the allocation succeeded, and the
pointer is dereferenced unconditionally.

Guard the access to the allocated structure to
avoid a potential NULL pointer dereference if the
allocation fails.

Fixes: 980cd426a257 ("staging: rtl8723bs: replace rtw_zmalloc() with kzalloc()")
Cc: stable <stable@kernel.org>
Signed-off-by: Shyam Sunder Reddy Padira <shyamsunderreddypadira@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260414071308.4781-2-shyamsunderreddypadira@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/osdep_service.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8723bs/os_dep/osdep_service.c
@@ -224,7 +224,8 @@ struct rtw_cbuf *rtw_cbuf_alloc(u32 size
 	struct rtw_cbuf *cbuf;
 
 	cbuf = kzalloc(struct_size(cbuf, bufs, size), GFP_KERNEL);
-	cbuf->size = size;
+	if (cbuf)
+		cbuf->size = size;
 
 	return cbuf;
 }


