Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9633370F7;
	Fri, 17 Oct 2025 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713701; cv=none; b=UowObuOqSmZAoRyF6cEv02UEFiMsesoT39rbM+wMeSF80VcOAhNsGvIUQPv0nQiLpVkdAqNPoHHZKppwOsh7wjilgbyttRal85zXqGk+3EIUHuOwOCwuB5WgvwxTTLVc2WAQZ4nAU3op/ByvtQKsjgp8ZIJ/SCcxMIwlS8QhgpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713701; c=relaxed/simple;
	bh=yq7/D0lRpLTgf+8L4mSskkMJeCkZxqnXIssJbtavpQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPNKbCaMTrNARV2ofx94bEfHOf+R8nhGCRpmKhAfV6DeMWqAW8H/yaarj9FEYwaKufulQT/zyQk4ypICeyBxS+YKWoWljZFGScr92x6tT2a59Ro+y5wLVpzEpuBtnK+PwRUJLSU5KDv6Ka8i+07Exjz5USjkaoXelQETbXdT4as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHTmK9TP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHTmK9TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59122C4CEE7;
	Fri, 17 Oct 2025 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713700;
	bh=yq7/D0lRpLTgf+8L4mSskkMJeCkZxqnXIssJbtavpQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHTmK9TPUR6dLnY/8LLO2k9JB480S+dxEH7G/apSEDW4jlcAdzCLcu+XtA76zNncg
	 fyBEU77iLMshbEh5xXwi0/PXvJD4bnMuO3IZz4R5r4Rrx0H0bIuF8xpY/kvNfsU9l8
	 1afFAZLAtvsRf///ZvuZrJ9yencgRuuXKmTSuAUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 090/201] fs/ntfs3: Fix a resource leak bug in wnd_extend()
Date: Fri, 17 Oct 2025 16:52:31 +0200
Message-ID: <20251017145138.060355199@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d68318471aa2e16222ebf492883e05a2d72b9b17 upstream.

Add put_bh() to decrease the refcount of 'bh' after the job
is finished, preventing a resource leak.

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1399,6 +1399,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		/* err = sync_dirty_buffer(bh); */
+		put_bh(bh);
 
 		b0 = 0;
 		bits -= op;


