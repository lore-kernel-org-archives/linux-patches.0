Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF712C11E7;
	Fri,  4 Sep 2026 06:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501887; cv=none; b=fSryj+fHy6FiBZ9uPs19BTYBLlvLTLrjrrNKfdliWZ48e5G08nhQO5NpD3cSQBjtCUHzc56ZDpYNny+uL5PHgM52hvk3BmnneuHBRwtUH6r77ufWbxIoN+N+Yld+7x69SA2sy8p2LsiopqkwKvpFHFineIBhHGcKERQbSZarQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501887; c=relaxed/simple;
	bh=fjGq9bV3xAeMtBbxhYagJlsnA8PwmgAuR4lxfhkBngU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5Bjn26mYnbwAk8cn8SkFikNlNbefKfCQHLzcAnuG0w1Oif+xZFoL5Yry7f/h22Ej81eIJR0iaTQhOjdi5Fc+nb+dUWPFJbjzIcrdC08FWNmezt7DKuqIlypNE80kSyk5zqAKMnEIo/tLKBDQffKGpTfZkUZ2Hndsw6ipZ7yoP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjxNhsAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjxNhsAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64AB1F00A3D;
	Fri,  4 Sep 2026 06:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501886;
	bh=Y2fFd8stFDnv2SgfnF6H1oLuA68CWUEbT+tnSiN4yO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjxNhsAfSxnemAWmV56k8+SBBzWUFdfhGXKxLd+umKvFRCxjenTRwc/52twt40oEr
	 aN6CT9R8msMDX0fj/HNY8kcfl5YcKP+oE6DpNPZpUtkqnp/46q/5WgrpFZ/+EdnaXe
	 O7yLNMGXfxJIUt/7yGsPqij5OA8Aa4wr+KIm4yYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 015/403] timers/itimer: Zero-init old itimerval before copy to userspace
Date: Fri,  4 Sep 2026 06:56:58 +0200
Message-ID: <20260904045735.160380976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


