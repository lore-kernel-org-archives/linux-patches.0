Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6583235BDC4;
	Fri,  9 Jan 2026 12:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962750; cv=none; b=f2GHLkbIjHlhpB+ZOkIO3bIwscsGxkbHGI2AXezXl4JOTGVMoBpfNKilWm4ABtRjdlG8wHYYIJcVnxAbxN8UU+Mz8O1/USCfxaJt3N2WEVrvdxBw9zVnBslOFkb7ifT4yUS893dDOs/Nm3BV7mCP2ERSV5Ht14/VDCNi2VhgRhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962750; c=relaxed/simple;
	bh=teLHLEP7KNsXuoGs5Pmia1cfs9GZdHWlHXJrXqcz3Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY3hxYUD1UWcfdotVp/qNoVuC07SFt9regGD4beYCCyOiNCBQPn/V1BV9BZ3/MsYQ4+hSXv1MC92/3+RZUkmDD//JDYNPPgWx0rjxXHkdIX+Bm6YZ2YnkQ2I1u83k6Mmmnii4bLGZe+oiFmZeMs/Vi2NkjtHNQ0z2mKhiHGvGRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc9LfJ9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc9LfJ9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04C3C4CEF1;
	Fri,  9 Jan 2026 12:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962750;
	bh=teLHLEP7KNsXuoGs5Pmia1cfs9GZdHWlHXJrXqcz3Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sc9LfJ9OL5I5dW7ad0Gx7bQB66rYcjcRfbMiJilKn4gTJgulszk5MmHCQ6AXC+a+y
	 7sNW5d3BCRE4lNeao4WMq7tyRQLcD6IsnFgRoyeHDvFdGdYQ1z9TMELf+6QwBNpSlb
	 e+xKT2CxCr7dYWhdbvD48Wf9YRercaE6WNNF5WUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 6.1 474/634] dm-bufio: align write boundary on physical block size
Date: Fri,  9 Jan 2026 12:42:32 +0100
Message-ID: <20260109112135.384234430@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,7 +686,7 @@ static void submit_io(struct dm_buffer *
 {
 	unsigned int n_sectors;
 	sector_t sector;
-	unsigned int offset, end;
+	unsigned int offset, end, align;
 
 	b->end_io = end_io;
 
@@ -700,9 +700,11 @@ static void submit_io(struct dm_buffer *
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
 


