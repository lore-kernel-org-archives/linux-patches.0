Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F713BCD11;
	Thu, 16 Jul 2026 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211178; cv=none; b=fI3dTBEgBVbzeEXbQgQvznE8l6zJhnl8k6Z0tGxcTusmkV7AvzwFEOXr9T0QrLSNOTnCkKaEvg0WmE2R0qqQ2mNIIwg4DeM+qausRvmbzjDYNqS/jmlIEDba8rdUC4qPmt3myKSMtHZD8WmjHaprBYa+yM2wuQUW80qT8PvlKpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211178; c=relaxed/simple;
	bh=FhvD+LlXtp+JsADI6+RKBUo6k1USP2WyvH/rf2UH1iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOKQOy7NNY6TNPwtHVUSyxlrji+v4ckggh+g1KizgFdZxTx+iZB0kl58dqXsnEze/8wejjkb7y6BizFmI7WqktIpvPQEq6bEIJxDvbBIXhoj+sIpGBR39i3o+lDEtfLC4cMGvuIWy/opbQ1gfjatliG643qqt7vJYwsBCLwJ560=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8QkQswj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8QkQswj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1589D1F000E9;
	Thu, 16 Jul 2026 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211177;
	bh=F8HNs608qfCIgXjB1FVw/5Bg1Oy+fAMz/MRdd+ok4VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8QkQswj6YMElddWeXHoUHJrvFvjTwpbwuS6Mqt7MzVWw/dcBHK4TsUcZGL+gfEsE
	 kSdZ8SJhinpbR3a4ns29juPJz4W7636NbG051LRniZz8fPcyKBu4l0E7e5xvGybmCF
	 VymhGIHNgtpfezL1OIC1zW8FFO+RWZZnxIlQWQG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.18 285/480] usb: cdnsp: fix stream context array leak in cdnsp_alloc_stream_info()
Date: Thu, 16 Jul 2026 15:30:32 +0200
Message-ID: <20260716133050.990835909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 3348f444a4ce43dd5c2d1aa41634cb6eff33aa64 upstream.

cdnsp_alloc_stream_info() allocates stream_info->stream_ctx_array with
cdnsp_alloc_stream_ctx(). If a later stream ring allocation or stream
mapping update fails, the error path frees the allocated stream rings
and stream_rings array, but leaves stream_ctx_array allocated.

Free the stream context array before falling through to the stream_rings
cleanup path.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260622052627.696373-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-mem.c
+++ b/drivers/usb/cdns3/cdnsp-mem.c
@@ -632,6 +632,8 @@ cleanup_rings:
 		}
 	}
 
+	cdnsp_free_stream_ctx(pdev, pep);
+
 cleanup_stream_rings:
 	kfree(pep->stream_info.stream_rings);
 


