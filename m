Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC6437473;
	Tue, 21 Jul 2026 20:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664916; cv=none; b=RS7a/rS/UL59kfXc7pvarsHAoG6OB5wCbevnPs1mTGOCkBh0vidYrIgv45msGgSg1OjOQ+CRfdPk2PXyLfLzYLCIA1QpCppnpNrR4tD71N/bHoF0nhoiiJpxUeuewMHaLl9IzsQdWAme3xgAvwFMyD8Npt8Prt0Umkbst1eW3xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664916; c=relaxed/simple;
	bh=bUyjjhBeZ97u/porfmuJY7uIAlxOHU17AopENN1AS+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZukgvCgTXiP03r+CGKY1MiVM2a26Ee0suZkoHbr9VmhEl/COeSN95DnfBmCmqaBFCnasLUEZN7T7ckXRxtWphi8iR01PUZO0WVQ2+oIxc+jZxX5LyKpdw+XzC6YhKL3RYfg4R4QAyhTLzYO+m5/NCKDxAczpynCK6XzTH7aTlaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj82mpWC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj82mpWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2191F000E9;
	Tue, 21 Jul 2026 20:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664915;
	bh=LZ/exr3YvM85gL0DdzLPmG641NfbbQD4e1amWX0US9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sj82mpWCOUV3jSsT2/bwI4HYDkQ5me1zLw0/2knL1rMYGUnT+S2Ib2hxonIcRu+H+
	 lzflbL40c8z4xy/cOVldPpVTk0m4xhPmNawBPbLjtLKG+lEUQ83w7kG3edIs72UHtY
	 NBJ/Lr3+tijPpB9VnAmT70i0Y6hMnRjJB8ahsTVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0107/1266] ALSA: firewire: isight: bound the sample count to the packet payload
Date: Tue, 21 Jul 2026 17:09:04 +0200
Message-ID: <20260721152444.194078090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 29b9667982e4df2ed7744f86b1144f8bb58eb698 upstream.

isight_packet() takes the frame count from the device iso packet and
checks it only against the device claimed iso length.

	count = be32_to_cpu(payload->sample_count);
	if (likely(count <= (length - 16) / 4))
		isight_samples(isight, payload->samples, count);

length is the iso header data_length. It can be up to 0xffff. So the
gate allows a count up to about 16379. isight_samples() then copies
count frames out of payload->samples into the PCM DMA buffer.

payload->samples holds only 2 * MAX_FRAMES_PER_PACKET values. The
device multiplexes two samples per frame. A count past
MAX_FRAMES_PER_PACKET reads past the payload. A count past the buffer
size writes past runtime->dma_area. The smallest PCM buffer is larger
than MAX_FRAMES_PER_PACKET. Bounding the count to MAX_FRAMES_PER_PACKET
keeps both the read and the write in range.

A malicious or faulty Apple iSight on the FireWire bus reaches this
during a normal capture.

Add the MAX_FRAMES_PER_PACKET bound to the gate.

Fixes: 3a691b28a0ca ("ALSA: add Apple iSight microphone driver")
Suggested-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/178205454729.1900991.7807310178296762772@maoyixie.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/isight.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -179,7 +179,8 @@ static void isight_packet(struct fw_iso_
 	if (likely(length >= 16 &&
 		   payload->signature == cpu_to_be32(0x73676874/*"sght"*/))) {
 		count = be32_to_cpu(payload->sample_count);
-		if (likely(count <= (length - 16) / 4)) {
+		if (likely(count <= (length - 16) / 4 &&
+			   count <= MAX_FRAMES_PER_PACKET)) {
 			total = be32_to_cpu(payload->sample_total);
 			if (unlikely(total != isight->total_samples)) {
 				if (!isight->first_packet)


