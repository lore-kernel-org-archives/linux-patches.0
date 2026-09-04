Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E4724A05D;
	Fri,  4 Sep 2026 05:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498330; cv=none; b=szkzV09S/A7lVWjWApPmMvTvIz1lCe4ctpHfS6sb66dn+n+WlkqC7N8Qvn5WIHTHzFnffFA6h9y6Yax1zndbo95cCA57Z6zI7xUYc9cotaYaDN3Bdm0Lwhqq4c+PcGY2ApFBh4obBdrfv2cVGDBxtN9gM8AjdUJLx1B6hqZ5COE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498330; c=relaxed/simple;
	bh=crJxGMkVfPdVwhYxLDW/rWhIByDIB/KFIEWeO4xv6sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GCTd//hbiFFwaxa+nurTpqTF5tHkvbEsZN1p4AcmsSMfNoBWrzuLeQ2vC04sSFk2GHJg0iJF5BXaRHD2068pSyHlK99QEEYSJ4bXOzMX5hSFA1BtiPkJR9h/bMY/pnDOxFdMckeXcW7CcErvWTei0Pk+qP5Fhn+LqAndhjpZrlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHBbqOjT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHBbqOjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085F71F00A3D;
	Fri,  4 Sep 2026 05:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498329;
	bh=owv9wc590YALpgEIR42HMjOo9lK5M5X9MqfokGtdTYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHBbqOjTY7CedisD9NkDBOHIN11i47BOAL69dWRyAFC3/ze/QvsSCZ+l9fkOIG8cR
	 J9OYuvX1Z3h6E+ylumRxi21fSw6R9qZRAtqosaXCVaOP1CRcSGD7CYvC6Av0PpiE0e
	 vACB0QF3aE5fC4NBSVn44/cOSqFzGRD00P7/4z68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 024/713] timers/itimer: Zero-init old itimerval before copy to userspace
Date: Fri,  4 Sep 2026 06:49:52 +0200
Message-ID: <20260904045804.370807555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


