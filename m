Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622871;
	b=bT+kmsAjT1Aqgi69qBSupUqWEacuQHXTKKjx0GkRY+uRY/5O//hHpmWLVGk10eEut2BU
	 AK+vmC8oUvBCp1n6Skq81LJXQRpurZNuiUf4ORv01l0xrFwuyVKiewBIfSx130Zf0otJv
	 XhHkpBKuQGGevu0NpppIb7btetnFRd2le1ZJ+rilL6EQb3bwEQiT++asMaqejzcJVt4Z0
	 o+dT+c3Jwi0p/cDSgVsWKMhVCLlaMhfBMt7TpGTF2tZwxJskS6fo83GRVp2BDw+TXWkUU
	 l7g2XW5E2Py4ycaNMv+E4UZ+13YJJw6yn0CfQzxVyOoyqKOjy/CTutqOSYIbiYpGQng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRhj1bavBqJu0ytdJtiKN90kMhQvrnd3gyKFeNdVW8c=;
	b=QVhoOANS4jfgSOkgkFaqc1Pu/6/MVo9lJ2Ddi/AHYLMvPTiepKCfRR31hdPELxhB2RNe
	 qGQ+b5Z4z1jeHPU0wovTE3OMI3pPEH+bIqNzvGeB5vl+2NFbrH8vd1oG8eNqf1ZJzkUJK
	 0tAl8IVAyRlTvD65ftOvzOOD+QWKdeD0HunY20ApQwCpastrA6uZ6D99zVksC8No5Gyj9
	 QPoPUENqE1Eyw8sBok/ebQNf2AKxkBXs1BaVKv/dJx9eFjsmzyApDYzYOYr66l8pcW4hz
	 MyFu+dG7BY39ZmZ7sVYhJEUm7euLfnv5EcKRnqnekJDhHEaGs9wgyaKUpDt6kcyeuwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O+Nz5hZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F938606A321;
	Wed, 25 Nov 2026 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O+Nz5hZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38571F000C0;
	Wed, 25 Nov 2026 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622871;
	bh=sRhj1bavBqJu0ytdJtiKN90kMhQvrnd3gyKFeNdVW8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+Nz5hZ2IHx71WakakA4e0UrSAotvK6fCb2i9E+FQv3ff+THqn8n+rzH4ZMq6m/PA
	 Ow/BHhtYvyldRi50Egistp5ifY41jp7RvUN06q7QVPa2UY66wWsIIVviBzInE21U1d
	 zbZCfk4cPn5r6BJKTj2TVHpwEBF2KUucw92Xoi9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 675/990] splice, net: avoid MSG_MORE when the bvec array fills
Date: Wed, 25 Nov 2026 15:34:02 +0100
Message-ID: <20261125143837.897674046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -865,9 +865,9 @@ ssize_t splice_to_socket(struct pipe_ino
 
 			bvec_set_page(&bvec[bc++], buf->page, seg, buf->offset);
 			remain -= seg;
+			tail++;
 			if (remain == 0 || bc >= ARRAY_SIZE(bvec))
 				break;
-			tail++;
 		}
 
 		if (!bc)


