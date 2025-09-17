Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A03A13B2A4;
	Wed, 17 Sep 2025 12:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113748; cv=none; b=by1h7n9RLIJ607bCpELXJBfy27VYemcbcovrbsUuer4PWKBMuS1hTIx7wo+zw9angeTMfaO0/vtu/m4ynyazt9RSIC4bQjtSUj3wZXwamEdQ5oZgUDxQR6QSAXyRwVG/yQbXz0Y0T+yfkhhpHc/gVWK7UgX6h6CAaL9RK3SnDAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113748; c=relaxed/simple;
	bh=fBPrxqricr63iwKLnQloDxjNhI4NLCICt4RHyyqnTEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3CNyofcgZ+VG/qPTZVsy3m5rlpdHoBsLlbpSvHZyKWxgUhyEnsRAY8D2A82eUM6sH14JqsxbiFifGqKdCKwfg+i0IaFZRvC1tTrf0uS7OqeT3kTOCsaLkySg0s1DGGwrkeWC2xL/lQqSLh/nTJJnFozhlHpmFIa2uVzLSxHfDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOMVrOok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOMVrOok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768E4C4CEF0;
	Wed, 17 Sep 2025 12:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113747;
	bh=fBPrxqricr63iwKLnQloDxjNhI4NLCICt4RHyyqnTEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOMVrOokOERbZcC18I5CqJpQOFrV3+bwz2pl4oBW2C6xuiWtid9NfyYRf45xhf72/
	 PdpuhnsuW7iOF6aiAvMVZ6bKlnlno4LoB9s6+zZA6JzycIBKf96VQ7cafU7W1dWl7P
	 x3+0wz5+PFzM1/LVvP7W/EwJ4sTyi3KhjG8LC9TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 040/101] fuse: check if copy_file_range() returns larger than requested size
Date: Wed, 17 Sep 2025 14:34:23 +0200
Message-ID: <20250917123337.814708067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit e5203209b3935041dac541bc5b37efb44220cc0b upstream.

Just like write(), copy_file_range() should check if the return value is
less or equal to the requested number of bytes.

Reported-by: Chunsheng Luo <luochunsheng@ustc.edu>
Closes: https://lore.kernel.org/all/20250807062425.694-1-luochunsheng@ustc.edu/
Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3172,6 +3172,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


