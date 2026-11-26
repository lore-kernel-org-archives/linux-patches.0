Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705485;
	b=wxauWS/WEMz3KpdyefH505RI01flI5fsF+h5H9AH8Uu9xhSBXxsbSxGAk5fGgWQrh7he
	 NDP0//A13lSRLv4cUPgkjyfGXSUmIlya7HuQhrQT37qLm+2Bd6ZB+snaj553KDiHS2ivI
	 ukXcxZxsNg+xvcOhWeWvgNgH17iuzIXtFt7TV1KW2vZpU7njq/dgLRyg8Pp56VWcoHY43
	 X+n+/NVEjNdQPH7bz9c1mHHFoVGHP1Ran+aZiP5WLE01Xt2tsaaPVywBEa6id1f4VTcKt
	 KNkVULeAXwJIgRWxWwantmgnG6svgDR9cz7f8h/nRMkl0xmCFw+lhFQCi2h3R/clYrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k1zioivyKXu5mUgvUX0DWkSn2gng1uFhzbtkZF3t1NM=;
	b=WMBhNknBizNPdFWrQt6sEFtCZ/FW1/8/YdnvuLWz2ItpGVKf37neFzcx/yekIJ2selCe
	 HxMHBl4aHBTAFAkhwJ3FDMLgVXB13ZgnyhjfcJdcGb7bxBa9fOI2t8mnEWWChx8dvthBa
	 QODgG9WMuQ/kNNYgaGXCAVYyjZazE3MKxpuFr5GtFV4GtUlIS/gvGEDuwBC0ZcLm8TJb1
	 6KE2GYHGq+D4TWyV3sEppzzaqsorKsEO9VvP3bS1YLwqXtcUPIxOvn/D4ecT7tTh+dHsp
	 jz1vJmylJe3UisaaQkIX/ILqb6nRfSDngCq5eVpIqbEgl/QRoi2h4YCuDVtu4nPkFyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UktuBc6F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FB9606A31C;
	Thu, 26 Nov 2026 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UktuBc6F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F111F000C0;
	Thu, 26 Nov 2026 15:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705485;
	bh=k1zioivyKXu5mUgvUX0DWkSn2gng1uFhzbtkZF3t1NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UktuBc6F7o/ogbjRt76mAIECblOz2QZfOLpHX6Jr82RwjaqyU3lOKRWQOiom+rC18
	 Dyzmesxq8M8VGeCtPJLJIoX0+saiYG+sDhjkdo4zZbPM0By8bNKFFnqMHJbctY8F+F
	 T1zHMS6W26rJKFjBDEChZIbRza4rRr7sid58cO8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 5.15 212/319] timekeeping: Read getboottime64() offsets under the sequence counter
Date: Thu, 26 Nov 2026 15:39:40 +0100
Message-ID: <20261126144011.530466605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2235,7 +2235,13 @@ void update_wall_time(void)
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


