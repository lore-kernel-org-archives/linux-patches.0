Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549773B6C0C;
	Mon, 17 Aug 2026 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974341; cv=none; b=ZLrhax/ZP96m7wNw0I1QhAwbCKPwWWLa/Zw/qZBNRfEsqI0kGTe9CPMkitkfKyWIF00bCHpV6lM+aK2lQR2ybRmilknILxFfet3QrlbSo8ba8dcXlXNd+oeCM2yQoudSFvbJr1mquusJTrdtD9cYVh9hu/Y9IE+ZmqAyIEdaUiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974341; c=relaxed/simple;
	bh=D++KUbGF5KEAQokuUmE33of6wI6y44w1maaxPHYW/fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b78rw0oGOIWCCx3TSCb7bSkfkmaeFeuqbULNznrvBoU8dASfucAtZxllPLNFrL/xsP8VuRznCsJGKaYXD/r08HTDccQKigXHimqmPqtBqosWxEdBpOs0lapUmKpj4X6DUgKH0bmDqTW8ZKdpEQgRFF2poZO+1fHokjnWvbiDKgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/VbsXLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/VbsXLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FDC1F000E9;
	Mon, 17 Aug 2026 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974332;
	bh=klITT+PW/m7o4peQp0hdqaRVTKgyZvka6FouafeMDZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/VbsXLACvguSaXOD6P+ssKR+BG64u2lOvYS3q9tubB+kLh/oHcupdbPBwbOZbJd0
	 fPi3NXregMIx9MjzrY8um0VU+zj1vRJl7ruagkHz2hoQeNCdN0ElnIojV1ozzY01w3
	 eaPECuGmit/gtsb85mYR62xEuEq3EjwkHiei1Iys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Antti Laakso <antti.laakso@linux.intel.com>
Subject: [PATCH 7.1 129/271] usb: misc: usbio: check ibuf_len against rxbuf_len in bulk msg
Date: Mon, 17 Aug 2026 15:30:54 +0200
Message-ID: <20260817132542.159696431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 7e22c9f79b200672f3e477421b6c9050d8cf70a5 upstream.

ibuf_len is the bulk IN (receive) buffer size, but the EMSGSIZE check
in usbio_bulk_msg() compares it against txbuf_len — the bulk OUT
endpoint size.  Both are taken independently from different endpoints
in usbio_probe(), so the check is wrong when they differ.

Use rxbuf_len for the IN direction.  This matches the buffer that
actually holds the response data.

Fixes: 121a0f839dbb ("usb: misc: Add Intel USBIO bridge driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Antti Laakso <antti.laakso@linux.intel.com>
Link: https://patch.msgid.link/20260722101810.458634-1-yijiangshan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/usbio.c
+++ b/drivers/usb/misc/usbio.c
@@ -265,7 +265,7 @@ int usbio_bulk_msg(struct auxiliary_devi
 	lockdep_assert_held(&usbio->bulk_mutex);
 
 	if ((obuf_len > (usbio->txbuf_len - sizeof(*bpkt))) ||
-	    (ibuf_len > (usbio->txbuf_len - sizeof(*bpkt))))
+	    (ibuf_len > (usbio->rxbuf_len - sizeof(*bpkt))))
 		return -EMSGSIZE;
 
 	if (ibuf_len)


