Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624734;
	b=WJxk8J+XnZ0V8PeywVLVH+43B0BhtL8OabfmCykSD7SjGWv/SZYxGCNJtXsnPzzWFOyk
	 rnwia55lMlYpHwwsBg6AD7YfBYk0uMHcbhbMgxEOOlfhzyS3tzsCzE37ywjJDi5Tx0rSr
	 kNs52R190QQ3tM5Om/PIwQq4oLgxCV5BG815peRr2kRrLtxw8ZqyaaMDJyTPRpYiqv9eo
	 QTVg/6AGAA7MHg06z92gq3QIqamnqwtKp5d1W2zx2rRB/HRfRAhzdB0CWRCAbukVqs9xu
	 RYI7tYCh1dRg5irOCJtlbQMy+CvWsWm+gLDP85L7pfAT+cCdJjLol40if0ahJdL2ATA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ltMNnpS/5ucbY33KNpcihaASHBmROHryzNjuDL2Y+NY=;
	b=AXYGfqeT9K16060123EVfL/NfMTAA8cFjxxcLXXgAoa8xawnWf9ZpX5eh8G+3BSukXs9
	 Rc1d9BZOzWGZ05qtACiGc3o5tlFaBSgRXdZ6pqRt6BUsrkn0HwNaEdsNyZU/EWILyXE5m
	 t8P1bmXl2lvotrKFW5evodQ9uiZPIyPQeab/8AQirbHAHDhOVjyLoW4l8rnT068RSrbc9
	 0rRV84nXMypNBXw+pgFrLhg9onY+8RzUXoagOSPLBayFpazEZYHB42U1b0F1wdV9YsdlL
	 J+UQ85Oj0dZWg69wpMDALUcu8mEAHyBBxdYDTI+/soonu5dSXtiJZst5ekI9KCHmEVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FObR+/Za";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EAC606A33A;
	Wed, 25 Nov 2026 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FObR+/Za
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303CE1F000D0;
	Wed, 25 Nov 2026 16:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624734;
	bh=ltMNnpS/5ucbY33KNpcihaASHBmROHryzNjuDL2Y+NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FObR+/ZazY3IyOsGGYv8PDOGL6j6ZMhigJMW6zltCCWXj2eQaxvyYw5rmZyQAoFmD
	 KISwcjUJKkYNfsBWWG6R6mPxhejh8gTNiNVf3XOnah4bwxr2BZdXeb9HJn3YcuxGl+
	 kbbu/auq02wJdDKBeSXpgsStN1okc/9SHHbpx7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/816] ata: libata-scsi: fix MODE SELECT handling of data after the mode page
Date: Wed, 25 Nov 2026 15:30:21 +0100
Message-ID: <20261125143855.530203760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6fde0444d07ec954f3d885375e0402ff2f2e5064 ]

ata_scsi_mode_select_xlat() only supports one mode page per MODE SELECT
command, and rejects a parameter list with data after the mode page with
INVALID FIELD IN PARAMETER LIST. However:

- It does not set the field pointer, so the sense data reports 0xffff as
  the FIELD POINTER.

- It only checks for data after the mode page after the mode page
  handler has been called. ata_mselect_control_ata_feature() has then
  already updated the CDL enabled flag of the device, even though the
  command is rejected and the CDL setting of the device is not changed.

- For the control mode page, ata_mselect_control_spg0() does not need an
  ATA command, so the check is skipped, and the data after the mode page
  is silently ignored.

Check for data after the mode page before calling the mode page
handlers, and set the FIELD POINTER to the first byte after the mode
page, i.e. to the first byte of the next mode page.

The reason why only one mode page per command is supported is that a
MODE SELECT command is translated into at most one ATA command, so
update the comment accordingly.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-11-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9419df80f39b4..d6b1cdf4dec27 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4371,6 +4371,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	if (pg_len > len)
 		goto invalid_param_len;
 
+	/*
+	 * A MODE SELECT command is translated into at most one ATA command, so
+	 * only one mode page per command is supported. Reject any data after
+	 * the mode page before calling the mode page handlers, which may
+	 * already update the device flags.
+	 */
+	if (len > pg_len) {
+		fp = p - buffer + pg_len;
+		goto invalid_param;
+	}
+
 	switch (pg) {
 	case CACHE_MPAGE:
 		if (ata_mselect_caching(qc, p, pg_len, &fp) < 0) {
@@ -4393,13 +4404,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param;
 	}
 
-	/*
-	 * Only one page has changeable data, so we only support setting one
-	 * page at a time.
-	 */
-	if (len > pg_len)
-		goto invalid_param;
-
 	return 0;
 
  invalid_fld:
-- 
2.53.0



