Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23EA370D4F;
	Thu, 30 Jul 2026 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427830; cv=none; b=cTJUp4uPrsHFEpJv+PLOBZzxK23ywIRW+P3/JpNZTVw6FzWqccDKjy4fMypqwl4I8jRG7xHmAfJf4iEw5Be99+RkepMflZklXmf9hyyNn69RjWA5m12X/uXlDo10s/qwpdOmfornz6Bp8RHANINP/xu4AHiW2nFPxw6v/OqZVrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427830; c=relaxed/simple;
	bh=LSB66yfdrNr89sMjmz+C6vWti3qdZxPo6AdAIspsP5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mbp7yNFPIUKTUMKdAIIWsPFsICnUajzgzMypfSt7uTZQgWfbCCtGCeJRiYafMDsPgHHo5tPlijBnWd+pLOL0iTqu9cqRZ0ibd+AUjWLXKL6xEjWxWuzePGWA2cf58fXY3XY0Uy/bOeXWkg/UL1U/ayQy6PEV+HqTEY7xLVEnOXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUz4VTF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUz4VTF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5685D1F000E9;
	Thu, 30 Jul 2026 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427828;
	bh=iK7PRdz83YR31pYCREq/JNIcma4sduXals4mkvzNVpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUz4VTF3B3w+srSOd32jrKNG6Y7bB+OAp1sO9zhRi2mgLrsYpBPMYki5MXIdLIGAL
	 APuv6Wi5V1v9ASg1Kz8+imj5y7Iam/Fi7qCXDUeelsEw4GiTCgkKZi7ddWUZFLTaQd
	 CR9gmIJLYSPPJjmrRlt8EsEnMKBkgJn72f/d+LYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 307/484] libceph: refresh auth->authorizer_buf{,_len} after authorizer update
Date: Thu, 30 Jul 2026 16:13:24 +0200
Message-ID: <20260730141430.158540049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


