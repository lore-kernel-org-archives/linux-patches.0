Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A2D42A15B;
	Thu, 16 Jul 2026 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212161; cv=none; b=BqcohARpwGof7nOCRL5PhkPzRFUiHOpn16ui0viN9//HOjbOvBNBCV9s1sqPZMTIOuP7skfeHGpJ1puOHQHo/b85YFua1FEz/dLN9woLqdAZ/bQ3CVVgP0gdnlICvxlLU4ftOTVH8ttXeaJcE6vfThG5v6Me/2AdjbVlNUhodJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212161; c=relaxed/simple;
	bh=wD/k8iik8617ZdNkH3e+Z9vbi2ErX+zndMLUJ7AuI0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk3YRuUJdKxlxeHatHKnXmLNPIdTr87fV/ZU0IUC/rkpGPvKn3hF03LeZqbzd9ZJawQO1VAwPWxRj/S2JOAk9rcwtIkoQPHX7DuhgmMu25afaAyL37Xp8Km6EtXOiTZOgvlS6xMhNd/8NaEnmY6tkZfk6+bJyS6sPTYebL2zaaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtFPJt27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtFPJt27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A76C1F00A3A;
	Thu, 16 Jul 2026 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212160;
	bh=q0nDgPeA98sRGdRuiMlmqjBX1Q6wjbotnTK8Li7Egxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtFPJt277GhfwrBhjrbMhTQU0FDnXvF37Tm0NeHIa/7Qth9VjncEBaTPo+OSpof5D
	 iEv1UkBexbD5kizxB49t30UADTysqTERX70iSqFyjah7aAXBt4h6aDLte2Dj1hkMlk
	 nU7nsPu0JDyDx5OnZNXXc8iTSaHh4rMPYlkJzH4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.12 221/349] usb: cdnsp: fix stream context array leak in cdnsp_alloc_stream_info()
Date: Thu, 16 Jul 2026 15:32:35 +0200
Message-ID: <20260716133038.310342763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
 


