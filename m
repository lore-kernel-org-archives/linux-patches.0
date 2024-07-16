Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AAA19DF9D;
	Tue, 16 Jul 2024 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144610; cv=none; b=HVxPQn2O9yb4FbW8ok0jxm45t0sYhhON3HcOGIT2haF8X6/B3+19iYMVMTdpAHzkGKo+IF3j2YKY7Ksl+9Tw5uKQo+DeerWTya4q8TwpnIDfkPA2z4FWQagiKQaR+fcDRWPOKiir/gYM9yTKc4HFNA2pG6XA6TPThdcYrJUkp4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144610; c=relaxed/simple;
	bh=j/sI52PZ98Vfl+ENunLelXAIrWuE/feMjate5cTQ9Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eq5/MEoG5H7GNf7x5cCa/kkflxxx+lphNDRGWpMcasVctk6MDgc63EQ9qsm3EDwU2BY0WkxLg9+2d2ZPgeMkj3s15KRiDJciAKCQFWDap2k4MOhnJhGHzHkC+aD8aCI5tY+EOyi6TAxft4HRenfnlo9YGZFMJGNyqfgefcaf534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnnrZs7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnnrZs7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD51AC116B1;
	Tue, 16 Jul 2024 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144610;
	bh=j/sI52PZ98Vfl+ENunLelXAIrWuE/feMjate5cTQ9Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnnrZs7Xphz+EIp6OypOqzA+QwVq5yRHJy/h2nksAMMySQf+a0hbZI9SPejo9Vb71
	 SRL7nKTkh+VZaqLSjaCY7I6J6ZRNPVPVNWUE+2sh5Pgd9G+OKF6ACMI+YSFp3G+O4p
	 TFEHaMHvCCm7FQ89AtqCB4SguW5ri42WZnDQUh64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 048/108] media: dw2102: fix a potential buffer overflow
Date: Tue, 16 Jul 2024 17:31:03 +0200
Message-ID: <20240716152747.835537982@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 1c73d0b29d04bf4082e7beb6a508895e118ee30d upstream.

As pointed by smatch:
	 drivers/media/usb/dvb-usb/dw2102.c:802 su3000_i2c_transfer() error: __builtin_memcpy() '&state->data[4]' too small (64 vs 67)

That seemss to be due to a wrong copy-and-paste.

Fixes: 0e148a522b84 ("media: dw2102: Don't translate i2c read into write")

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dw2102.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -786,7 +786,7 @@ static int su3000_i2c_transfer(struct i2
 
 			if (msg[j].flags & I2C_M_RD) {
 				/* single read */
-				if (1 + msg[j].len > sizeof(state->data)) {
+				if (4 + msg[j].len > sizeof(state->data)) {
 					warn("i2c rd: len=%d is too big!\n", msg[j].len);
 					num = -EOPNOTSUPP;
 					break;


