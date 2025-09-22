Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4A3314A6A;
	Mon, 22 Sep 2025 19:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569919; cv=none; b=V/4AOZRODKxGKpEBfqoPn0b2iVQc7eNcCE6A6yf1zxiESPvmPOFwpXJp/6/j/0DN/DDiaMy+J/gw1bcM5uCNjnxlVMos/ICyRFBI/3CxnXHPCWbdIkEuZxkr5+UVoS0w38XI1bIasAUL76E1Rj41WMVR0pWRiWiPIn9GkQyCFhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569919; c=relaxed/simple;
	bh=qpBHLLWr2lihmJ2CASeV67Xe+7ErXeskBK/hEU++xUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIA+HysNOlMi4jSpF9Tz98i8Xu3qluVKWeUsZu8mQp17DSap98+oRbYhYhSTSrS3gDIypmhVjxy5OIZMUkWs+zEYnihI0GmgvzH7q+G8xH/NAiTAV159NhR3gwqmT0POBxKJv2Szgqpc9o5D0NyFsOeRAO7baM7gD5o8nQmft+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iod4Ll+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iod4Ll+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6220C4CEF5;
	Mon, 22 Sep 2025 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569919;
	bh=qpBHLLWr2lihmJ2CASeV67Xe+7ErXeskBK/hEU++xUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iod4Ll+E5hG6pdBhaL6lufmv0KIls5iuOASIA2sZQNn3gJTidFZKSxpVeujANRDzG
	 1qMr6ImoeWAVmvx8fXDWTGoyE7WXGPdcdZWtMpHlMpx4BLVSUzxl/zi+3/cIJXX669
	 VwcAsYgZjIenrXSboTVnWFT0sDWmxMDY+YNMJ5Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 040/105] dm-raid: dont set io_min and io_opt for raid1
Date: Mon, 22 Sep 2025 21:29:23 +0200
Message-ID: <20250922192409.965650112@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit a86556264696b797d94238d99d8284d0d34ed960 upstream.

These commands
 modprobe brd rd_size=1048576
 vgcreate vg /dev/ram*
 lvcreate -m4 -L10 -n lv vg
trigger the following warnings:
device-mapper: table: 252:10: adding target device (start sect 0 len 24576) caused an alignment inconsistency
device-mapper: table: 252:10: adding target device (start sect 0 len 24576) caused an alignment inconsistency

The warnings are caused by the fact that io_min is 512 and physical block
size is 4096.

If there's chunk-less raid, such as raid1, io_min shouldn't be set to zero
because it would be raised to 512 and it would trigger the warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3811,8 +3811,10 @@ static void raid_io_hints(struct dm_targ
 	struct raid_set *rs = ti->private;
 	unsigned int chunk_size_bytes = to_bytes(rs->md.chunk_sectors);
 
-	limits->io_min = chunk_size_bytes;
-	limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
+	if (chunk_size_bytes) {
+		limits->io_min = chunk_size_bytes;
+		limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
+	}
 }
 
 static void raid_presuspend(struct dm_target *ti)


