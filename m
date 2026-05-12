Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0A3C09F7;
	Tue, 12 May 2026 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608481; cv=none; b=pxKAmhiHbmLRw/xeL1nJpki/nsPzOyZyEmspKf1j3a7F5+iX4TkpmhCL5o/5ZU4YQjZjhREYI1Wl2Qumegn72gCkf1J+c70pIZ8Tpb6WDOWCyg74lCVtIEfatz99gJH8Ob04n5LTSlZA+GlcF2+6AsQhTnAVHm4busBEZFDFiFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608481; c=relaxed/simple;
	bh=fmXHsKy2ym91bK80o8eS8hHJV0rXFfllkEv8y/DtE3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyuN9GL8uaPr+rHpYeuU+dYBuJUVBGS+iBZAra65BJSQcQ83TlBcrJ5F5oloX/V5T3d1MyEWF4I7O249h+euNxhap8LOTquzJh9as1ASAoUw+oD8uDjOgyp699EgLDAJinbjO0ncR9ZV7FKwT0+uZTmHLv3tzBq/GgrtSo8xxyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLjzYfBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLjzYfBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A3CC2BCB0;
	Tue, 12 May 2026 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608481;
	bh=fmXHsKy2ym91bK80o8eS8hHJV0rXFfllkEv8y/DtE3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLjzYfBg5E23W8wYdKU6vVlxqPqwPaExk6Y+wk0aras9z5m+Ec58NEtPtrf6imm5V
	 HJTvGhfE9aadqtHxPUS7Vu0WP/zPu2mxL6UECravgfRIoStiO9E1hQPfQUCk4k9Ddj
	 iQLaAB4rSmcZusyjc9TKqSReVJOf2Qk1DFL8eS9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 096/270] pseries/papr-hvpipe: Prevent kernel stack memory leak to userspace
Date: Tue, 12 May 2026 19:38:17 +0200
Message-ID: <20260512173940.480931697@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit cefeed44296261173a806bef988b26bc565da4be upstream.

The hdr variable is allocated on the stack and only hdr.version and
hdr.flags are initialized explicitly. Because the struct papr_hvpipe_hdr
contains reserved padding bytes (reserved[3] and reserved2[40]), these
could leak the uninitialized bytes to userspace after copy_to_user().

This patch fixes that by initializing the whole struct to 0.

Cc: stable@vger.kernel.org
Fixes: cebdb522fd3ed ("powerpc/pseries: Receive payload with ibm,receive-hvpipe-msg RTAS")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/7bfe03b65a282c856ed8182d1871bb973c0b78f2.1777606826.git.ritesh.list@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/papr-hvpipe.c b/arch/powerpc/platforms/pseries/papr-hvpipe.c
index c41d45e1986d..3392874ebdf6 100644
--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -327,7 +327,7 @@ static ssize_t papr_hvpipe_handle_read(struct file *file,
 {
 
 	struct hvpipe_source_info *src_info = file->private_data;
-	struct papr_hvpipe_hdr hdr;
+	struct papr_hvpipe_hdr hdr = {};
 	long ret;
 
 	/*
-- 
2.54.0



