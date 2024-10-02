Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317192BAF9;
	Wed,  2 Oct 2024 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876779; cv=none; b=UwxGINTFqTonVDWW1+zxfu4CzAxqbiV04BKhTwdyKhRdaqJJFQ/HA35Kq4UrQEuEegzZQPlbjCe8gwB6GSMgw7SCX7mgtFik2+t4kocm5pAFvjcFhqG0NB9RHiGM5Biou4Lg+2cajzDc6MkN31F16IhCWmIsw2bDSI3x3KMAs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876779; c=relaxed/simple;
	bh=ZuEvHSLEJYz26slqm6bDJmnR/gT2OJEKlHEjIpba8Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THZosFnlXvgXZcbWFBnzjkBiOy/QFc4WtblHdfpnuRrnReUSHSJ1U8jPXlStl3TYCosVWFlD2/PJindZ2xJOmnz20tzSxEoWf7iWHKob4zPbziQolnIgBOpoXrVu+rK5viFfhxQp6fATFU5nigOIzJHD68Z2zZMbxcjK97cf/v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrSHY7Le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrSHY7Le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC45C4CEC2;
	Wed,  2 Oct 2024 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876779;
	bh=ZuEvHSLEJYz26slqm6bDJmnR/gT2OJEKlHEjIpba8Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrSHY7LezpNgXqNBStwTQWhWyEp1M5HflLBKq+JZY35mQNwGc94p2SZD+Wmm+4bX7
	 vcDVupAwdHaQxT8Z1a+UxvKtN9SZYCtkOB9OSYX0WrBZ1Vmwoe3bHJlfopELaViF2H
	 EsSO97xAipee8sScVAnkSs6nYUYvG++Up6KzaZIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.11 527/695] Revert "media: tuners: fix error return code of hybrid_tuner_request_state()"
Date: Wed,  2 Oct 2024 14:58:45 +0200
Message-ID: <20241002125843.532058100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


