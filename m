Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618297;
	b=AJeT//bKLGeWrL1NELI0e8lpTyIcR7uz9azqQ2VSmcrRC8dobjAgxLS1usAYe7bqdjf2
	 XA7+/LrKbYTIF+MyThNbgtS4m/ZeJ/VDt6IDS+eAausOqcS3gQgLpnAPabp4YhTLGHBjZ
	 yPxASuG3+UtJIC2PSySMqjYWzTwVGxRpa0dUb25APezQE4ImuXL1YMW37LK3oDuLkgx13
	 Df3s26vsUdY4QNYyadxjhf42lFSRn+1Rht3y0mO2MWQs+6r7EmVT0Vxb70VkSnZmpZYQK
	 5o0iCR+czlpP7TZPut//tpM7RgZAST/mANR8DFnAVlpVJigyrS4Px6hXMeHo5/SEBvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPw3vypYgZube5QpJaMlIFP+nBI406Zb4kTS2kG7f74=;
	b=LiNQM8zYed0euPWROgrlp1++uLbcOWCgN0bhM7g9Cd2NVFvZy6Qw++J6M/n1R6va5aRR
	 bIwi4E06KsP/qyoRIa5rLUDbBSitChrZB3G1SecyIyPuqC/qNdboU6CP9UUXOCqJ0UQSf
	 uqxKg9zSdZ12i0ozmbiv4gLRqLjGiNoiVxRn6G+pOxSyHmRCIFftJKPZtJwUvCFbZ9/kT
	 oS9/GIbz33dFqMrGIvP6MyYWF7zyYeOsfK0rgf02xl3EObbdaQQYPG59OS7TWNemZJKbL
	 ua0S7iydaaJ5sS+DNraUbQliIv5L+mcexqzvJZxdl8b9biPA2+b8rBDqIugMH8J/hQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egZ5mUYa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005FA606A31E;
	Wed, 25 Nov 2026 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egZ5mUYa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC901F000C4;
	Wed, 25 Nov 2026 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618296;
	bh=tPw3vypYgZube5QpJaMlIFP+nBI406Zb4kTS2kG7f74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egZ5mUYaDDTNUYfObZNw+F7PRI6PUJfF7fsDuuW00NGywCmnTpxZUl8tOkAABHLc7
	 jCS9QGOiYK1uu+XhDAKdPn4mrgXYze9vcs79qZZKekQ2z+GkXJNHl/fBSt804YzPXt
	 jOb88iJZD/nsUXDQKzBIH4n2Y/k6nEQEz0ULVEkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0235/1005] vhost-scsi: fix page reference leak in misaligned I/O fallback
Date: Wed, 25 Nov 2026 15:26:13 +0100
Message-ID: <20261125143827.244303422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 058fc59326af3350c6e830858e56d2aeecabe0a2 ]

iov_iter_get_pages2() returns a byte count that excludes the offset into
the first page, but also returns a reference to that page in pages[].

On the misaligned-I/O fallback, vhost_scsi_revert_map_iov_to_sgl() puts
pages already added to the SG list. The cleanup loop starts at
pages[npages], but accounts for its first page as PAGE_SIZE bytes
rather than PAGE_SIZE - offset. If the remaining data starts at a
non-zero offset, it can finish one page early and leave a page reference
behind.

Use PAGE_SIZE - offset for the first remaining page and clear offset for
later pages, as in the mapping loop. Without this, each affected request
leaks one page reference.

Fixes: bca939d5bcd0 ("vhost-scsi: Dynamically allocate scatterlists")
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261023104035.6686-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 1274e7734747e..6bf1ab773d54e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -900,11 +900,16 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 	vhost_scsi_revert_map_iov_to_sgl(iter, *sgl, sg);
 
 	iov_iter_revert(iter, bytes);
+	/*
+	 * pages[npages] is the first page not added to the SG list.
+	 * The remaining data starts at offset in that page.
+	 */
 	while (bytes) {
-		n = min_t(unsigned int, PAGE_SIZE, bytes);
+		n = min_t(unsigned int, PAGE_SIZE - offset, bytes);
 
 		put_page(pages[npages++]);
 		bytes -= n;
+		offset = 0;
 	}
 
 	return -EINVAL;
-- 
2.53.0



