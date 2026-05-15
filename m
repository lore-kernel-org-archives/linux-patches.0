Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B823CF67B;
	Fri, 15 May 2026 16:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862820; cv=none; b=r9QB2K9ycmLRXqVGzEgGICPlPOpBCdeVaHwl30HuY+rlva1nkUOZj/1gmu3RdBbNDgyHbNwxrPy666JpajlhInaXkxGc/AlqR6/4Npq/hJ/JFzXcUQ6nVrJP325YYYry0yIb2kQb/uBTvtFumC3tg3tOn0YaH+kJvF7teJPx6dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862820; c=relaxed/simple;
	bh=QzSC6jDMlA0HgAfcVHjprVkmQVhtFKNZL0ZgmwAEcs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIA9HewKUsvW0lvgtlbghwIN3SHtDSEDOGybN4A/uQpHx3mCcqX1bOnZH2GbUrsWPLzSSfOSlRyzGJYubCBqcNH8Z33v8aGc9R4CzTAF4o7AtPV5RW/N09sJmriYXvQll9VhAE3Ad3gQNzNrFvDKD41yvqm7iZaqvt72OiErbHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHR+Xmyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHR+Xmyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A4CC2BCB3;
	Fri, 15 May 2026 16:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862820;
	bh=QzSC6jDMlA0HgAfcVHjprVkmQVhtFKNZL0ZgmwAEcs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHR+XmyoMncgD6/Q+2cr0NyVVhW0Z7OWssq4qu61EenKk8Pk1VSIku2QBovLSgsP2
	 ypJZA+G3HWopXpEfTTy/FZ1r4W0NFd68fY6jaqylvErtuQMxrtEX3Pp4lWCcwj+Yrp
	 WTzcyTNY7DEQigM7oN2Wg3KZd0t6CfehMZr2epAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Norbert Szetei <norbert@doyensec.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 7.0 195/201] vsock: fix buffer size clamping order
Date: Fri, 15 May 2026 17:50:13 +0200
Message-ID: <20260515154702.804818445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1951,12 +1951,12 @@ static void vsock_update_buffer_size(str
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


