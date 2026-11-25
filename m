Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623131;
	b=j5Ti/KdLcVEuFwpc31++H1EV7aO0tl4aKJMYJ7Y69DwfpqO7SWNXF1FsvRoiKWL3/VlO
	 0UqHpi71D9gfci+PpUySQqnJFI6p3avcK+dQDEWYk9MLC3EZZUUs2K8ZTSPHnYPQtjFVj
	 EcHVTUwv57uH3v7VwHyJFWDu/T1SMj76uX6SAVe9otUMVFwBADA0wC/y3Xtax8/Xs8sT7
	 9/3qJGZUaf2lFtX0p9UXufQUo7UbRq4TEjwzwVHCbRd9z9HfFLd4aL1ni/lPM3tSmw/Rs
	 jfwCyi30j4+4ptR1c8nsgZFZXOwLEHWZ3ePFAJSQvya0YC3G3KZogDFTTdlw/4cE8cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydiqQ3gkR5v1EeMp47VyO5wMcU79bjfSGvIfMRaeVSM=;
	b=SRlRduSqiSV24W/OqC/OkmnbSajGHz5+F8QUpjgJNXH3N6BgVvJFFrQ/26aPs/lYL7Do
	 J1+lDFbh3neZsAWV+IMwyly7AUFfJRut73o1PlYb+qLAPDV7mpmhbcBhTHcXBcTRIwqxv
	 2yY6qLNlmrXIhq2d+g4nFMmYyE5gja36dbaBzBKTwjDu15BjpnQI23WJSGT+hxYHKjZb9
	 SRTjDimN+JXusGtTAlBIchDse7BshsmHtrvDWkjN6SxCnAq93eCPIjTA5rpVg7CA4HTKU
	 PbtzKAD9NMcH8KJPHYftQ1yUHM76uDi/f+175aSDfOE+JpsueGamX1giKmeso45jc1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZ7oROQ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6642B606A31E;
	Wed, 25 Nov 2026 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZ7oROQ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59471F000C4;
	Wed, 25 Nov 2026 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623131;
	bh=ydiqQ3gkR5v1EeMp47VyO5wMcU79bjfSGvIfMRaeVSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZ7oROQ7eXN2oQW8tyN5Fu/cGuoKc893zCkLoMhYD4sq/q6fXzLoOhttYtVBGIg2z
	 A6taHHNi0gnOkka4FpakDpI40FvPCdNLOSBKUeG2D7+n5bvriGOo4RnRkfdAjg6gUp
	 m8lNNJBRnzBtrYnhrjD2oN1QxyYK1+5J+/blGnGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.18 761/990] timekeeping: Read getboottime64() offsets under the sequence counter
Date: Wed, 25 Nov 2026 15:35:28 +0100
Message-ID: <20261125143839.881959964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit 385b5ec1f31dd39297578eed42be74b07ae74017 upstream.

getboottime64() computes the wall-clock boot timestamp from offs_real
minus offs_boot without checking tk_core.seq. A concurrent timekeeping
update can leave the reader with an inconsistent pair of offsets or,
on 32-bit systems, a torn 64-bit offset, producing an incorrect boot
timestamp.

Read both offsets under tk_core.seq and retry if an update overlaps
the sample. Convert the resulting local value to a timespec64 afterward.

Fixes: 7c3f1a573237 ("Introduce boot based time")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030054227.35453-2-dennylin0707@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2419,7 +2419,13 @@ void update_wall_time(void)
 void getboottime64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);
+	unsigned int seq;
+	ktime_t t;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		t = ktime_sub(tk->offs_real, tk->offs_boot);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	*ts = ktime_to_timespec64(t);
 }


