Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5EB2820D1;
	Mon, 22 Sep 2025 19:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569921; cv=none; b=ZBC6yfjenJuhvZQmeM6k3jjoEoj7UT9XMp6u+UgR/hcZ4dxdYYSLcTJRoH74dJURDj3i5B9Vy0wyJ9WheiTcLxec2Z/pldwDDfKJviwACnbu0zLgouXHNoSZpjEv0NZ5OAK3pLdU6CWh099MCOwstoF3JpaUH9D0nu7BKoZ4LCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569921; c=relaxed/simple;
	bh=QLn8X0ylLalcq2XFdn5Fv6p/UagEmsGOt9fFLMM8vWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+GRYU9uk+RwhQYUPWS+AX975Lh4iwNIWHiYyEP/MN6WZDbFGOZvIwHIKrNET1+nM+H5Dc4IXXz2WVFCB5Kon6IxfFMR6YYJlXSdrrQHhQ2XL96BnrkwtIOO3IqjenuTaE99Kb/4t3mhiIHyKf0M8pR/O2ghx5kA/FU/Sajnv68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G86ncNgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G86ncNgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573A7C4CEF0;
	Mon, 22 Sep 2025 19:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569921;
	bh=QLn8X0ylLalcq2XFdn5Fv6p/UagEmsGOt9fFLMM8vWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G86ncNgnzSESjt2tA+sM6Uc5X9HN9uLf3ibB/K6UqcdbGWUpOBRaSQxk+xtx0lUqc
	 CXKZiOeiGMLihDlJmc0H+qLvZGnbuwBOcHwnJuOG4wuFBPd0/jlkQQSknShknjXwwY
	 5bXbZyd5/CSdHF3MoOhJogvq1YJcB8n4goLu244I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 6.12 041/105] dm-stripe: fix a possible integer overflow
Date: Mon, 22 Sep 2025 21:29:24 +0200
Message-ID: <20250922192409.992574108@linuxfoundation.org>
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
@@ -457,11 +457,15 @@ static void stripe_io_hints(struct dm_ta
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


