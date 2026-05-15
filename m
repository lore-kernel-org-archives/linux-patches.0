Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8ED3C9896;
	Fri, 15 May 2026 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861796; cv=none; b=UXcqJOyeo6Zsq++e5+2aHqmxeGlx9fipqH3NZA0Dbpc1K21rW/NovvWa2LEMA3uT+YMKNuKx8jxwcDrrfrZEqbsoORReqYHz6HuDCXYcycDgrtluVR6QhILY16f4O35bj8XoEtRkhksSUmUIqcSkTGeztBSFmEBzMCRbU1Cdp3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861796; c=relaxed/simple;
	bh=mz2/inB1bQmhUCKE9kelncqYjubR7uOoSGmRDzbUbZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXxnXVBVd7vasEU7mY8aqs/or1P94deVztOrW+OowBlOi9TVj85xQM2qxAo+V9VD5y8Dm3rz+gZDjRGRF/cq6q00xpgEMdIkkgJ9Z4KK5cSiY0DVjS6SIu36MTposxBJ1HXCYrM+a7q+j1Gi3+e8MH8sBnq053WMiKjkgQvxRdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6gxZ2p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6gxZ2p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57FCC2BCB0;
	Fri, 15 May 2026 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861796;
	bh=mz2/inB1bQmhUCKE9kelncqYjubR7uOoSGmRDzbUbZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6gxZ2p+M/Qazlgy5v0uX1r/b5s5/l/9ene5ywF7CJEXaKqSv+Xbynl6ojkPl9gMr
	 g+wfiUEwSOaElWn0LsKvFZRnNxHB5+4axXAfv1NyZCVlAPogV+ZNiO03cjFt2S7hB7
	 DuTsoEiGFaSc6/Hm4jOa9OpFnBaGEG0O0caFhjCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Norbert Szetei <norbert@doyensec.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 6.6 464/474] vsock: fix buffer size clamping order
Date: Fri, 15 May 2026 17:49:33 +0200
Message-ID: <20260515154725.145750423@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit d114bfdc9b76bf93b881e195b7ec957c14227bab upstream.

In vsock_update_buffer_size(), the buffer size was being clamped to the
maximum first, and then to the minimum. If a user sets a minimum buffer
size larger than the maximum, the minimum check overrides the maximum
check, inverting the constraint.

This breaks the intended socket memory boundaries by allowing the
vsk->buffer_size to grow beyond the configured vsk->buffer_max_size.

Fix this by checking the minimum first, and then the maximum. This
ensures the buffer size never exceeds the buffer_max_size.

Fixes: b9f2b0ffde0c ("vsock: handle buffer_size sockopts in the core")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/180118C5-8BCF-4A63-A305-4EE53A34AB9C@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1728,12 +1728,12 @@ static void vsock_update_buffer_size(str
 				     const struct vsock_transport *transport,
 				     u64 val)
 {
-	if (val > vsk->buffer_max_size)
-		val = vsk->buffer_max_size;
-
 	if (val < vsk->buffer_min_size)
 		val = vsk->buffer_min_size;
 
+	if (val > vsk->buffer_max_size)
+		val = vsk->buffer_max_size;
+
 	if (val != vsk->buffer_size &&
 	    transport && transport->notify_buffer_size)
 		transport->notify_buffer_size(vsk, &val);


