Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CFA352081;
	Tue, 26 Aug 2025 14:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218064; cv=none; b=cF5fhkF2M5J/7nGOwrldaYVe7mPje9Tg9kV//ymQGbcwi7Mse34AK47iiJ7NqV3Co2aQTylabBF2l2tx0iH+mkYWlIsF/BD9m1s2fPwRRECGl9mXrwcHFKADnGsO0mv078PM3HFTPZTqyV2eJfZK38PxZAUQYKLS6DcoqUAnZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218064; c=relaxed/simple;
	bh=zZjhUOE075Uj91PBxZ2H2O2+K4xkA83bJj1M/IdrMx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFigKuE7b+kDPOPjbtR+/dABSInIcaQ9eUo8hzrM1yLIK8bl3PHNp8hn8NdnoEPICSNuf40ovMsz4hjJYwExo2VXzCDKpfxnMKdRiyI0EY0FrapMkEQA1MtMeAuNOczNGrTAYMG+fqXmbp6E4e7UVHHOe71Q7nV2sQS++gyAgUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5Zixpjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5Zixpjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C0FC4CEF1;
	Tue, 26 Aug 2025 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218064;
	bh=zZjhUOE075Uj91PBxZ2H2O2+K4xkA83bJj1M/IdrMx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5Zixpjvn1I5kiRCWkbX2KVgTaPOGL+T/9uW++rGsvLwcQU/vjw1WsWUwtRUIe2QE
	 CkjDKWlxn28xazcP+z5C9y3GRkAZZTFqAkGiRu6jW5vG1Hyiak3ljt5+sIzLuiuKFH
	 pzXV6PWkDLGx53YaqOB7y9VAtnbiBmZpGYQfB7YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 380/523] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:09:50 +0200
Message-ID: <20250826110933.837308360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludwig Disterhof <ludwig@disterhof.eu>

commit 7e40e0bb778907b2441bff68d73c3eb6b6cd319f upstream.

When an program is streaming (ffplay) and another program (qv4l2)
changes the TV standard from NTSC to PAL, the kernel crashes due to trying
to copy to unmapped memory.

Changing from NTSC to PAL increases the resolution in the usbtv struct,
but the video plane buffer isn't adjusted, so it overflows.

Fixes: 0e0fe3958fdd13d ("[media] usbtv: Add support for PAL video source")
Cc: stable@vger.kernel.org
Signed-off-by: Ludwig Disterhof <ludwig@disterhof.eu>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: call vb2_is_busy instead of vb2_is_streaming]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-video.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -73,6 +73,10 @@ static int usbtv_configure_for_norm(stru
 	}
 
 	if (params) {
+		if (vb2_is_busy(&usbtv->vb2q) &&
+		    (usbtv->width != params->cap_width ||
+		     usbtv->height != params->cap_height))
+			return -EBUSY;
 		usbtv->width = params->cap_width;
 		usbtv->height = params->cap_height;
 		usbtv->n_chunks = usbtv->width * usbtv->height


