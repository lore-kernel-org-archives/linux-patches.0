Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4875C44AB85;
	Tue, 21 Jul 2026 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668574; cv=none; b=Tols1jaOlUBVVtPCl/EVd6mywCyHgss8q+ED3ZgtYqcSWDlQlHf4Qb64tFhFHlgv4tAA9BdG/t5FwvSnhM9Pa6LApbVORfM2gJpPFpyE3CLrYkEYwVKBN0eOLeZzRxcciXMFIaXNI5vGnd+hF+hLH7AfphvCBLYQwZxoCz19fWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668574; c=relaxed/simple;
	bh=eE+RgbLthaOyG87AQxWOqVdyXvoJrZjFGD5ty1eePcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ+3NQUhktSJmi/AF5oIzI9xddMZDCikQWuZ6VULGPB/7uDasZr3jRwVK54qBMkKth3I0k91AT51h/OKkN3Nlg1VQJHP1MEaOjuPrAdC3zh8idMpP2IwJoP1wThyGI4IecHhYMlNOJ1SgklvckKsUmN3G0GNZyASfsEpSKRJXF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8yhp08U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8yhp08U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1B51F000E9;
	Tue, 21 Jul 2026 21:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668573;
	bh=BUUzeBTk9szz6FNplF18QFpHgOlGHYYZ6uY3rhHPWjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8yhp08UdaaQT5BG62zGZuXMQpK/nRUTT+EEqjZeR9jZ5/f277zwFMXSzMbus9RAA
	 OPCTJ7Xr+Ym4+2KGgzkZ3qX5Q3G/rOKcHm15R1FpVbLPM816q2LvVVS3dzajzMEPPI
	 3lRIPPlG3uXfax5qME4xevJnX//GatM91ZolAHIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Andrii Kuchmenko <capyenglishlite@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 6.1 0226/1067] module: decompress: check return value of module_extend_max_pages()
Date: Tue, 21 Jul 2026 17:13:47 +0200
Message-ID: <20260721152429.655082127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Andrii Kuchmenko <capyenglishlite@gmail.com>

commit 786d2d84416a9a1c1a47b71a68d679d886284be2 upstream.

module_extend_max_pages() calls kvrealloc() internally and returns
-ENOMEM on allocation failure. The return value is never checked.

If the initial allocation fails, info->pages remains NULL and
info->max_pages remains 0. Subsequent calls to module_get_next_page()
will attempt to dynamically grow the array by calling
module_extend_max_pages(info, 0) since info->used_pages is 0. This
results in kvrealloc(NULL, 0) returning ZERO_SIZE_PTR, which is treated
as a success, leading to a dereference of ZERO_SIZE_PTR and a kernel
oops.

Fix: add the missing error check after module_extend_max_pages() and
return immediately on failure. This matches the pattern used by every
other kvrealloc() caller in the module loading path.

Fixes: b1ae6dc41eaa ("module: add in-kernel support for decompressing")
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andrii Kuchmenko <capyenglishlite@gmail.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
[Sami: Corrected the analysis in the commit message.]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/decompress.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -215,6 +215,8 @@ int module_decompress(struct load_info *
 	 */
 	n_pages = DIV_ROUND_UP(size, PAGE_SIZE) * 2;
 	error = module_extend_max_pages(info, n_pages);
+	if (error)
+		return error;
 
 	data_size = MODULE_DECOMPRESS_FN(info, buf, size);
 	if (data_size < 0) {


