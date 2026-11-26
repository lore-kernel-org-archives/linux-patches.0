Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704585;
	b=3HwHwf/zMU5YmG2JRGiW+iLmOB99WE0Utei5Wd4n1NxCQ2kjFaDKBOSDlMf/jNdlgOpX
	 d0tWhXV3rmYplZQp7mzd2jV+/alyd2u/ag5XZmbloMkLS8WJ4M7gwvF4O59Lji1F7L14m
	 TLgNJ0ARGHI/2UJ4+hMm751oJkKyS7c1eM1j51iW2cnQKaT6IEMEc7vVK4KfEQRVVg1XM
	 LBcQfT0VLieqYq26bYIz5oQvrMQEXZKamQxjtnSFWuTJ5zW+Jw/DGfHBG8how0MegdPJc
	 WWuWWmCGETYwsHEm3eJFMkqjk++qMBh1TOzqYmh7rY1d6k6IeGcqpkIrrjxOaMyMeag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTxylb3pFtmKEP9RuSvlOVAIDTIehVZUDcabV3pU+qI=;
	b=TzmlUScDoYBKqvUypQROuKA9Tdx+ZFMwpCf6gSx3/Q9AB5ox2rRAYRxwk8V6AU19m2NN
	 IY6tMdmmYKnF5IfI50CYr+sutGmzqf8OxYcoLijsgt0GdD1IporKLry+12cLx+2CV5rEk
	 Pvwml1a8BAi1BDUql/a4y5dlBht4mbZ6jm0lCutyloimC0famR0B5+1wb5mAZ32oRCXQC
	 UQtp4XY0ZcGXnznVXNfrhyiNxUrcDGOoJCBaX21rmx7XEazKk7yNumyR1791shh2TK0kT
	 G8FtFW6sa1dp1E0bF+W5lHf/YAnBYvsu+ylHKF4tkEna0MX2ovq6qjzUSvCOADtLnfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdraNFNn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D565606A31E;
	Thu, 26 Nov 2026 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdraNFNn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681C51F000D4;
	Thu, 26 Nov 2026 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704584;
	bh=YTxylb3pFtmKEP9RuSvlOVAIDTIehVZUDcabV3pU+qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdraNFNngAGW42YfmL+9V6o2AYi0BX++aHls9MxK/TtdY7raAxRw6xL++q6ijSxS8
	 iirXkKNh6gW+rYwa77ngelYFEk5aQTW9Kv9q+xQvOicdZJj6qtdf0FDUTdwrmLWB0K
	 1OJ8C4G/gVq2g3W5tCMfUiw/4fKhUql7cjrT5kr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 5.10 174/265] timekeeping: Read getboottime64() offsets under the sequence counter
Date: Thu, 26 Nov 2026 15:38:24 +0100
Message-ID: <20261126143617.332466282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2233,7 +2233,13 @@ void update_wall_time(void)
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


