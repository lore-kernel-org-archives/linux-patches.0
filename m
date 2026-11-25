Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621474;
	b=j6IWOdPTxG5X7IB3b2iOzDLMPIcPns04PuEjL07PiXW6ur7U09grZQxUHjRnLS4Ski/Q
	 HcsvJ//hlJkAPW5rHjDK5lFIln5nfyr8RtGyGBAtnrfAN6QzRu3e1qZkAudV9Zff2sKXp
	 XnVeVjtS94mUMPO61dhBax5RMUP/Df5joL1JBAIQ3OZooEBTDqAUqiYT6Oa5f/yc4bgcl
	 W3yHOMDegsYVVArQPGIhUUoqpiimODzvE/vtPKYFlmXK4ElGPWb5giKr0RP/jnI+08URU
	 Nh/H0YqVAhZDx38S7UrDOtV7QZgIoBox0sswlWhZDv4cuhPgQrzfNzjdsvdeNiHahJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OqcCd1qXxytSkWLcSKnNmssu9Jedfbb+MMkB4+KzIms=;
	b=BTeckLTYvZvzb7yq9SipSTC/Vwz9X6RcdSp1rIRiuMxYfxEQVBgArUqmozj41ii9x54x
	 dr0QQXatljVqmJbxLnGl+UXvja54gVZ63bxFiyNFlTaIkq7Wp62XZJlWaPC0GAtsEyRYT
	 LMVjgnG3GiFcXunSdVJ9qs98EGcj2ZiNUZ42DN655WGtPBlxe3B2c0cvCmn0n2S0WBub2
	 6PmVRbmcho2ZhMscTGDRDLFbUdUKWyzq1GnRycRSeBNvyE/XGc/LJ0+O8xJPKFihvFBnH
	 3kXS7UmudiviLwofXrcO1S1Y7aoFewtsgYAq1H/dhfWpb5ULlhIvH/K9o+8FXimWIRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAZVg2Ys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C17606A31E;
	Wed, 25 Nov 2026 15:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAZVg2Ys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B981F000C4;
	Wed, 25 Nov 2026 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621473;
	bh=OqcCd1qXxytSkWLcSKnNmssu9Jedfbb+MMkB4+KzIms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAZVg2YsXiG256D4PBZczdyRqkQnhWfqWu6IBEJw0jEl1UinITDc/hKrS3C0EL2mG
	 7msl5ENyfq22L/NWiBHR6qzI4+KcddcFGi12x3B/sJ3V1uzmt7ugMg9QpqsjfJzCED
	 kuv15bEhCeVrNZ6ymFyqCsLfHOrDbhHK0z+K3hsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/990] vhost-scsi: fix page reference leak in misaligned I/O fallback
Date: Wed, 25 Nov 2026 15:26:16 +0100
Message-ID: <20261125143826.986862086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cec46ed853572..e1ea548a651b5 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -869,11 +869,16 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
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



