Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617C3590BA;
	Tue,  6 Jan 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722228; cv=none; b=NFW34VTLJo6PRLZSOKC1Ehk+CFW1D4HXGdt6IjkX3ybIJ+8x9NcZrhqIbIcm2EJkdo59P0bIXsG41ce+vSj96jbBXhqwNYcz7X41OVsK6m4DmVeSTAssF9PJ+xiVLhzk7bEtKYfPh63J3ZUbpvRGP/ADOI7v+owbf72BbZkn3xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722228; c=relaxed/simple;
	bh=JNcKi3zojhwPQYohldBI4sV0zg97L077+Wl4Vt/g50Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ngwuqu22teVYSy312yRzpnhs1ZJmh7hzPkQ5YTJvwrR2MaB2e4RUW+/jBYovOEp2AmjbMnq5uXBCoisY0sxyNcz+tOpwq7oN5m5x3XQ9MVu1KRtgJLHchdqihBif+OKL6puSwP6tDrnFcfXeeveGzcgqL1OhDBgGSzzT7CUECNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yI1S111z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yI1S111z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE70C16AAE;
	Tue,  6 Jan 2026 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722228;
	bh=JNcKi3zojhwPQYohldBI4sV0zg97L077+Wl4Vt/g50Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yI1S111zUSSSa/49kqENGv9fUgAU2V0ssSBQW4vQGR4k2NxQqzc0WSyguvW7g2si8
	 /MOkq+9AEflHSp4/R8gQjMxUz4eni6dkfl9e1G6fDe46Rk6/bfLDyZg+ZXJmoa/leq
	 PwQpXapnL+AalfXnn/kg9xaCzxpuiYC429YF92GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 6.18 168/312] dm-bufio: align write boundary on physical block size
Date: Tue,  6 Jan 2026 18:04:02 +0100
Message-ID: <20260106170553.915019998@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit d0ac06ae53be0cdb61f5fe6b62d25d3317c51657 upstream.

There may be devices with physical block size larger than 4k.

If dm-bufio sends I/O that is not aligned on physical block size,
performance is degraded.

The 4k minimum alignment limit is there because some SSDs report logical
and physical block size 512 despite having 4k internally - so dm-bufio
shouldn't send I/Os not aligned on 4k boundary, because they perform
badly (the SSD does read-modify-write for them).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
 {
 	unsigned int n_sectors;
 	sector_t sector;
-	unsigned int offset, end;
+	unsigned int offset, end, align;
 
 	b->end_io = end_io;
 
@@ -1388,9 +1388,11 @@ static void submit_io(struct dm_buffer *
 			b->c->write_callback(b);
 		offset = b->write_start;
 		end = b->write_end;
-		offset &= -DM_BUFIO_WRITE_ALIGN;
-		end += DM_BUFIO_WRITE_ALIGN - 1;
-		end &= -DM_BUFIO_WRITE_ALIGN;
+		align = max(DM_BUFIO_WRITE_ALIGN,
+			bdev_physical_block_size(b->c->bdev));
+		offset &= -align;
+		end += align - 1;
+		end &= -align;
 		if (unlikely(end > b->c->block_size))
 			end = b->c->block_size;
 


