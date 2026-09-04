Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46D7080D;
	Fri,  4 Sep 2026 05:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498935; cv=none; b=hZdgDCl7h+iYvl3RXCqa8cW3SncMO6OMJH2cQJ58XUOvT5lbiXz2qq+RNnZ+y+NbH2Uc+f02OYVuSRPvsDpqs+kOOrQGNY9MGdpXEb1LmTUvHpuwKtawK+jO78sKQRGp8U0wp6NY5SFWeLqN8ElDwmEsrIeydInet+g+XF9T554=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498935; c=relaxed/simple;
	bh=6EX5UxryhCu2kK4CLYqIxSz5adfwLRsCphlLcLsoy8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZbhSbX01jSzRQQbhs4NtfBP4ZR4SlBpCU0JTPvSfiDW8+w71nlv6oSvQuEu9o4fWJx5BhSGv9dhNLHHDzlQkZY+kZ9srMQ03cwiMdiCkReh9w6rIzgRxAVGry1b//4pR8k4d1YF2Nd6Gm+7n1OucJ0VthyXl3JwolS7ik0WWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHqbngf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHqbngf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4224A1F00A3D;
	Fri,  4 Sep 2026 05:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498933;
	bh=CaJeO3s1SLo5yKZmA/GCxDEs9aNvJYFxpCr9TqMQMLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHqbngf6S2A5DNIoySUoRP2TydPfVqLCLEBepg7NNLz5WpZ+tse+IHPwls5CtD8kj
	 vVWzreQvKlcPa8wzbORhp+EtnzrekK5j+Yf5vtGeYW4CY34XB1CQEo2KaAxax2Qgha
	 NJ8l+tA/Dv71bpxXTZ7e3L7w2CIco2hN61esHkgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 239/713] smb: client: fix ALIGN() overflow in symlink_data() error context loop
Date: Fri,  4 Sep 2026 06:53:27 +0200
Message-ID: <20260904045809.183664173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit 62656b024efc21c3230eade1a847f25871c3d2bb upstream.

The check added by commit 7d9a7f1f96cd ("smb/client: fix possible
infinite loop and oob read in symlink_data()") compared the post-ALIGN
length against the remaining buffer, but ALIGN() itself can overflow:
for ErrorDataLength near UINT32_MAX (e.g. 0xFFFFFFF9), ALIGN(x, 8)
wraps to 0, so the subsequent bounds check passes, and the loop
advances by zero bytes leaving 'p' pointing into stale data.

Fix by checking the raw ErrorDataLength against the remaining space
before applying ALIGN(), then checking again after.  Since raw_len is
bounded by the buffer, raw_len + 7 cannot overflow, so the second check
is an exact post-alignment bounds guard.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -61,7 +61,10 @@ static struct smb2_symlink_err_rsp *syml
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
-			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
+			len = le32_to_cpu(p->ErrorDataLength);
+			if (len > end - ((u8 *)p + sizeof(*p)))
+				return ERR_PTR(-EINVAL);
+			len = ALIGN(len, 8);
 			if (len > end - ((u8 *)p + sizeof(*p)))
 				return ERR_PTR(-EINVAL);
 


