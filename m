Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F5335C690;
	Tue, 21 Jul 2026 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668416; cv=none; b=knWT9Nfq7365tIhBuKYs1iHX9D2HSHKKN66sfxdlsHckSs308XkxgpMIhC1Z4hL07U//QeLMnIy3xNdDkaO3aCjozaXT6tDUnhH38wfBoJPVM7OnVr6Gv4nySuU1gFMxu+IDQuyl2G+ubaahtDgy1rsEAEAc9f//7cwe55eAQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668416; c=relaxed/simple;
	bh=I9aRjzdYuC3RzNDPfURgsvll4pvcvrSS5GDQcQlKxIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha4E+qAiJ2x2X1AYB1Za7ZY6eKZAb6hJCdDRjcpbu0VzZW97DQqwWFpsIVqtYjYO75v+NF6FIB3T5CO3K5Fpa6jYZxDwxhUbTdXZUwdUBMyUQ5CqKlvg2cS28uRAauhLhlSmCzVQ1pk316hxL5ONZQodSQXzgVGipXJ1+FJTAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSEJ+k2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSEJ+k2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE361F000E9;
	Tue, 21 Jul 2026 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668415;
	bh=Mtq+KsvvEtee0q11Yy/Xbl5+/yMpYNcUUe2G+n2Ccxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSEJ+k2g+PqhdFew+zGvZn9OXQZdgXzyJcXJwOfnQxe2c1bI5+7I+jfCsZFKKQy5+
	 Yp09ae3P//Tr9FlqsJqFCr5q6joCTfl4PuHOF8YQ7KbPRv+IgHP6TS3MQTtW7T5qLm
	 gFTM7n8OC56shcTWQnrE+Cutsc1Q+gQecrUlUGEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 0167/1067] usb: cdnsp: fix stream context array leak in cdnsp_alloc_stream_info()
Date: Tue, 21 Jul 2026 17:12:48 +0200
Message-ID: <20260721152428.327516963@linuxfoundation.org>
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
 


