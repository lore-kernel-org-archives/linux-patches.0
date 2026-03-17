Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8AE3F7AB4;
	Tue, 17 Mar 2026 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766815; cv=none; b=SZwM9cUzMeCR0x4M4GV68Zay5lJwJsTh/BODQiuf4fRHHQnES6BiP8lpPLsKRaoraNlHU19SmNxckuJmms1eebd5B/3B1CMygwYphtduYXVYxqxdZ71yztZzRk/Q7Pps1NkHsWJucFYFQWaqA4d6ZehPk0Z99bFjo4pcVGKte2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766815; c=relaxed/simple;
	bh=5o615YaTVZULgMYRs9ctnIpY5VzTcazfQUjsOJD/9UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwpHXjg/roPQC53rKxAnYGlTmMLHgRBLWwjy+ukevIAqgUjgveP176OF8x+3iRN24FdOVhYlGzb873Qw7g3mFToHazC5iCRQzzA4Gc9xU4lpW9JoTYTkLCUbbTMy+QRC9Fy5hNzVDOfOy5Al1AN29wqqmrsIvQ13nUwhlH1doHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ch9Mdxrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ch9Mdxrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C014C19424;
	Tue, 17 Mar 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766814;
	bh=5o615YaTVZULgMYRs9ctnIpY5VzTcazfQUjsOJD/9UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ch9Mdxrgu2UCQdFTomLsZnIlHP37RE76zF1VgSS4pbOuS9y/cyJG/bzozKth7oWpz
	 l6HhsEtrANxPSnpvOhgog7hCaWudYp37g/Oy+jEjadOUEFO1/5BkQNZ3xm45lTqkKz
	 jl+N9vuUaRJWU+zKyEVfSPTvyGno8ROoR2q3UwKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 327/378] s390/dasd: Move quiesce state with pprc swap
Date: Tue, 17 Mar 2026 17:34:44 +0100
Message-ID: <20260317163019.018722207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 40e9cd4ae8ec43b107ed2bff422a8fa39dcf4e4b upstream.

Quiesce and resume is a mechanism to suspend operations on DASD devices.
In the context of a controlled copy pair swap operation, the quiesce
operation is usually issued before the actual swap and a resume
afterwards.

During the swap operation, the underlying device is exchanged. Therefore,
the quiesce flag must be moved to the secondary device to ensure a
consistent quiesce state after the swap.

The secondary device itself cannot be suspended separately because there
is no separate block device representation for it.

Fixes: 413862caad6f ("s390/dasd: add copy pair swap capability")
Cc: stable@vger.kernel.org #6.1
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260310142330.4080106-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6182,6 +6182,11 @@ static int dasd_eckd_copy_pair_swap(stru
 			dev_name(&secondary->cdev->dev), rc);
 	}
 
+	if (primary->stopped & DASD_STOPPED_QUIESCE) {
+		dasd_device_set_stop_bits(secondary, DASD_STOPPED_QUIESCE);
+		dasd_device_remove_stop_bits(primary, DASD_STOPPED_QUIESCE);
+	}
+
 	/* re-enable device */
 	dasd_device_remove_stop_bits(primary, DASD_STOPPED_PPRC);
 	dasd_device_remove_stop_bits(secondary, DASD_STOPPED_PPRC);


