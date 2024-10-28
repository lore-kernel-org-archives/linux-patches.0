Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709BF18E020;
	Mon, 28 Oct 2024 06:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097418; cv=none; b=UmXHeR08Q5l9CxdNpjaMppfUkwoPR1UJRz4u4F3BUYn7O03jDBiXF3QQ6ijgzuLMZUhG0W5VHCiknbIqNDfeA4UGg6RTqGJFgyWNMy+l5Gu9OM0mGQP0fzUtZW42k9SD3l5QzaHEEGvPmeCqS738b9DkEOXFlQqDAUJGiVb8LcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097418; c=relaxed/simple;
	bh=6Cr/b4E845spkwQ3cpbJQUvDGUoN3rqhAWLuREnZoIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci5+u2/n246d0XFHNPlKasF5AwvF1drl6/W8m4wIaWVbDjyNxxP9puR1EKgWA/0YdNgOOhutDLeY4qNgNodxc38NwnQLzdtNxi7+LtQm/z8xzcKs+3TLpiiEGrYgpXB43Tc2oAGurpx6g8mFXDNAMksb2ACZCB29eEk83bhgaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/954KZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/954KZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104A3C4CEC3;
	Mon, 28 Oct 2024 06:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097418;
	bh=6Cr/b4E845spkwQ3cpbJQUvDGUoN3rqhAWLuREnZoIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/954KZkY8AxPWgNTyKKoMk5olKj0sXywrJWCyj1YjgaDij3QDbVuWzvDHo23gWA4
	 e7QmfaRMAB0rE7YpxdhHFGCR/4mg5jR1n8aHT70tRcn3WekN1m5RWN+JHzH4n16J1w
	 tR++oiBlIO6tHo3tbgf6Ce8SdfzqjNawUCJzqUJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 122/137] openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)
Date: Mon, 28 Oct 2024 07:25:59 +0100
Message-ID: <20241028062302.117383249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <cyphar@cyphar.com>

commit f92f0a1b05698340836229d791b3ffecc71b265a upstream.

While we do currently return -EFAULT in this case, it seems prudent to
follow the behaviour of other syscalls like clone3. It seems quite
unlikely that anyone depends on this error code being EFAULT, but we can
always revert this if it turns out to be an issue.

Cc: stable@vger.kernel.org # v5.6+
Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20241010-extensible-structs-check_fields-v3-3-d2833dfe6edd@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/open.c
+++ b/fs/open.c
@@ -1361,6 +1361,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const
 
 	if (unlikely(usize < OPEN_HOW_SIZE_VER0))
 		return -EINVAL;
+	if (unlikely(usize > PAGE_SIZE))
+		return -E2BIG;
 
 	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
 	if (err)


