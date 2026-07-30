Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9EE30C618;
	Thu, 30 Jul 2026 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424787; cv=none; b=G5ZIRJFv2kE59rrPxYJX+I0Tw49i/ihvhn5kzoQqy1RmjBoO01obvMSZRVyg0nqD33Z1JwjDO+tdWMI+hxn70UHlKkpfuI9IoIxS+9RKOI+OVLgVtVI2zZ3EVV1BHcOsOlsdNKejvxgITrxbb5mshnu0ZAmpRpVM6XF0e6EvyTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424787; c=relaxed/simple;
	bh=17JjUPCVc2bgBagQAwCgCT2li1C9BOyQlSeyiOtp3qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghwORDtAftdK8pX4gSpilftgmqjaz+hwuVtpMhZDVxo2j/Q4S2bUiULct2lffHq8SEGZg3jLSQcA9G28D8oOxRiHX6dmKJwKjFyOiOJMFi0hjlEfpkKgci4Ei4dCKzP8EWJlPcY/iue/3mSAv2ham+f95nosH0li8B3fJ0+Cz7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTlAhRwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTlAhRwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB75C1F000E9;
	Thu, 30 Jul 2026 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424786;
	bh=eX5iwdzZ46l0futt20oAwgWaH1xKOgmXtJ795BzV9sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTlAhRwQZdptagalc5D3Ge3s3kgSRw98D6Ikky4yEYq8pmXtmMvkvwp6JTD97gyrL
	 OyrBZgIvDPNfrko0LYf4OOXilvxCtmfJT4CWdZywVGCX8qjTuV8Nc1tOjdOH1YDEbZ
	 Epw0pQ0NVDcUZ197ytKcLoPWLVGQJjhriRnWhWyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 517/675] libceph: refresh auth->authorizer_buf{,_len} after authorizer update
Date: Thu, 30 Jul 2026 16:14:07 +0200
Message-ID: <20260730141456.125537693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 937d61f86d377a3aa578adae7a3dfcecdddf9d89 upstream.

ceph_x_create_authorizer() caches au->buf->vec.iov_base and
au->buf->vec.iov_len in struct ceph_auth_handshake.  These
cached values are then used by the messenger connect code when
sending the authorizer.

ceph_x_update_authorizer() can rebuild the authorizer when a newer
service ticket is available.  If the rebuilt authorizer no longer
fits in the existing buffer, ceph_x_build_authorizer() drops its
reference to au->buf and allocates a new one.  If this is the final
reference, ceph_buffer_put() frees the old ceph_buffer and its
vec.iov_base, but auth->authorizer_buf still points at that freed
memory.

A subsequent msgr1 reconnect can therefore queue the stale pointer
and trigger a KASAN slab-use-after-free in _copy_from_iter() while
tcp_sendmsg() copies the authorizer.

Refresh auth->authorizer_buf and auth->authorizer_buf_len after a
successful authorizer rebuild so the messenger sends the current
buffer.

Cc: stable@vger.kernel.org
Fixes: 0bed9b5c523d ("libceph: add update_authorizer auth method")
Closes: https://lore.kernel.org/all/E378850E-106C-427B-A241-970EB2D054D7@gmail.com/
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth_x.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -781,9 +781,16 @@ static int ceph_x_update_authorizer(
 
 	au = (struct ceph_x_authorizer *)auth->authorizer;
 	if (au->secret_id < th->secret_id) {
+		int ret;
+
 		dout("ceph_x_update_authorizer service %u secret %llu < %llu\n",
 		     au->service, au->secret_id, th->secret_id);
-		return ceph_x_build_authorizer(ac, th, au);
+		ret = ceph_x_build_authorizer(ac, th, au);
+		if (ret)
+			return ret;
+
+		auth->authorizer_buf = au->buf->vec.iov_base;
+		auth->authorizer_buf_len = au->buf->vec.iov_len;
 	}
 	return 0;
 }


