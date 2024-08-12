Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4A61862BD;
	Mon, 12 Aug 2024 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479699; cv=none; b=T8+flzq6Ka28TUDgEwr9r92BJPsWxRhvqzqj3gjhwXx8bEmm05bYDZGBqyyqOBbLsMEhCNuxlLUH5stz6j568pdXg2ZaHh18YDQ31YDN0XnOdMfBbkDwVX/lXPIh5uUbQ9vmDZPpsFqcY3RAWqbupggkc6pP5IRBi5Ze6TKyacM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479699; c=relaxed/simple;
	bh=UxJNu4unQz75rU0lGLkJzR6gaGSkpxmHCgPFsxXNPFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=po2SvNdnG5+PX/GOqd+nCK4pBAYPuj93TYcJmSM0gjje+adltsqRLrorXqMik6jnoRXCTMVTfsCPDc0T8PlQN64BAadrsr42st9LqVQqsICTQw2VzjoQRSKIr/nyw6ZQrMrQLe4N6YQ2a5Kn4ou4/fkOa9QOfg9am3DvoGzkjjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnVUTrRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnVUTrRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC7FC32782;
	Mon, 12 Aug 2024 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479699;
	bh=UxJNu4unQz75rU0lGLkJzR6gaGSkpxmHCgPFsxXNPFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnVUTrRE+3yoiS0edjbTSK8ggBNfIRHbTrp5rX+s+wnnrZ2ybATv2Or2v3Gec8XXQ
	 If9Qddqu/FFp2otrN9tqZ3/DH2gIe/ENYyR4Qq07uiUeuO8PDiTPmEIMxDGwCEVfNN
	 EL8+YjSf9V+fVeSS6QMja7p3pUrbLOcL3zapYl4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 135/189] timekeeping: Fix bogus clock_was_set() invocation in do_adjtimex()
Date: Mon, 12 Aug 2024 18:03:11 +0200
Message-ID: <20240812160137.343170823@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 5916be8a53de6401871bdd953f6c60237b47d6d3 upstream.

The addition of the bases argument to clock_was_set() fixed up all call
sites correctly except for do_adjtimex(). This uses CLOCK_REALTIME
instead of CLOCK_SET_WALL as argument. CLOCK_REALTIME is 0.

As a result the effect of that clock_was_set() notification is incomplete
and might result in timers expiring late because the hrtimer code does
not re-evaluate the affected clock bases.

Use CLOCK_SET_WALL instead of CLOCK_REALTIME to tell the hrtimers code
which clock bases need to be re-evaluated.

Fixes: 17a1b8826b45 ("hrtimer: Add bases argument to clock_was_set()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/877ccx7igo.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2476,7 +2476,7 @@ int do_adjtimex(struct __kernel_timex *t
 		clock_set |= timekeeping_advance(TK_ADV_FREQ);
 
 	if (clock_set)
-		clock_was_set(CLOCK_REALTIME);
+		clock_was_set(CLOCK_SET_WALL);
 
 	ntp_notify_cmos_timer();
 


