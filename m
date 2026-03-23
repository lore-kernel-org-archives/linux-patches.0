Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6262517AF;
	Mon, 23 Mar 2026 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282775; cv=none; b=E3PVPcnZIxWMl8e8nm4GDKPg4yTBJtwu3K/1+kcPkTqkK4RMlmWbYemJUMEDaM+kbwdHrmUDKEeQu4LfI/r3ckDl4EEFxaCe6z6m3E+ecQpwgCYWAQmCUPm/hX03rW9KxkQ18/uyv1C2bVpkwM+LJfFduRmr1ZYk9T+rUKmNO0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282775; c=relaxed/simple;
	bh=Rx0URNXr0RYqMT9HsZuGYJQtZOe8qXiZeermIxuxDWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ1himtOz62qKwLAdeCz7YMr5/3LYxN0/matudlJ3/xcLi5NNb3cm0guSYhvR08HH/UD+KoDO6Q6lO1RQ7pvmfoCQTu7pxYw8mlKksID70JaK7x/iox87VgQtRywVULVJdbqHjn5vrMm3cIWhbg1h4R0rAKMLSgRfBFQ/bZ+1IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rE98TByo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rE98TByo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16401C4CEF7;
	Mon, 23 Mar 2026 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282775;
	bh=Rx0URNXr0RYqMT9HsZuGYJQtZOe8qXiZeermIxuxDWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rE98TByo/E4XEoApX2tfK/nKJ/ZebfNH39X1N25UcYJsHYYDTyO1oH0HifRB+80rn
	 z79ogrwt/IYdsD5OQhtTQ44QPifd6RA9yXzEkgOwgDp1Ekpm7ot2/18DR26DH3fu3L
	 deUoAH3K9M3URiNbroROtw+p2yUX8/RcKGVEwzW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Silver <arielsilver77@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 237/481] media: dvb-net: fix OOB access in ULE extension header tables
Date: Mon, 23 Mar 2026 14:43:39 +0100
Message-ID: <20260323134530.916322645@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Ariel Silver <arielsilver77@gmail.com>

commit 24d87712727a5017ad142d63940589a36cd25647 upstream.

The ule_mandatory_ext_handlers[] and ule_optional_ext_handlers[] tables
in handle_one_ule_extension() are declared with 255 elements (valid
indices 0-254), but the index htype is derived from network-controlled
data as (ule_sndu_type & 0x00FF), giving a range of 0-255. When
htype equals 255, an out-of-bounds read occurs on the function pointer
table, and the OOB value may be called as a function pointer.

Add a bounds check on htype against the array size before either table
is accessed. Out-of-range values now cause the SNDU to be discarded.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Ariel Silver <arielsilver77@gmail.com>
Signed-off-by: Ariel Silver <arielsilver77@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_net.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -228,6 +228,9 @@ static int handle_one_ule_extension( str
 	unsigned char hlen = (p->ule_sndu_type & 0x0700) >> 8;
 	unsigned char htype = p->ule_sndu_type & 0x00FF;
 
+	if (htype >= ARRAY_SIZE(ule_mandatory_ext_handlers))
+		return -1;
+
 	/* Discriminate mandatory and optional extension headers. */
 	if (hlen == 0) {
 		/* Mandatory extension header */


