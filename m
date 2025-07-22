Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB8919E81F;
	Tue, 22 Jul 2025 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192812; cv=none; b=Pj7ndcJmPVbjkNwPvIF+y6dBzNzQpPzYUMNNKBM9YY2DOdGuc6Pv68dlG5/8eblIAto2G3/uQpzyk7wWlMk5GQHZnTrbslw+C5ESyQqF+joO8L5nmm7D7ms3o7GbCt3FOxtJaXUtjH44SqObreDT3FTME+Umel4jYSHcLTX6V4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192812; c=relaxed/simple;
	bh=MNd/OzlU1QEk+/QZFfiBuNVjJYv4sqdAVNrzCkm9V7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxNKC244V/AN/U5thMiNUOititp0cde/+5lf7etW6JLOT5cfuEhRQ5jFpduItT9LCjoCykmzdWhK2y2Yo5Qqe6NczL9/kzXxeroEuqdMK1CjyfODysmzk29/QTeOjWH5RdTIS+p11SMWsYHCv6uAq4DTdPmfuAlTFYlsIbTpmHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elyEv2fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elyEv2fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AF6C4CEEB;
	Tue, 22 Jul 2025 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192812;
	bh=MNd/OzlU1QEk+/QZFfiBuNVjJYv4sqdAVNrzCkm9V7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elyEv2fv2ziSzKNX/xLEV2xzBGWRCY/5JCRrAnKSfHFdmG6bFwYt/grsVOmP4i9A+
	 Rtvu7dgWGb/4PUPJmBFv8gjHCOTkygDRQkC7DSSeIFLcW8hdyetzS7a6sWsBYjJ/bb
	 Hq+cZmSxpbqwCqplSOD1/R+kNuEqRJB9ice8QunA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 063/158] s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL again
Date: Tue, 22 Jul 2025 15:44:07 +0200
Message-ID: <20250722134343.099581706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit 6a5abf8cf182f577c7ae6c62f14debc9754ec986 upstream.

Commit 7ded842b356d ("s390/bpf: Fix bpf_plt pointer arithmetic") has
accidentally removed the critical piece of commit c730fce7c70c
("s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL"), causing
intermittent kernel panics in e.g. perf's on_switch() prog to reappear.

Restore the fix and add a comment.

Fixes: 7ded842b356d ("s390/bpf: Fix bpf_plt pointer arithmetic")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20250716194524.48109-2-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/net/bpf_jit_comp.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -544,7 +544,15 @@ static void bpf_jit_plt(struct bpf_plt *
 {
 	memcpy(plt, &bpf_plt, sizeof(*plt));
 	plt->ret = ret;
-	plt->target = target;
+	/*
+	 * (target == NULL) implies that the branch to this PLT entry was
+	 * patched and became a no-op. However, some CPU could have jumped
+	 * to this PLT entry before patching and may be still executing it.
+	 *
+	 * Since the intention in this case is to make the PLT entry a no-op,
+	 * make the target point to the return label instead of NULL.
+	 */
+	plt->target = target ?: ret;
 }
 
 /*


