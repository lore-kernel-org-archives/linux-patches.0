Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA41F30BB;
	Wed, 17 Sep 2025 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113357; cv=none; b=aclIXL8S2gH9ZQZIhq0Wg0CtT+rH2eXgbGf8l0BvUsuiZQTPma5pu17pHAEk26msBjO/FrBhzETsXeIHN2nJUh7t/o4RiCftDHKMGeBgQg+anXFkGcZwmhMheTQwBfr3mut6OlkSBqYj/K3d4SUpJ7cZp+c7ooLwCezyThxFaps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113357; c=relaxed/simple;
	bh=KKgZH497zGYtDtHKLH3vtb6hJiktf07Y3mvIBqlAaR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szPFhJiJSLnZGTNrdry14HMocqFQM2RKT3qexPualzV3z9yuKOlMiAKiz6tBVtVX0drpp99fPi2nL39ZQuYhIMQFNJjrvjQnWPm62hp4aGNaAj8QdEdFgX5LzC5sd0HHpgMvWO0fa8wzN8qUnpH1MIPDcqwufIf/m9Yj2JLDTjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tt3OYq5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tt3OYq5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17342C4CEF0;
	Wed, 17 Sep 2025 12:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113357;
	bh=KKgZH497zGYtDtHKLH3vtb6hJiktf07Y3mvIBqlAaR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tt3OYq5pTcZdA3iBpTCntcVaKUxBNb705s5GzEm1dr2i5o0y53f0CRvyEVLHPwOp1
	 rD/JjxCbtZSNtyWaqQrGeb0dW8YBjBzgI4Yk3NWKGiqnTQvps/L5gl+d5xZfoXUk3G
	 TjI99ZBr61VzFjfAPgVmrhqWHgJsSvMySUMlfmpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 060/140] fuse: check if copy_file_range() returns larger than requested size
Date: Wed, 17 Sep 2025 14:33:52 +0200
Message-ID: <20250917123345.771668612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3295,6 +3295,9 @@ static ssize_t __fuse_copy_file_range(st
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err && outarg.size > len)
+		err = -EIO;
+
 	if (err)
 		goto out;
 


