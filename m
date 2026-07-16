Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A966A425894;
	Thu, 16 Jul 2026 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209746; cv=none; b=dh2jIF/Q18CHvHZWwO4dOPpjrEHUCBlpi5Fh8uUgH/FHpm5gXvv2CAa3bSEhVVrt5DbrXgZbvWW7urOdmVAtIPA86zactVpN5RDdxeF1ej+1nh/3yHQOutg82EK2ivpUb9oH/Odh5jvT5GiWn+KUJo+1heKfiaXvN4ZlJbbnCfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209746; c=relaxed/simple;
	bh=/HhEYZHw2qpt1/uwZNlwswmWGbkqVauiTOcW2SS6u2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ikk2CRprnqCsifFBwrRohqF/L+fI8N9W047CgTsC2EwvJAleByYsA7VbMeZ8jImdkFPFB0F97JtYkK7UnE5THaJJ21ARXyNiYR/fGaPBBBMWs93nZlkss1BTIKw30m3+SkbUueKkjWpMPCdiMe3JFUtb8t8wiJBB8JiNSbP+Dcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlOLjeht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlOLjeht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA921F00A3F;
	Thu, 16 Jul 2026 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209741;
	bh=0hYFyhxLzbPhGfapFZeNO8Yz9EyvIDzinI2d2iH38xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlOLjehtf5hwAQCPbIL0sb3gT/1XH0IRpRsHQUCSMckVDwqtH149l1PZz/nsIHGai
	 EGV2j+Vv6kblm9Y6xute13COYZqC7H05pYzZJCsgjst4MD+7KV1TgPDg8Cdr3KKqua
	 n+aFuJfNCPtVJXDzY0YpXRejUdLH0UjfxxFN5YBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 7.1 299/518] usb: cdnsp: fix stream context array leak in cdnsp_alloc_stream_info()
Date: Thu, 16 Jul 2026 15:29:27 +0200
Message-ID: <20260716133054.359495593@linuxfoundation.org>
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
@@ -631,6 +631,8 @@ cleanup_rings:
 		}
 	}
 
+	cdnsp_free_stream_ctx(pdev, pep);
+
 cleanup_stream_rings:
 	kfree(pep->stream_info.stream_rings);
 


