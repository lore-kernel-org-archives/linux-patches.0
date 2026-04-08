Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CADA2727F3;
	Wed,  8 Apr 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674232; cv=none; b=T3g7hO9kKqspY4uK7244A3iXX0y4GBEQph/KPlI9/vqngG/UEycc7+97UtIvXkP+BNRF0bNz+5nl36dl7DAjpzKIBOEK50XAVUNqw3HaErrH7DpQNVHqxgjQGRAt1tdvHw8jOw3qCx2RFqrsSP70eoRppWPol1qgc6/jSGRYMhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674232; c=relaxed/simple;
	bh=eqTUrSAihUjKKlmRM8+iTjcgGGt+UppzOYmPgKKV0ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwfHtxFJErB83qWanY+r1V5V2jWlh2eyEm4lPM8/umFmSXnCpRG6xK365OLkAX2AM5xCCdRRysOCdhocOAJWIIAnBqU+q1O5pji+yga18HGnm4aAsnW6Mt2epZRhTtAe8Wdzb4yNc7zDRTqRE5+rJUgOhffn2/hXJbQq4iq/x3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ux5eEOmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ux5eEOmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC5BC19421;
	Wed,  8 Apr 2026 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674231;
	bh=eqTUrSAihUjKKlmRM8+iTjcgGGt+UppzOYmPgKKV0ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ux5eEOmJEv0Ako2OQOkoI8belIWdyqVTrcZBWAYuMZr79FUTLOJg/UeJ5dGCB4ofl
	 2OYp/N4pigAUT9HxB2vl+OD1+pT05il53uvtX9srERbpubReXtSYFKs2zf0nA1v1lC
	 JydOXiR9UOdRh01dba/yEdpe3j+Q1ck1eqz35tro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 018/311] HID: core: Mitigate potential OOB by removing bogus memset()
Date: Wed,  8 Apr 2026 20:00:18 +0200
Message-ID: <20260408175940.093314490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 0a3fe972a7cb1404f693d6f1711f32bc1d244b1c ]

The memset() in hid_report_raw_event() has the good intention of
clearing out bogus data by zeroing the area from the end of the incoming
data string to the assumed end of the buffer.  However, as we have
previously seen, doing so can easily result in OOB reads and writes in
the subsequent thread of execution.

The current suggestion from one of the HID maintainers is to remove the
memset() and simply return if the incoming event buffer size is not
large enough to fill the associated report.

Suggested-by Benjamin Tissoires <bentiss@kernel.org>

Signed-off-by: Lee Jones <lee@kernel.org>
[bentiss: changed the return value]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a5b3a8ca2fcbc..f5587b786f875 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2057,9 +2057,10 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 		rsize = max_buffer_size;
 
 	if (csize < rsize) {
-		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
-				csize, rsize);
-		memset(cdata + csize, 0, rsize - csize);
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %d)\n",
+				     report->id, rsize, csize);
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
-- 
2.53.0



