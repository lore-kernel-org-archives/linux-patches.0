Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8427D53B;
	Tue, 16 Jul 2024 15:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144345; cv=none; b=r/EK5TTkKNamfVenLWu8qUxBG5xrKFBOm0rckANMrBIOFKB1p3ojhje3Dc30AKI59p6fFGbsn/kqHouwPuFPlsbgI44qPRXbQELl76qVwxScnq2Vd3aOYMSxK7M+hkwwBaSowATRaHFhapwnH3Td+IC+jbxlbOTG6cJZCXYORXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144345; c=relaxed/simple;
	bh=hk/L5x8AYYzMzjam3YDb17mJ2RcC3QQ/Tx5DJuUJqFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9KpRQ6eU1p0wAzW6VFSUz+8EGhoXISIfLoL4pt/4T4sAbmRUIwKLF/uIl1LvQkB1X4c3XELsRMXYIn+hHZDzl8jn/NlK2PckVdzwZao2L7DjSF3E0ITQvSOb54RZB+h+I4A5QMcssjQ9ZRASBoyM4akJXNWD5ctVf+unWB8tC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jyt1ypvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jyt1ypvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C646C116B1;
	Tue, 16 Jul 2024 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144345;
	bh=hk/L5x8AYYzMzjam3YDb17mJ2RcC3QQ/Tx5DJuUJqFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jyt1ypvCa0DsFbB/i9j7cDU5uaeV4kMsq88eJT4aAANsN/tphmvkfXGraA8stnWea
	 lxsojZqKLbiZ1pDG2uTlsQ6bvTuHV8INWsWVwLCorotg4U1vA4Ii71DM6p4ODJO8rD
	 WdTvSZoXokT8+pXJnvugC1P7vDeuSCYLgY2Np8ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 41/78] media: dw2102: fix a potential buffer overflow
Date: Tue, 16 Jul 2024 17:31:13 +0200
Message-ID: <20240716152742.226332185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


