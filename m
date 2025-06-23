Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651BB13A265;
	Mon, 23 Jun 2025 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684545; cv=none; b=mbJnF+RdT47gaCiDVuawedFtFTFvooaJCo+4+8LSCYJc1AMzblqExQVLEtfnjS3x/806hQx/7ZEUBYabr4hgfnxloQfcg+lt37g8KQ65A5oK/JEHkvdxkxPr7axR0Eq8XKJkfFzRjcQHalgNWzc0HH2L90uTtSHXx7hzRvZ4tj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684545; c=relaxed/simple;
	bh=+dj4ehNm7Yld4ezRQcXzEQYDvBNAk7MBwP9vxMfq9Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjaXHn3B643UC8Kq2WNYl4On7RbjcqalTnJ5+MRQAu5Kvryao33T8ADVEpiLzJaawoPmkyqVw3WVhPcGpW85Gcps7mmQIkSO6Mwl4RzIO/AEht+hYTYq9MjUYvBQ5g6VzN0OCz/8KiheQEb2KUHrsWYHI2G7ywxR1PWF6n5UBXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVI6g3iX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVI6g3iX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4878C4CEEA;
	Mon, 23 Jun 2025 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684545;
	bh=+dj4ehNm7Yld4ezRQcXzEQYDvBNAk7MBwP9vxMfq9Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVI6g3iXcS2/paJ8eB+s6ciaG+PkcF/XD/tkKkWSuPD/Oc54TIhfbQHeQnW7TUqf9
	 SzXL2RWZucH1fth0u/mk/8IqMas+5PQNmiWRr7Al3kI9zJCG0bWZKgBlkvZM8GtJW5
	 Q9u03XyStuQ7m7AHY/cVr4as6J4IfwnCWRNWZGy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.15 107/592] ata: pata_via: Force PIO for ATAPI devices on VT6415/VT6330
Date: Mon, 23 Jun 2025 15:01:05 +0200
Message-ID: <20250623130702.823752780@linuxfoundation.org>
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

From: Tasos Sahanidis <tasos@tasossah.com>

commit d29fc02caad7f94b62d56ee1b01c954f9c961ba7 upstream.

The controller has a hardware bug that can hard hang the system when
doing ATAPI DMAs without any trace of what happened. Depending on the
device attached, it can also prevent the system from booting.

In this case, the system hangs when reading the ATIP from optical media
with cdrecord -vvv -atip on an _NEC DVD_RW ND-4571A 1-01 and an
Optiarc DVD RW AD-7200A 1.06 attached to an ASRock 990FX Extreme 4,
running at UDMA/33.

The issue can be reproduced by running the same command with a cygwin
build of cdrecord on WinXP, although it requires more attempts to cause
it. The hang in that case is also resolved by forcing PIO. It doesn't
appear that VIA has produced any drivers for that OS, thus no known
workaround exists.

HDDs attached to the controller do not suffer from any DMA issues.

Cc: stable@vger.kernel.org
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/916677
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20250519085508.1398701-1-tasos@tasossah.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_via.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -368,7 +368,8 @@ static unsigned int via_mode_filter(stru
 	}
 
 	if (dev->class == ATA_DEV_ATAPI &&
-	    dmi_check_system(no_atapi_dma_dmi_table)) {
+	    (dmi_check_system(no_atapi_dma_dmi_table) ||
+	     config->id == PCI_DEVICE_ID_VIA_6415)) {
 		ata_dev_warn(dev, "controller locks up on ATAPI DMA, forcing PIO\n");
 		mask &= ATA_MASK_PIO;
 	}


