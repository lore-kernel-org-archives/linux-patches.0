Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BE32E5B0E;
	Tue,  8 Jul 2025 16:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992609; cv=none; b=lrSJgHSAt2I8/Vt69AtiHsvY8kazsWHslocWZW59kv0ogp7Hqe8mR3B41AdsfEbdMVVsm1GCCUEBKCkOp90iRrRTI/27R5KAmcaNxTA+Vs2ijXMGTGQra6hsBEHlS1lviaw28KIHIUxgqxOBls+gkS1Hq8dLbo1CcDvxo1WvYXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992609; c=relaxed/simple;
	bh=6DwpnSGG8ocpqm9zM/Rz3DA44n4TaRwY8GPttUHOkME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR6rtko4RzVUxoz/DXdyvmLyk7acPWWy3W6Mc6zQ9LeQdHSi4mkPjHOtvb124irh8bXeCstyeorsNlL9uAeaBdQkCRsAraM3h3S0baMqC1CnEwOqQC0y0PRSSswssK5CM2+DQ+uat2GksJAfKYnHYSClTbuZZXu8Cy12pw1y1EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9jX5ZKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9jX5ZKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D1DC4CEF6;
	Tue,  8 Jul 2025 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992609;
	bh=6DwpnSGG8ocpqm9zM/Rz3DA44n4TaRwY8GPttUHOkME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9jX5ZKRU2arLE/5HF6FsqF3anB330twoMyMX/gIATfK/EEkR7lg+Quot7VNzcNPZ
	 MbjTXALqUvdFeNQ+JIkHYzq84xspZ8QYcgRCjvpDd2sKp+9UOz7yyFljssIzcC2FqF
	 NeOVP3iMT8uwEbZxM7kXGFqRvN1XUhcdIJr0/lOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunshui Jiang <jiangyunshui@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 020/232] Input: cs40l50-vibra - fix potential NULL dereference in cs40l50_upload_owt()
Date: Tue,  8 Jul 2025 18:20:16 +0200
Message-ID: <20250708162241.962898365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunshui Jiang <jiangyunshui@kylinos.cn>

commit 4cf65845fdd09d711fc7546d60c9abe010956922 upstream.

The cs40l50_upload_owt() function allocates memory via kmalloc()
without checking for allocation failure, which could lead to a
NULL pointer dereference.

Return -ENOMEM in case allocation fails.

Signed-off-by: Yunshui Jiang <jiangyunshui@kylinos.cn>
Fixes: c38fe1bb5d21 ("Input: cs40l50 - Add support for the CS40L50 haptic driver")
Link: https://lore.kernel.org/r/20250704024010.2353841-1-jiangyunshui@kylinos.cn
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/cs40l50-vibra.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/misc/cs40l50-vibra.c b/drivers/input/misc/cs40l50-vibra.c
index dce3b0ec8cf3..330f09123631 100644
--- a/drivers/input/misc/cs40l50-vibra.c
+++ b/drivers/input/misc/cs40l50-vibra.c
@@ -238,6 +238,8 @@ static int cs40l50_upload_owt(struct cs40l50_work *work_data)
 	header.data_words = len / sizeof(u32);
 
 	new_owt_effect_data = kmalloc(sizeof(header) + len, GFP_KERNEL);
+	if (!new_owt_effect_data)
+		return -ENOMEM;
 
 	memcpy(new_owt_effect_data, &header, sizeof(header));
 	memcpy(new_owt_effect_data + sizeof(header), work_data->custom_data, len);
-- 
2.50.0



