Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82686433BCA;
	Tue, 21 Jul 2026 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671227; cv=none; b=LlfOIswZQOS7AreHA1jVSZ/VvNO46Mtm42ojo4nT3MVLpLyqCxJLFRC6qnwS/M85ykkFUQjWDz68mv+2wXqSCtim7pyLEdZIDp2xYqsyLpJHM9K88wkCqDlpcqDh7xN00zP6kiHXOgWhZdqJuxMxPWfDcELEjPd19Mwfi2YVanE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671227; c=relaxed/simple;
	bh=i0UNga9bUDNXc+ck+SN0fqteCAivaMWDdXaH4DqH03E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8j6oX+2QYbFijfs/uDUgOKetCfJqj/WgMLr5MidN2wnE06KoxDv1QsLmMD702Iaun1E4Hk5eYtYwhcSr6jVHqLw+axmP887stiK62xwlsItZkLtLkX5SnNbnMYaOSNJZhU/JD0vG6SkMbR8DXpQ9A+al6AgX2WNxBv7Aob+ins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtPaFoRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtPaFoRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33C31F000E9;
	Tue, 21 Jul 2026 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671226;
	bh=J4CZ/gJfn7rG/6sSWhSLHBlTAaco1rI/YSioQjt2/9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtPaFoRhQmig7CcABM2oz2A1+2XALJNWAWZZ8cgXw4Vqknuy3H8bwo2W80LVL/ele
	 T3O+DubjlN+fsogVetMKrYxiisxGPKyyEHvuGGRA2fIGtidSlfY9FKMyNmYylvp8ed
	 GGyOVfJhBHiUgyzoLabRetneALGiTR7d5YD/WLhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 129/843] usb: cdnsp: fix stream context array leak in cdnsp_alloc_stream_info()
Date: Tue, 21 Jul 2026 17:16:04 +0200
Message-ID: <20260721152408.913417670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


