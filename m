Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB103876DE;
	Thu, 16 Jul 2026 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210039; cv=none; b=u6HvO+k8Py4gE5XJ8S7HVCsjjtK9bsW+kmX+agMU4EIOkZ7xqGdpuJM+W/nzJL0IX3PyYHsyzem27tB7u03Un18owbJ5e3fL/V0Es0rmb81ZyKucl44AkbFL8pdQiy3WbJd+MOzyU8KmBwgqFA8js6yF7bveNG3eptHJyzNIhBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210039; c=relaxed/simple;
	bh=1slGzhAAkC0LMirN+iP8pz8iYlW81xplY+FDGVwymn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcKlVBCx6+fcmSVK8PAhBsdn73olFJ2Ajz0h3cc7gIbWWHnU+jLMH+KZpS/rUDbGLig2BUZuW/TpVDVUePO2VDRU2s6Ugdwv9m2SLcS31+UacFZlT60LG2cfWCsDTB7klu252eyPUKE1fgjbwm3HNAiRU5AVPXrGYLukYgRwQvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2YoQO3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2YoQO3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C447A1F000E9;
	Thu, 16 Jul 2026 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210038;
	bh=Jv/tLUa+w2a/MmMXl3eNXsm9fpo0JMeQrRzzEvhA0KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2YoQO3pyE5bOZcZt/XJMxTZEVVWEgWuQhQbSyGD58C3aS/sTen3iudsL9DjYdr6r
	 ISF/bHiBk9hAPDyE0YWBdBSnVS8Av5rL/i6l839hv/IGzbgBXiTN+vdjpVVWbsbBVV
	 OUxkFsRhjYiUC/06rnHamSFa+1KKA/XSWIJQDyV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Andrii Kuchmenko <capyenglishlite@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 7.1 415/518] module: decompress: check return value of module_extend_max_pages()
Date: Thu, 16 Jul 2026 15:31:23 +0200
Message-ID: <20260716133056.917815317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -307,6 +307,8 @@ int module_decompress(struct load_info *
 	 */
 	n_pages = DIV_ROUND_UP(size, PAGE_SIZE) * 2;
 	error = module_extend_max_pages(info, n_pages);
+	if (error)
+		return error;
 
 	data_size = MODULE_DECOMPRESS_FN(info, buf, size);
 	if (data_size < 0) {


