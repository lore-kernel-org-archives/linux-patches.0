Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1371748C403;
	Fri,  9 Oct 2026 14:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557436; cv=none; b=XvsRRyx/YFlrDhG4ZBLO/KKIB8gZsXrxsmNJaJf0YZ+ZGrklr03dZzIRXpbRyXxc8Pp0II/2dWvZ7/Nnew0FT2P3phP0tToc3Xy1DkpxnCt6mKrnXAd1Xmj1yjYO2cC7cyPbQic0M/svVvzZoWnO2f7xSPfwLTD7a8HaJJgTxp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557436; c=relaxed/simple;
	bh=Aok6QGW7EKGULN2YlVsDXzjj9F8XdYadcIWR5ETyXPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9n9MlNS5K675+sqKuJenwAPV6bQZPNEyzvK8PdrxvSwwMXwqPXKlktiI/1Dh55HvBIS5wge1dJaAXfLr0Qp1KdAORBAkkPQEYJLKEJPgShJNzan2IEZf2jHa1kzY9AWl9qokXq1I0T+zz+CZTiU9HVdJkl6XWZ3s4gsy107TYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q21wawhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q21wawhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4C41F000FF;
	Fri,  9 Oct 2026 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557434;
	bh=aidnu3KXyUuFd51Cld3hh1kh22OdPm2CnCOtkJy8PLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q21wawhm17s+GIX9AIywyZ4ZLfbWQ7BLxxrTKijqxsyX+y7LTk6bLbf27XH3njGjA
	 3EjiguGIQt3lhot/cLskjAQla3In+jdLNO0MA5r0ls7aUxZxqknCoUC7KodegU7196
	 TnXz8cn7hHKDmCFXYf7PYDxQ7qMkH88P3lLAzy7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.2 359/428] thunderbolt: Reject oversized XDomain properties responses
Date: Fri,  9 Oct 2026 16:11:36 +0200
Message-ID: <20261009140954.057702009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 80756e263846ab694984e749e8c626897331438f upstream.

tb_xdp_properties_request() allocates room for 45 data dwords in its
252-byte response buffer.  The XDomain length field is six bits wide,
however, and a malicious peer can set it to 63.  After the fixed response
fields are subtracted, the driver treats this as 48 data dwords.

Commit 322e93448d90 ("thunderbolt: Clamp XDomain response data copy to
allocation size") only bounds the copy against data_len.  If data_len is
at least 48, memcpy() reads 192 bytes from the 180-byte res->data array,
causing a 12-byte heap out-of-bounds read.  Commit 4db2bd2ed478
("thunderbolt: Limit XDomain response copy to actual frame size") limits
the earlier copy but does not constrain this header-derived length.

Reject response data lengths that exceed the allocated source buffer
before copying them into the assembled property block.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -377,6 +377,10 @@ static int tb_xdp_properties_request(str
 
 		len += sizeof(res->hdr.xd_hdr) / 4;
 		len -= sizeof(*res) / 4;
+		if (len > TB_XDP_PROPERTIES_MAX_DATA_LENGTH) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		if (res->offset != req.offset) {
 			ret = -EINVAL;


