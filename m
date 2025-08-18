Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C99F30C37D;
	Mon, 18 Aug 2025 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523160; cv=none; b=n/6V6dquSYjvy2kYjiauREn0uAHNltKPz6AwWkDXAJadkMbRBoiWdwQljIcKYFs37laLkPbSKAvYF5E0Qq1MlqJvMfuoTKf40B/Bkjmm+0I/0y8dMi0PoTYHHarwV/Q56RXB12iiWatzM5ByA326YNKJOd5VK3LSRyNXzoWTZv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523160; c=relaxed/simple;
	bh=hfULiKHWK/9HpEkMeQkccBMaJUixzA7jUFRekTtieSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzq1fG22zO/r2SV89arxACKbaPAiOHZ0iHL0x8NDHSIKQd5xDIXNK+pPeLvjvM/osRJH8IplX3wpI72ZTtWQh/pF+bVsjg+WaW8oVF5cbetR5MIzA9cSD2GVsWCQjSDHyy8Og2MIZjYb0t9KwhrMzIPbdO+QQdFcOOqng5ctbHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMA7CbdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMA7CbdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE38C4CEEB;
	Mon, 18 Aug 2025 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523159;
	bh=hfULiKHWK/9HpEkMeQkccBMaJUixzA7jUFRekTtieSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMA7CbdL0ViRHbddQC4geDTlcyle6uKZ8Y+A1lwOzH3Zd5qzNLl3kOCM5xfX6H6zG
	 baW6z7UUXgGq6+M3JRdBv4MUeTpH+4OXO2QY2G30ateBOctT9QU/2Tw3CWhH63OqOJ
	 kbGy4Qclw+lefjDjdopwL/mlfqGaB1s9FFpxZoeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 089/515] dm-stripe: limit chunk_sectors to the stripe size
Date: Mon, 18 Aug 2025 14:41:15 +0200
Message-ID: <20250818124501.800754428@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 5fb9d4341b782a80eefa0dc1664d131ac3c8885d ]

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250711105258.3135198-6-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a1b7535c508a..8f61030d3b2d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -459,6 +459,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.39.5



