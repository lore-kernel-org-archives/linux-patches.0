Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3784186E52;
	Mon, 12 Aug 2024 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479136; cv=none; b=IrrRnCs1VKNl+zMbBc2hibyQkUZZGZ496o7u1alJYncIMZohqKc926U65VKQnADNq5gSqjMfQC8YqTzGlPpbxRivdJQl+VR8Hdm9EFDAUhC3jGSbOV6IZuwxNlIKQBMwLe1492gpwczKBekCmaKcpUBVWkLADHg6hVovz/mvhmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479136; c=relaxed/simple;
	bh=hgUX3355HK0LOxhWWtkjTQAIAIkZdMnweY6uuVSrao8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usfW1YGreoFw8u1K80Nm9AgccnIWtIoRfmfkK2coJuMzhVYou6ZJXCC5yfMHL7KjozAWWYShCpjjmca2D3BjhFhVjtgTGscBfQlWMPHU8ldWfX2X8pwocc7VTgbpsUni3GZaHp8qdweoUR0bv1SHG0r9nLv2MSywD8Wtd0naOJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsX/pbgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsX/pbgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0472DC32782;
	Mon, 12 Aug 2024 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479136;
	bh=hgUX3355HK0LOxhWWtkjTQAIAIkZdMnweY6uuVSrao8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsX/pbgFZ5MySyn+sMzNAd2IUgyQG6yXw54DLozVNNiq9D3dRfuD2OLj1WoYhOZRP
	 Ywkq4gKvfhBQoNSYTcnSzfjih1GnmJY5Jkd8mzrqJcVkuws22N/YYQIyv4aREyxW9H
	 eFoYzcDM1KZ1WGHf9wVQzZ4Nhq1aJDNdfoLy0WGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Kevin Berry <kpberry@google.com>
Subject: [PATCH 6.1 144/150] xfs: fix log recovery buffer allocation for the legacy h_size fixup
Date: Mon, 12 Aug 2024 18:03:45 +0200
Message-ID: <20240812160130.727927459@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 45cf976008ddef4a9c9a30310c9b4fb2a9a6602a upstream.

Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
mkfs") added a fixup for incorrect h_size values used for the initial
umount record in old xfsprogs versions.  Later commit 0c771b99d6c9
("xfs: clean up calculation of LR header blocks") cleaned up the log
reover buffer calculation, but stoped using the fixed up h_size value
to size the log recovery buffer, which can lead to an out of bounds
access when the incorrect h_size does not come from the old mkfs
tool, but a fuzzer.

Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
into account for this calculation.

Fixes: 0c771b99d6c9 ("xfs: clean up calculation of LR header blocks")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Kevin Berry <kpberry@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2960,7 +2960,7 @@ xlog_do_recovery_pass(
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
-	int			hblks, split_hblks, wrapped_hblks;
+	int			hblks = 1, split_hblks, wrapped_hblks;
 	int			i;
 	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 	LIST_HEAD		(buffer_list);
@@ -3016,14 +3016,22 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		hblks = xlog_logrec_hblks(log, rhead);
-		if (hblks != 1) {
-			kmem_free(hbp);
-			hbp = xlog_alloc_buffer(log, hblks);
+		/*
+		 * This open codes xlog_logrec_hblks so that we can reuse the
+		 * fixed up h_size value calculated above.  Without that we'd
+		 * still allocate the buffer based on the incorrect on-disk
+		 * size.
+		 */
+		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
+		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+			if (hblks > 1) {
+				kmem_free(hbp);
+				hbp = xlog_alloc_buffer(log, hblks);
+			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hblks = 1;
 		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}


