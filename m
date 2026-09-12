Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7D3382CB;
	Sat, 12 Sep 2026 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242099; cv=none; b=ChZfhwqh3rSkebvAH+PBHiiriqeZjAOoSkLzjIV7l90AREQ8tKj41UcbYe3+eDjz0x9aUrhQotm7pT7XNin/rt1aFTOjxmbD6Lh9v6pDbijfieS8NXRzv7mIuMOSiZZsnTYyzSYSNSmkLA3izyUsxlWR1h/ILs2ejmtSOwGKkio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242099; c=relaxed/simple;
	bh=XeZienH1xgvPSzTi32eGFkE+zLvqpbJCSOCplXyRZcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6TdfVcPh9edBJ7GrDyqa5kZAcYlKf2/OJF+AwUYV528K+qI7ECiYrrXsV/toV1DzPxwGLOEkq0AUHZYdQ+h8SGL4hEtUflxTWtts60LaFk4nFKTMm6fijdFyRoJ2jVrdDA0xB1wGcLwVsOzoAc8i5K+/AjLzPuNG015XdHNRNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+VZ4FpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+VZ4FpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFBD1F000FF;
	Sat, 12 Sep 2026 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242098;
	bh=J0OihpxnKBXffCYjDUJ19ODynHSlBTfsSBwO6VlQBWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+VZ4FpFpPJSHmgHPNeqWKPSG1hixulxlAf8MDYdmXziT/BPWDSY7EqsEmuF4QT8j
	 HFFA9d5QhH6C9WinPQ3BzlHGscsh4MzmYYjnSPFgM4K+wh4NPWb9bjW5xXbchAFTaN
	 LxDcTB+/Coy4fAIJGRFtIvtAOdzCSRX8YZjEVbHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 283/798] media: s2255: bound JPEG frame size before copying into the buffer
Date: Sat, 12 Sep 2026 08:58:31 +0200
Message-ID: <20260912065523.647075039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit e504cc888f42999dd76b6a43788c422610f2aad2 upstream.

s2255_fillbuff() memcpy()s vc->jpg_size bytes of a captured JPEG/MJPEG
frame into the vb2 plane.  vc->jpg_size is taken verbatim from the
S2255_MARKER_FRAME header the device sends (pdword[4] in save_frame())
and, unlike the frame payload length just above it, is never bounded:

	payload = le32_to_cpu(pdword[3]);
	if (payload > vc->req_image_size)	/* payload is checked ... */
		return -EINVAL;
	vc->pkt_size = payload;
	vc->jpg_size = le32_to_cpu(pdword[4]);	/* ... jpg_size is not */

A malicious or malfunctioning device can therefore report a jpg_size
larger than the destination vb2 plane, and the memcpy() writes past it.
jpg_size is a signed int, so a value with the top bit set also turns
into a huge length.

Reject a frame whose jpg_size is negative or exceeds the plane size
before copying it.

Fixes: 38f993ad8b1f ("V4L/DVB (8125): This driver adds support for the Sensoray 2255 devices.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/s2255/s2255drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -617,6 +617,12 @@ static void s2255_fillbuff(struct s2255_
 			break;
 		case V4L2_PIX_FMT_JPEG:
 		case V4L2_PIX_FMT_MJPEG:
+			if (jpgsize < 0 ||
+			    jpgsize > vb2_plane_size(&buf->vb.vb2_buf, 0)) {
+				dprintk(dev, 1, "bad JPEG frame size %d\n",
+					jpgsize);
+				break;
+			}
 			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, jpgsize);
 			memcpy(vbuf, tmpbuf, jpgsize);
 			break;


