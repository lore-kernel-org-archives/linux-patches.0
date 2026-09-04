Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5C372B4B;
	Fri,  4 Sep 2026 05:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500343; cv=none; b=D1RmGkmR2OI1p7+YS6sFgR02l6TeVaBzb8dXelZ1K9JCJ6hWsGRIL4Lfxlu7egZE/ibmhMxRdlllC5OtbT5McaUttIRsxI0HELmE3g8lVXuAvBY9ac2jUMd3k3qitQNru0Dd4c5JzbjReXnOkq4ngBFKF3dKTNZs8jSCmt7rI8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500343; c=relaxed/simple;
	bh=u9wUOQbNlpQsSS8NjaC3W/J8iq3iRWEiCiSFqu2qJGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BmVfOKdZHT4i9rz1Yrnx5bHORHHCHvNei1hh4RjnvsL4fZ/Lch8wZehuqhnKK4FSh0B0XPJVMjM1g3utO13PfiRsVR/bMioEMvrSS9qyPJ5LgyF7G5zV5oAw32nbbysnX+b2G3VP/WTMf3TrHaSxDTvzXz+AZf7zMEmn48xTzqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaFzJfgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaFzJfgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4839A1F00A3D;
	Fri,  4 Sep 2026 05:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500340;
	bh=ENfOaTgolilfhGlugBDDBvPfQRaYjKCKOo2hsNIiGs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaFzJfgtqX0XB3SHoHpbrO9qcKBDx9T5GlX/38/DqsTDSEN26Q5LRn7aK8ufGBQMN
	 SrGw1ExZxouRyZWDip588YpFHjaXFhGNgtuOKSHR7o1mp5jA0eWqAwdque7c9qGc8l
	 eyy41o7G5vsoMS3jrKbR62g3rzTQ9KOErV5rv+zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 022/552] timers/itimer: Zero-init old itimerval before copy to userspace
Date: Fri,  4 Sep 2026 06:52:59 +0200
Message-ID: <20260904045748.328099500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


