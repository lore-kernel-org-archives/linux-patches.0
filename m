Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44903309F08;
	Sat, 12 Sep 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226620; cv=none; b=Xx6hGiZT0kfXmeFxUn78cHU0aGLOOijBZlE8v3zhj5WnkOcTlF9uDs9hnjB+JDEQmYUtr5dUi9PSD0jWaQDIZKFgdNt13pqOIyZ5AwLshCb1ED5SjbEvSlNaLxwGKB11ZiyhLl9QzKUDAlqtn60y82b7mCTkPkAUJ39dgfKDZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226620; c=relaxed/simple;
	bh=ZtfJxx9QNoMY2d7RnkySSya9LVccZwX5PoCXyWyXi+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agXRXp7YkNOLUB4HnHPcBoxW/ucKs/0pIFodvVG5/wYIZoO1iivkhLlx1pzDJFxKw95wTHZyaSXC9pLAR/tQSYZ43BtwA12PyfZ/cx8o9VvFpE9yLR6aJuLwtjaV0EhLQ5putrkBMuJQiFumvDDObsH5ciuKPoiJWuce+MuuiXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4hHLctw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4hHLctw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BAA1F000FF;
	Sat, 12 Sep 2026 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226619;
	bh=Tr4j+/Zd3yPj9Ar7VNn+iUKpmrfSbERWOPqg7gLFMP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4hHLctwKNwzr5dUuLcK9/Ix7jPNMLrnKoI4Bfd10APb/l2kTq40bYE80z1vrC5Ou
	 X0Rb0jomKOlJrNbcwKz2qMbrF+Zj2VhnY85XLEOMIS6GtSL3YCrrRgKTukxXn+BZMD
	 XCg2yThd+49sfVfT1JHN4pHPmQko3OBavMlQ2Smw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 0007/1191] timers/itimer: Zero-init old itimerval before copy to userspace
Date: Sat, 12 Sep 2026 08:45:35 +0200
Message-ID: <20260912065548.268161316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 18c7d85864e554adc8fad1e8d2e9d2cb6c3911c8 upstream.

On native sparc64, struct __kernel_old_timeval contains a four-byte hole
after tv_usec because tv_sec is 64-bit while __kernel_suseconds_t is 32-bit.
put_itimerval() fills only the named fields in a stack-allocated
__kernel_old_itimerval and copies the entire object to userspace, so
getitimer() can expose the two padding holes.

Zero-initialize the aggregate before assigning the fields so implicit
padding is deterministic before it crosses the user/kernel boundary.

Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: Codex:gpt-5
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260809190428.1523014-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/itimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -100,7 +100,7 @@ static int do_getitimer(int which, struc
 static int put_itimerval(struct __kernel_old_itimerval __user *o,
 			 const struct itimerspec64 *i)
 {
-	struct __kernel_old_itimerval v;
+	struct __kernel_old_itimerval v = {};
 
 	v.it_interval.tv_sec = i->it_interval.tv_sec;
 	v.it_interval.tv_usec = i->it_interval.tv_nsec / NSEC_PER_USEC;


