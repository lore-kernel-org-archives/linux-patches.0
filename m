Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625722;
	b=foSJ9cpVVlDXTkcLYgFPjqydkXjLCmgcJnpFtO4KsjOGTodmHbi836U+Ij899WJIf48M
	 KFlwmMDH+xRMsMhPMOsd/69S357c9J01t5H/J+HleGBvBCHQM4z+UyjRYyNh0KjKy1PXr
	 Ih3q/wDcQeK/crq7M8jusaVjyvSAuLj9Tka6HXzKnjE7NGC/hy3SrYAF/Tm4vo/WuLyYS
	 HaSxOKfP2VcuEXL0CFHW8h8DjJi6/UwAnUxIBbEp6mH3ICl9NZF11MaAuC/Wx6awOpg7m
	 HeE/G1Ab1q+CA0Yz1Z7xEBuzlaoZCgQuOfKzn4W2AEQYmYOOfvVUT5Yjco9ImUMe3eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CAq00TjPCmuY3H8lP2JMMiVaUn1sXPq6EmMitfbrDBY=;
	b=Lyfidva70PWb5dJR8DIOQgtLXpgXyKySjaTY2fj7f2tRD2quhS25rClwODx8AWKvTgob
	 /hJFeKDChSzO6OCBYjWSiOvRWvPZ7Gt0Zzm1XolAltlntuISVRiyiD4sWmv++rXthUeph
	 Paz/W1sMxOY8gZlLgGiVzX/gTjycngc8SohzP1Pog7SPWJUNGEaTsS1vB29WhYRJ0gTDP
	 rtFYnf+pNIcr0ssKg3aEvMVb6c6N03qLeWUWZIN+XQrI9XuFFg4Z7aVpcH9XM2Fr5qEL+
	 I76vdNY8TxcQ0gImrDPo3SA2vZtIWZdmn0Ju55usu42YxaEmVgaTx7/jqaQryAuACYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyOznbU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5086C606A323;
	Wed, 25 Nov 2026 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyOznbU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A111F1F000C6;
	Wed, 25 Nov 2026 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625722;
	bh=CAq00TjPCmuY3H8lP2JMMiVaUn1sXPq6EmMitfbrDBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyOznbU2keKFKhXyxikQ7tAApkXiYvBuTqzdwd8yB5TCpY/OBZLSVgc4heZ4YVFa9
	 95zp3Uk3EYxxBLzUtGELkrdvgXAE5Ft6BMzvNU1XyHQy0kdZ0e1tNut8uNxMLXYzQB
	 vp49KhTbkR43Hq6Cv87lCTV54W28G53zlwr4f8NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 566/816] splice, net: avoid MSG_MORE when the bvec array fills
Date: Wed, 25 Nov 2026 15:35:14 +0100
Message-ID: <20261125143902.282989266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -871,9 +871,9 @@ ssize_t splice_to_socket(struct pipe_ino
 
 			bvec_set_page(&bvec[bc++], buf->page, seg, buf->offset);
 			remain -= seg;
+			tail++;
 			if (remain == 0 || bc >= ARRAY_SIZE(bvec))
 				break;
-			tail++;
 		}
 
 		if (!bc)


