Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5718E213148;
	Tue, 12 Nov 2024 10:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408300; cv=none; b=GWVAaMqY9qsApfPuuj6wb7Lot00BzLKfO5weZsbclBkGZEn+9Ufy25vpgVuDnbFcXVV+cRJfmnPwroCWEEoXOqDTcYCo1672mEy9GgSWY1IWKDPKDzdxmJbiPpXYTvbRjNpTjFrcNGz1G8foYcPWgZdoJeirvYyHcjwcoCVfj6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408300; c=relaxed/simple;
	bh=Ag8pZEq/SLocaaHbuJSPI9KREysLLTNpiQLptWyFU0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/FHK6g/PH7CS6NhBQblY/pE/dAjsZdSID36Z+VXqo4zKprOmawae+F46rSROBaEfiWDoG8nELAVVPYwejCiLmoqs1M/7m3WxVxajwjkm08y2ITrSmYh9umAjq3hoLuE589ig52PBZNFyDpE//Cx+di2z4T/mZ8oPPF8/wl4joA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWBtsnz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWBtsnz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCE2C4CECD;
	Tue, 12 Nov 2024 10:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408300;
	bh=Ag8pZEq/SLocaaHbuJSPI9KREysLLTNpiQLptWyFU0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWBtsnz+oSmHprZ4zgA94eLFEXTBcNkrgaaCLdmaSjUXOn6q0B2u5ckzzmQvlnMo8
	 far+NyrlF2+6Qcqmgb0rkZo5Yj0md4ZcTKBP+T9pIE9mKMfpiQ2OYxszuS7tEIgzpq
	 DO3ycw+ksFEP2O+klqUvIkJVAWMmJyQZKmjJ/uBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH 6.11 120/184] dm: fix a crash if blk_alloc_disk fails
Date: Tue, 12 Nov 2024 11:21:18 +0100
Message-ID: <20241112101905.473897989@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit fed13a5478680614ba97fc87e71f16e2e197912e upstream.

If blk_alloc_disk fails, the variable md->disk is set to an error value.
cleanup_mapped_device will see that md->disk is non-NULL and it will
attempt to access it, causing a crash on this statement
"md->disk->private_data = NULL;".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://marc.info/?l=dm-devel&m=172824125004329&w=2
Cc: stable@vger.kernel.org
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2290,8 +2290,10 @@ static struct mapped_device *alloc_dev(i
 	 * override accordingly.
 	 */
 	md->disk = blk_alloc_disk(NULL, md->numa_node_id);
-	if (IS_ERR(md->disk))
+	if (IS_ERR(md->disk)) {
+		md->disk = NULL;
 		goto bad;
+	}
 	md->queue = md->disk->queue;
 
 	init_waitqueue_head(&md->wait);


