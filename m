Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058AB29D273;
	Tue, 26 Aug 2025 11:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208441; cv=none; b=KpuZqIanZ0iOiFbnbpsmytWyO99boXxXjcRL+1h0/3imW1rE3ssblT3dzqRILiJGxUMaLcDnAGewV5Xjb3bO8ErKFle1GhD00x16/gIIl/fJ3W5oYMgUWQUON+ZHCbut7w59zbTKAKPjkOBq3aLn77vp0TrusZMTZ4PcMHWS97I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208441; c=relaxed/simple;
	bh=M1WBdEBgY7qKETvNzC0+QafO5mcIQtVE8OvJ4JnZJCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErijA/bv74X03igGmyKXmICuqE5GIMwNwFfKksYntol8Fr8Q+npqdLR8rkGCxMIo6NGOjivDu6M1E42YcaKNOKhnJ5/qHZe+3NdEq3BJAmKrpmrfTvU8UEl+6Bm8uv82J+edGyrGv6ShMzDL+Yd8RotRlxXIJBvKXdBNYUGeHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn99+gEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn99+gEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89742C4CEF1;
	Tue, 26 Aug 2025 11:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208440;
	bh=M1WBdEBgY7qKETvNzC0+QafO5mcIQtVE8OvJ4JnZJCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kn99+gEE0xY978Ff866Lq9Fy8YDPfMD3nH+QSveGJINYjVaBdQRbKoGbPbHXMOeF2
	 u3+YtxaegoGiXhXwNRKgHK/FmH3BJDJhFiztPX20kugKEEHqBQMrP/g1J65MS69d8u
	 0SCFF9dD2dqNkpFfDYbUNrdc/niP+ybfTM/CPsC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 105/322] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:08:40 +0200
Message-ID: <20250826110918.329923514@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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


