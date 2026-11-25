Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619434;
	b=FEwV1jN0UpvV1dvYctsxMRiLDxstkG5Sx3ZCFgogKD6id8dR9/WX3CQCtdP4egt8HOP9
	 Mr5EizpoqBENMBSUvDoxmc5/1GcuWSWtrgVHLjsyfGvMl8cIRsvnENdpSdp2ilejKMkNh
	 WwtBT/eIGQ9xgaghjgaWI0sYYiaFwLF+hvyR1zH4/bdVw92/5Yn3RlqjnjYdXhDxKQNvb
	 dOcscBQ9kjU+LoAqBRTc4R2k5bNTADiVxP/1EhASVlFPZZnJ173zcS/zff5BcGEsebmcO
	 gb1tCaJalW2KdMtsgwHLyPBV2uu3P7yjdD5sRcfa+x+DXnOdddgIOI/z9EfdolLeW4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhUbE7vgAK86QCx5Wb1CYaCu04vobwf82P/gFBmgFqA=;
	b=e5U/RhrbfQrn+NhPcjeRzQazEyVvecHZcmePjlBemBP+ng22TIWtX3eTfJJ93Eby47/S
	 MGtNEEt73qz16pdI+4leRPHZhtO5BK+QpU+dWBoeHC/2dBmMALSC5R+QSNqNH1GZX5n61
	 4aoVy21Om0SslDYc/EPqzk4XrEZJcuC6GVoz3l//GVCZzixDPvn/5wq6j2RtCRUBVBQo3
	 D3SDAPG2zzi55w60jZ15/xtRb6Kt/YqPKDIWmBfK7loPE1VM3MPkV5bmJk0uPe4TODIu9
	 rUc9+LkJsgqutSE1VfQs800LeHjhPwJTbipUYQmW4mCELNFsc9slq9uztd5fy/lqGMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDOlC62D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CA6606A69A;
	Wed, 25 Nov 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDOlC62D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED441F000C0;
	Wed, 25 Nov 2026 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619434;
	bh=PhUbE7vgAK86QCx5Wb1CYaCu04vobwf82P/gFBmgFqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDOlC62DQB8r5hMPm2UDLGSN2lVZzWsdwhYFo/MWxZGBE3gepecRKUIUmCVXH4tai
	 jopW1cMoTaFwlAq7/ScVo6wukwkoySEtidhgkROJvOKwkBxxvAcvK8Jcf38iC3Za3F
	 ehLNY6eJRioBmsGSjQihWq37xms1SJrNFpr1+69c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0593/1005] splice, net: avoid MSG_MORE when the bvec array fills
Date: Wed, 25 Nov 2026 15:32:11 +0100
Message-ID: <20261125143835.634541555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

commit 8eaa35c6c29ae669949f4b5b0814c3d34c8ed658 upstream.

splice_to_socket() leaves tail at the last included pipe buffer when
its 16-entry bvec array fills. If the requested length exceeds the
available pipe data, pipe_occupancy() counts that buffer again and sets
MSG_MORE even though the pipe is empty. Small TCP transfers can then be
delayed until the cork timeout expires.

Advance tail before checking the array limit so the occupancy test
counts only pipe buffers that have not been included in the send.

Fixes: ca2d49f77ce4 ("splice, net: Fix splice_to_socket() to handle pipe bufs larger than a page")
Cc: stable@vger.kernel.org
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261031095922.3577591-2-thnkslprpt@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -863,9 +863,9 @@ ssize_t splice_to_socket(struct pipe_ino
 
 			bvec_set_page(&bvec[bc++], buf->page, seg, buf->offset);
 			remain -= seg;
+			tail++;
 			if (remain == 0 || bc >= ARRAY_SIZE(bvec))
 				break;
-			tail++;
 		}
 
 		if (!bc)


