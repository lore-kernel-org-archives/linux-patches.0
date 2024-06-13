Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FAF145350;
	Thu, 13 Jun 2024 12:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280653; cv=none; b=aeW5VVpM6L0YisLtOrWVBH4Wcv99tQV8zF/llJvzXFXy0K9709JljdLg43jPpD6NGNj8HoxqYHTHUoAOpg/4fC21JObvme7IYAC0yjk/oPqM2XNQTiAa4cwnVemsosRn0jymZWO4Gxbjkk1GGOBcRoo+9trkBb+8XsRD9+EvLnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280653; c=relaxed/simple;
	bh=J85dj1RIIoXWHlU2N3sRv26zqQmQZTQl2fiHWjUmt/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF7nMWigqwDpCphplLsqQ+u1ZNXvTO5siI74YbEepPuUIpMiHFD1X/uAbzaJ1eyB47CW/DfBYLz192FbJH79k0flqGt/HVv1sCisRS8+huZudz0Ewv/+hnzPxtBMKO2QIP6o57vpbw6Fa057oD2TFptf1HbzD0Ic6t5oj7madiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJ+Noc6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJ+Noc6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F96C2BBFC;
	Thu, 13 Jun 2024 12:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280653;
	bh=J85dj1RIIoXWHlU2N3sRv26zqQmQZTQl2fiHWjUmt/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJ+Noc6VqgPK3MBwIRTl6YEY6hABSbXvG0fnTJWMYcmH5RjhgHYU+y7gs9EzEBl7J
	 YZ9+/1nacQ1L22/dhOSS1Sj5r0XqS97S/3DWFwjMQqybXiBqWEB85F2/IJWS8X5Isj
	 UhV+zFElOKbBAeDKY8n5s5NL7bAVq46/ap2OieVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.6 126/137] nfs: fix undefined behavior in nfs_block_bits()
Date: Thu, 13 Jun 2024 13:35:06 +0200
Message-ID: <20240613113228.187356096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 3c0a2e0b0ae661457c8505fecc7be5501aa7a715 upstream.

Shifting *signed int* typed constant 1 left by 31 bits causes undefined
behavior. Specify the correct *unsigned long* type by using 1UL instead.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -710,9 +710,9 @@ unsigned long nfs_block_bits(unsigned lo
 	if ((bsize & (bsize - 1)) || nrbitsp) {
 		unsigned char	nrbits;
 
-		for (nrbits = 31; nrbits && !(bsize & (1 << nrbits)); nrbits--)
+		for (nrbits = 31; nrbits && !(bsize & (1UL << nrbits)); nrbits--)
 			;
-		bsize = 1 << nrbits;
+		bsize = 1UL << nrbits;
 		if (nrbitsp)
 			*nrbitsp = nrbits;
 	}


