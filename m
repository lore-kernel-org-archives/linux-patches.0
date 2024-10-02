Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B28C1D0F59;
	Wed,  2 Oct 2024 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880369; cv=none; b=ZVHG7S1Q1Ftp1wWx7OARDdJtuZ1diD2Ya9mz73ybtchkh9xDhXF6EWC6eOts+fxXAaN400Si9F/CTpa/StAD+3sin2KnkEcg02LCn1C95BHSfekao+jSSu/xucvJ4/U8zrBN+tHzT2DbBkNf/XBC2v3eD8lyC8jNK5g2mSzOM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880369; c=relaxed/simple;
	bh=5spiVBe5o8H96ouncjrWRve+xESJELEcIB2u9HIAiSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaFi9rOkOehQav38eTg8szCCYemscgH+49DLXelxX/OwTKcue7x5si/mlrUxgPkZKGxMA6fTSMbF5u7QDmzUPa8eVCt28zFITk7DZ82JB5x0jPAXNVfF0KUZsyxwO/ZkiHbOOoY6W2xg8zCRlSz5vwjcd4Eql+qsLoVnOdMmhjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRVrLyrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRVrLyrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B53C4CECD;
	Wed,  2 Oct 2024 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880369;
	bh=5spiVBe5o8H96ouncjrWRve+xESJELEcIB2u9HIAiSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRVrLyrQmT3b2L/olsZ7bJRFbL0nDGiTjUhEbKtGLuC07Ls2Gh09m1kkr4eALCJk9
	 Mp9h6/TXY+1B98XE2dgFuDsSyKyLWLGeTl2bQPZELwyb7EJSAfmdMRFGrrN/T5nvuA
	 /VCoTQRRavXUI35myswWVQQB89gQfbR1x2mSyIOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 404/538] Revert "media: tuners: fix error return code of hybrid_tuner_request_state()"
Date: Wed,  2 Oct 2024 15:00:43 +0200
Message-ID: <20241002125808.384070733@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

commit e25cc4be4616fcf5689622b3226d648aab253cdb upstream.

This reverts commit b9302fa7ed979e84b454e4ca92192cf485a4ed41.

As Fedor Pchelkin pointed out, this commit violates the
convention of using the macro return value, which causes errors.
For example, in functions tda18271_attach(), xc5000_attach(),
simple_tuner_attach().

Link: https://lore.kernel.org/linux-media/20240424202031.syigrtrtipbq5f2l@fpc/
Suggested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/tuners/tuner-i2c.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/tuners/tuner-i2c.h
+++ b/drivers/media/tuners/tuner-i2c.h
@@ -133,10 +133,8 @@ static inline int tuner_i2c_xfer_send_re
 	}								\
 	if (0 == __ret) {						\
 		state = kzalloc(sizeof(type), GFP_KERNEL);		\
-		if (!state) {						\
-			__ret = -ENOMEM;				\
+		if (NULL == state)					\
 			goto __fail;					\
-		}							\
 		state->i2c_props.addr = i2caddr;			\
 		state->i2c_props.adap = i2cadap;			\
 		state->i2c_props.name = devname;			\


