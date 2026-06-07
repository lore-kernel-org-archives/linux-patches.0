Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072AF329C57;
	Sun,  7 Jun 2026 10:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828175; cv=none; b=EVp542EUPjNa+QKI3icH4rNI4jfw5YTaNTPs7sMJjAMbHyrHaJL2abLOM//UYZr3t94lWt28qoDv69F4+7dxusWkk9IRvoyeHAoaCQqIdajB7jCanIpIT06vkhPC3UWXAD3klGW2OCN7dkQy4in70HUsE6DGwkNJN6m1bDAN+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828175; c=relaxed/simple;
	bh=m9xpfhA5HSKsxrOAavCS+RFywbCU1TMjwyGKJwWi2FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUuPu97js8i5tpCeGwWISbxgWPyeZZankKCU1HMm4D5XWqowBma9AM/BAbfbXlElYOoY0DW/CpLhGLj2BbWnKkcD2UtnpPYhwcWOS6qcobPeGUdRdTa3hcKEyxjkjkk8ht6ANNJWRu1Va2tyIHxa3BfQymA7wctlzJTXkIu+RGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11IyC0C0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11IyC0C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D1E1F00893;
	Sun,  7 Jun 2026 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828173;
	bh=0F7PqBRsCyERf+8GJQdAJKGGHAEk5TZZml1cyyqXttc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11IyC0C0CdIqUH4l5XMpQQz8N6XdaWpydkP+gYKg05xyNWDRJEPaY2nUgD2xJwnD6
	 NQG+5neju6N/cBLcT0MCAyCB1sPTYK2IueQPNlGTjHIV0GHYtRNEAASoO0ZWxuEjaG
	 aniR5BZ/DkicL0RVFHHyU0OazYg9Ox5d0d3Cp/7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/307] HID: core: Fix size_t specifier in hid_report_raw_event()
Date: Sun,  7 Jun 2026 11:58:34 +0200
Message-ID: <20260607095732.063958237@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 4d3a2a466b8d68d852a1f3bbf11204b718428dc4 ]

When building for 32-bit platforms, for which 'size_t' is
'unsigned int', there are warnings around using the incorrect format
specifier to print bsize in hid_report_raw_event():

  drivers/hid/hid-core.c:2054:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
   2053 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
        |                                                                                         ~~~
        |                                                                                         %zu
   2054 |                                      report->id, csize, bsize);
        |                                                         ^~~~~
  drivers/hid/hid-core.c:2076:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
   2075 |                 hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
        |                                                                                          ~~~
        |                                                                                          %zu
   2076 |                                      report->id, rsize, bsize);
        |                                                         ^~~~~

Use the proper 'size_t' format specifier, '%zu', to clear up the
warnings.

Cc: stable@vger.kernel.org
Fixes: 2c85c61d1332 ("HID: pass the buffer size to hid_report_raw_event")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/20260516020430.110135-1-ojeda@kernel.org/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 3ab135238832446399614e7a4bb796d620717806)
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d9ea99cdb68e06..87d990ada8688a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2015,7 +2015,7 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 		return 0;
 
 	if (unlikely(bsize < csize)) {
-		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
+		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %zu)\n",
 				     report->id, csize, bsize);
 		return -EINVAL;
 	}
@@ -2037,7 +2037,7 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 		rsize = max_buffer_size;
 
 	if (bsize < rsize) {
-		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %zu)\n",
 				     report->id, rsize, bsize);
 		return -EINVAL;
 	}
-- 
2.53.0



