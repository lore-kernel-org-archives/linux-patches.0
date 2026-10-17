Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C13939A4;
	Sat, 17 Oct 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259677; cv=none; b=o2D1dGGDy253t6iaXDumVZ/qBxDlayWpYvPFbbFFkJ4IA7u9QsY+WUld4DSGlySqiNxwqLib5TF7tHBiFqxfXZ/j34RI81FQMUxswzvvYdKuP9GN/gKUAG52BMNw43ABHSM4qCA2LFBW+fFzsy3QGrj5jL7K7vBgQkQ2NIe82ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259677; c=relaxed/simple;
	bh=1MLaKGHdokFgYssIx6ajfwxA6HTMXxL1nx8uFQn1HeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVKVQrOxVdpgSy9zE103hv1abrv6pl+62DSmdz5/I4qHaLgcJSgEgOt6X/TdIDGFTYfMOwl5p6VqmlxLFNqEC7aYL3ZZJ/5nSenKxYFPbkfa7Pn6S41Gb8g7JcrhrDURHadDwzCeaNX9w7UHjZHZn7WUOgJbX2fvLF2AeRzCi/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViIRXD/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViIRXD/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC601F000C4;
	Sat, 17 Oct 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259676;
	bh=SUyeMLoX7ZITjKUabwNO88Ej66q/MBGkpr3/C1eE1iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViIRXD/dnn6vlOzj4z/sKJDFRdebuUOoC6XrEPjnWhbVcqhj1Bms6FetdOAk/a63z
	 y70le/3RSrfn9D8sHPC3lG3bFEM25tl2+dZ9s2XKVT8RQ3NdGUvBBTW6Ul8POWWNb8
	 37r4/d9cUuQGJxsiu29bA4X/GpyxTZhmgkHMEVPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1294/1674] SUNRPC: Introduce xdr_set_scratch_folio()
Date: Sat, 17 Oct 2026 17:59:26 +0200
Message-ID: <20261017160504.359216883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Anna Schumaker <anna.schumaker@oracle.com>

[ Upstream commit c8a127596edc026e5364a7a609986dcd3999914c ]

This will replace xdr_set_scratch_page() when we switch pages to folios.

Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: c479bde671cb ("sunrpc: defer rq_argp and rq_resp free until after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index a180482dc209b..36a974baa101b 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -317,6 +317,19 @@ xdr_set_scratch_page(struct xdr_stream *xdr, struct page *page)
 	xdr_set_scratch_buffer(xdr, page_address(page), PAGE_SIZE);
 }
 
+/**
+ * xdr_set_scratch_folio - Attach a scratch buffer for decoding data
+ * @xdr: pointer to xdr_stream struct
+ * @page: an anonymous folio
+ *
+ * See xdr_set_scratch_buffer().
+ */
+static inline void
+xdr_set_scratch_folio(struct xdr_stream *xdr, struct folio *folio)
+{
+	xdr_set_scratch_buffer(xdr, folio_address(folio), folio_size(folio));
+}
+
 /**
  * xdr_reset_scratch_buffer - Clear scratch buffer information
  * @xdr: pointer to xdr_stream struct
-- 
2.53.0



