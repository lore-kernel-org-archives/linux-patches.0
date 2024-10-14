Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886B611E;
	Mon, 14 Oct 2024 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918319; cv=none; b=Wge35O8XzryWEG9SCsYGDQm6SDJ3ukC1tVtgwhxH7Msnx6P6hwPKPCc5bG+kEzdonqp2Xzfs2gIIx+SlKb3Gwd/91Q1IQdeJ+MQstbKti6UL+ry76Eaghwh0lk73yE8TgefYW2UQ+hGMupB86cCZuEbqap3fUNRteE/Ayo4/ORk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918319; c=relaxed/simple;
	bh=eUrhrVdOrgAX4Jln1YNhOW4I0lsUiu4wWHV8oL0kfQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijTxKSQavJlhGGzcdwO4kMBPHkrxlSW5wq9hPtsJTm5kXuQwE6yatV0AhFuSJkZ5NFfDWP27/x4Vo35pbkRsaylSNeKR1K84/wEDJl4iqW7M7NEaCCBgpKCFoPfOZC1axQk5AVFHqcI//lxuT1M9t6AY0LZMKwuKHYlRfV2iowQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEAbz2X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEAbz2X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A2AC4CEC3;
	Mon, 14 Oct 2024 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918319;
	bh=eUrhrVdOrgAX4Jln1YNhOW4I0lsUiu4wWHV8oL0kfQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEAbz2X3FvxflNy3AHYpq4SMqCOFKM7W7Hn7Lmp8Etw2Vy3I8ZVlanNZp+DT4ffca
	 8RUztoRW/dpH368peXZPZJPYrjyF2moZ46+9P2q+32wRsU5m8IufIkG3c6vLyr54lb
	 ZftoCz37dx5oQF/1rnzFdRmySxCih6KHXzkgloHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 286/798] Revert "media: tuners: fix error return code of hybrid_tuner_request_state()"
Date: Mon, 14 Oct 2024 16:14:00 +0200
Message-ID: <20241014141229.181140061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


