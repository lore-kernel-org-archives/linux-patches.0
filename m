Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E74CB67E;
	Wed,  8 Apr 2026 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673619; cv=none; b=MqYpKp2fy+MIc5/JV8CSPS0E0UgmPhHkKhsq+r+Dc2aE7bYwR2YcaysntyFqPiBCHyjW7Jt1uI35Nk+8Utw6KE9un8VQTkpNnfyt1U9qdjTjQ0M76ePydrj2T+q4NCl006fvy/CnAHPH2e2jphsGU8lu+Bo5d/iKnPWwOcGN4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673619; c=relaxed/simple;
	bh=e68E8646vTgxmwKx96sipfn2DMNQGh3hHfNDLE0yJBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCUVPXGws9iVnG24Fee5vAdi2f5h33eL7W8uSLNEJpQorlTigAnsO6ifSk/Mcm1swRZMi4FtyjrudPos3TnZx2xlBNGQ//FLG43cIrWvRuLrwGqNiwwsb8YsUy4QNmuqeZBbx5TfLxX7bTheY+k+pwuaFULaXGTysDdV0xWs630=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqKRIiPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqKRIiPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BA7C2BC9E;
	Wed,  8 Apr 2026 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673619;
	bh=e68E8646vTgxmwKx96sipfn2DMNQGh3hHfNDLE0yJBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqKRIiPFI72TKoKWba+TFhsexAGVswG61VHqqMoc3f7KauV+BbhtCPjQtSjLaOrWJ
	 5RTqMsrrju9qZEpE4gFuDu17uejrTcuAWghomX24AZ9zg1EVaTqD3FAQ2DHfyu4c3l
	 5iAgb49y0L3u3AB/seRGgHKrr4Ncx9IbB7yrINLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 024/242] io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF
Date: Wed,  8 Apr 2026 20:01:04 +0200
Message-ID: <20260408175927.975326568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 3ecd3e03144b38a21a3b70254f1b9d2e16629b09 upstream.

For a zero length transfer, io_kbuf_inc_commit() is called with !len.
Since we never enter the while loop to consume the buffers,
io_kbuf_inc_commit() ends up returning true, consuming the buffer. But
if no data was consumed, by definition it cannot have consumed the
buffer. Return false for that case.

Reported-by: Martin Michaelis <code@mgjm.de>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1553
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -34,6 +34,10 @@ struct io_provide_buf {
 
 static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
+	/* No data consumed, return false early to avoid consuming the buffer */
+	if (!len)
+		return false;
+
 	while (len) {
 		struct io_uring_buf *buf;
 		u32 buf_len, this_len;


