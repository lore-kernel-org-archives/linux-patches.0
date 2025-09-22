Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056002F2909;
	Mon, 22 Sep 2025 19:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570230; cv=none; b=V37sfy0PZTDxSLh6ZPnSCs1XYj7Hwg9bLCfzH2sdhfINMbyPdjt2pLB2m7PZLfjljgMrz7Kfdv/O3R8g+TXtP7Rpdf7RAQpmhbOpP4tgpKF4KK13KNMyKiDNjF7VOScaPB4iJu4jTJB4wvs1hYELK3X3PfNjzZYgC9HZ1tPimrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570230; c=relaxed/simple;
	bh=98nYFWfKrQTDQ3Auv/Bl4Rhv1mXJp5nIefyfdkgIrMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbFjzoSxoKgdha3X7rv41oJycRP0em5i0O/pfqJxXlYkCiRSoUWzC4Xxeh7BV3jV6sWCToxjGqil2no1i0AEgPnNmc7yml9+C61geKJiVPMTDo+nyiLvmpnctfl+y5UNEsRurhC5rE9efFfo2bHO17deoZ1qFU2rWncmEPfiMFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZiNemJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZiNemJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94609C4CEF5;
	Mon, 22 Sep 2025 19:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570229;
	bh=98nYFWfKrQTDQ3Auv/Bl4Rhv1mXJp5nIefyfdkgIrMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZiNemJen3tz55gOkVH6ZEESv/DTh9dl8wVVMFdAoCJhEkX913m59rrwf/EEqF+Wi
	 TaJG7Foyvqg0iH8T7n+srjNPDgPz5zb5vlJiAbRQ/Fg25Abso92ZLJx79PMeWrbBTF
	 fhbw5I2MZKlJl6PS96SJbjx1uJIECqYQWmuQ5usM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 6.16 057/149] dm-stripe: fix a possible integer overflow
Date: Mon, 22 Sep 2025 21:29:17 +0200
Message-ID: <20250922192414.313030988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1071d560afb4c245c2076494226df47db5a35708 upstream.

There's a possible integer overflow in stripe_io_hints if we have too
large chunk size. Test if the overflow happened, and if it did, don't set
limits->io_min and limits->io_opt;

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Suggested-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stripe.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -456,11 +456,15 @@ static void stripe_io_hints(struct dm_ta
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
+	unsigned int io_min, io_opt;
 
 	limits->chunk_sectors = sc->chunk_size;
-	limits->io_min = chunk_size;
-	limits->io_opt = chunk_size * sc->stripes;
+
+	if (!check_shl_overflow(sc->chunk_size, SECTOR_SHIFT, &io_min) &&
+	    !check_mul_overflow(io_min, sc->stripes, &io_opt)) {
+		limits->io_min = io_min;
+		limits->io_opt = io_opt;
+	}
 }
 
 static struct target_type stripe_target = {


