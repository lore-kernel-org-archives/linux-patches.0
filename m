Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDD51A619E;
	Tue, 30 Jul 2024 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357800; cv=none; b=aoIv4s0mQoFYOoZ6PnxMfx45dYIR0nxdtAtaybXV2UXfRRKhd8J50Z9bnhgAOEuLDELTbXZ1MtSs4cH/OKCRHhPhQJ8k8McmvDjdRJkTMVAoB3zOkjfCMVa20tYbnJ4jiCbUXErlbi2dM9YqQm/sOHVJpxUtP9ixEQExweJW8s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357800; c=relaxed/simple;
	bh=vm/cD6TNWb83mYv31uq1EAnW1WR94auFi/u+bZZiYi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGEvdO28sL0YlrPOxy43qEyr8+YaxkUDvwKoJv86tjvRwGvRCBDiU7uofUwFr2nQzkcJ0q28eD3DYjTDbXUJuZ5B2a2x5QAV35/hoSw5+zPBaN8s9kZA1qquiDV8N1mrhKvkEdgtpTFYoNDffr3QF+99KmcA9vKtlD3yyG2crIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMNKztRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMNKztRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9BEC4AF0A;
	Tue, 30 Jul 2024 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357800;
	bh=vm/cD6TNWb83mYv31uq1EAnW1WR94auFi/u+bZZiYi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMNKztRf9nG0iNwg3VxxYvUtlHuLAFmXKZq21t/hPjvIaYtkaZBjhIJF9sEtL1sgh
	 NqTai15vJJnbMHtTsjGzN1TEz3f+heQyxZyZGsjZJpJgQs1uKChpvpi2ZwZwO/azO3
	 l69bwFiNvn9t3p22WPKtl1yu4Zki6B4igcsBGcS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 328/440] fs/ntfs3: Update log->page_{mask,bits} if log->page_size changed
Date: Tue, 30 Jul 2024 17:49:21 +0200
Message-ID: <20240730151628.630119976@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 2fef55d8f78383c8e6d6d4c014b9597375132696 upstream.

If an NTFS file system is mounted to another system with different
PAGE_SIZE from the original system, log->page_size will change in
log_replay(), but log->page_{mask,bits} don't change correspondingly.
This will cause a panic because "u32 bytes = log->page_size - page_off"
will get a negative value in the later read_log_page().

Cc: stable@vger.kernel.org
Fixes: b46acd6a6a627d876898e ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3937,6 +3937,9 @@ init_log_instance:
 		goto out;
 	}
 
+	log->page_mask = log->page_size - 1;
+	log->page_bits = blksize_bits(log->page_size);
+
 	/* If the file size has shrunk then we won't mount it. */
 	if (l_size < le64_to_cpu(ra2->l_size)) {
 		err = -EINVAL;


