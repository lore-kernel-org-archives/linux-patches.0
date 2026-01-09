Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22880359FAC;
	Fri,  9 Jan 2026 12:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960940; cv=none; b=NSYBW0ZEv9CJof+Oilt6vFuP8V1bvl8quYVR/qP1FZhqhlqZXyGkozzHJ8uTUAqZteEIupmE70Qsj5j8B/pA1QJr9iu/pi4MoWvgV43z9ucoaKloIxCvVp0Z29In/uX7tGk3RVGbSLzGAfLXG/GJ+86YXHY5lA+j2ISl+etdCQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960940; c=relaxed/simple;
	bh=AATplZk6NeYZhFPlfLAh31Uwlg1CBquCKM5/P60h8BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlLBh3ZS8VAakoSF+LZRzlgZYvKqOrtHCSVYHoJSP4sJ2X6jHlTWW4UHOoZ1dwRsMjyLAsfXTVefLsVD0ZTAUwGVf6g0NUY1DBuJ+Ce4oLRb4EcCvx606eA6FY2Nr7j4osJCqlGN0cv6Q+F7eLOaum1v8C8KXB+FWv1fDxQF7L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqyFMGRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqyFMGRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A746BC16AAE;
	Fri,  9 Jan 2026 12:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960940;
	bh=AATplZk6NeYZhFPlfLAh31Uwlg1CBquCKM5/P60h8BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqyFMGRZXQcf21qyB6qBze8I8X0lMfGUEDgSnjBCTDafvMBtQde44etO5Oqe0Bd7s
	 rINc0jrgS8aUz9X1drg3tiYMuQKznePzs7BzkYepAMfdiA+TZow6r44k371pRlWJ/w
	 N3iu8UJN7NNO3z49ipcmu2eTlqLEe8cdKlRm+ozQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 6.6 579/737] dm-bufio: align write boundary on physical block size
Date: Fri,  9 Jan 2026 12:41:58 +0100
Message-ID: <20260109112155.780803158@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1375,7 +1375,7 @@ static void submit_io(struct dm_buffer *
 {
 	unsigned int n_sectors;
 	sector_t sector;
-	unsigned int offset, end;
+	unsigned int offset, end, align;
 
 	b->end_io = end_io;
 
@@ -1389,9 +1389,11 @@ static void submit_io(struct dm_buffer *
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
 


