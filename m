Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBB53C9886;
	Thu, 17 Sep 2026 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671764; cv=none; b=Ncw0ouoqv3CzC/wiI9Kds1b3XnLNhg2c1OnDLUH4N6p/kcRauaQI0xnThLoHSCf3IPiHXWG4IiHmAu9YOqrG5FM+8XS1IT4Quil+kTRIXwyt2wYb0Z+V4VxKeZq6DZ8QAVIdOsrHqU5VJZU2i6amTzw8FI3Oes7O9lSkXHetdSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671764; c=relaxed/simple;
	bh=AEi57ZuV12dV6D17YHU2WGja8vUH3E35PeFnfVfIGtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDT9T31I9/AwsTNrJTgGCsLvL+PgQu37rmf0MvwYdZCM9JgMGsucxYEkygNYgfMbWv3z4sFULfMe/UEjGVwYJRWt//QSFM0lCLhSto8/uRzwV6AbwzUPJ2t6/gAwIcZAlR6OghG6ZsqKnhjIIDx99Ua5hHH7wdzqtX2ZR4K0f9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4m5V6cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4m5V6cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA71F000FF;
	Thu, 17 Sep 2026 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671763;
	bh=VDN7Zkh2B/Ca2BUqx7T4xyFOtAORV/UL8nSqipYhrf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4m5V6cmPlv1psKWwryvRcs7RbXBSZP8/Uee/ZguFhGhXuUfdj5WjTSriX5IfZxPt
	 Pq4JNktAZWjnD+0+LASbYh1M9KPOLSt08+yBiHfyY1DiKyfXK1jj9uRyLuYB1vSHaK
	 RxznuEPUirZMod6hNqjuVdcbVA45gUgm7hCOo90A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1081/1102] SUNRPC: Introduce xdr_set_scratch_folio()
Date: Thu, 17 Sep 2026 16:17:04 +0100
Message-ID: <20260917151607.986820901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Anna Schumaker <anna.schumaker@oracle.com>

[ Upstream commit c8a127596edc026e5364a7a609986dcd3999914c ]

This will replace xdr_set_scratch_page() when we switch pages to folios.

Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: c479bde671cb ("sunrpc: defer rq_argp and rq_resp free until after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/xdr.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -318,6 +318,19 @@ xdr_set_scratch_page(struct xdr_stream *
 }
 
 /**
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
+/**
  * xdr_reset_scratch_buffer - Clear scratch buffer information
  * @xdr: pointer to xdr_stream struct
  *


