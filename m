Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDC925524C;
	Mon, 23 Jun 2025 13:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684707; cv=none; b=Y+m5EloCC+NFq/3qSj704BpqxNHGQbv/Moq6tuRqpUazkkYMBer68O6LeKXAlRZG2fcGvAsW02nEte7JS4dQw9T1KlYbUedFg6XdCm3qpw3UkiEDmHNo6j1qlV+kpgZb9WqP2ubeWhyHRqXPUk2R4tgqbz0rUrRV67/jzGpznWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684707; c=relaxed/simple;
	bh=Ck/Ki3tBURTxrCjMyiPnPWitDU079iGT0B3QWAxr90M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+FhNEsLSUw873e1Xzozm7fYyd7wCYUkIvZegItBAMyIEtcIdo95uFD7UfgPspMiLZd/giYF20AGKr6CQkdGnq7gFFvwKGIVcrxE+54C7N1ojeT7CdV2dx03EeM24uGcygubmV/MVDrNiFY+xlpTkwr8NdFQyA2eD/+Y3TPPJ0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HE+gdaew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HE+gdaew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51708C4CEFB;
	Mon, 23 Jun 2025 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684707;
	bh=Ck/Ki3tBURTxrCjMyiPnPWitDU079iGT0B3QWAxr90M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HE+gdaewKoqI+AiwgsOrao/LLh+gB4ZA7WR78408GeXWbpJNcV1az8Vr8aah8sUsf
	 TKEJXYJl8V3Byz6C5VJ6ivKRq8vv1fX/DzxPgWTBjk22cq9RT6PkBItIq++MtwtG0y
	 VBMSbwteiisrGMb5AgRLJFMYPDe0rOzMo6F/w96g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.15 157/592] dm: lock limits when reading them
Date: Mon, 23 Jun 2025 15:01:55 +0200
Message-ID: <20250623130704.013263510@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit abb4cf2f4c1c1b637cad04d726f2e13fd3051e03 upstream.

Lock queue limits when reading them, so that we don't read halfway
modified values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -431,6 +431,7 @@ static int dm_set_device_limits(struct d
 		return 0;
 	}
 
+	mutex_lock(&q->limits_lock);
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)
 		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
@@ -448,6 +449,7 @@ static int dm_set_device_limits(struct d
 	 */
 	if (!dm_target_has_integrity(ti->type))
 		queue_limits_stack_integrity_bdev(limits, bdev);
+	mutex_unlock(&q->limits_lock);
 	return 0;
 }
 
@@ -1733,8 +1735,12 @@ static int device_not_write_zeroes_capab
 					   sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
+	int b;
 
-	return !q->limits.max_write_zeroes_sectors;
+	mutex_lock(&q->limits_lock);
+	b = !q->limits.max_write_zeroes_sectors;
+	mutex_unlock(&q->limits_lock);
+	return b;
 }
 
 static bool dm_table_supports_write_zeroes(struct dm_table *t)


