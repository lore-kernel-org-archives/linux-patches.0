Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF037C0E2;
	Sat, 12 Sep 2026 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197809; cv=none; b=S1tWZuFJ/tc5VSVxvlwdEUfcESXM1q0iSdGIxtSX4VMQI18gOfEFTGtaNEgd62BewgXiRNPdtDMr4yrHverVcAH0+ge9IJ6LuvP8YCIIzllhP/sUkcCvw1AYzYK4Vi/U9Vtjm9Tgz68ZjA3ehgmDSOIdoQNIlCFQ3YS3CP/1dng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197809; c=relaxed/simple;
	bh=I33RsxNI48Scu+TsmSNk5Baw1MhqlcdDimwyDu9Xrxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1NCGWtH3wHm/TTXOKTwFainHKBUDg6IXFbhx27DpezlV+ih+eRaGuCd79uELF8iQF7eFStEHj7M4lRdZBJyRXQUjj8Nnm1ATDMCrb/IdSVueHLntSBFT8ECgzR4k57xYz/AJzCfKR52F4IeiBMWPv+H7QtmPnyQ8iF87d7db7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAFJ81hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAFJ81hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3501F000FF;
	Sat, 12 Sep 2026 07:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197808;
	bh=NDbFD2P/yh/WAJJi66E+RcrmJMNLx1L2NYfhd571R7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAFJ81hjg3obyVOCCw0PYxUXVvZvfhFuFtqetUCKjNxew+TngRooTLVTQiEZsrzH1
	 7osPj9iTFaljPXPoUnH9R7UbK+Aro5PEqkb6LA9ovmk+RvkfOBHOrw+c9PBKq72u3t
	 rogr1CrBEVUVAx8fe9A4aMluh+625j4ArohTdeLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0251/1815] y2038: uapi: Use 64-bit __kernel_old_timespec::tv_nsec on x32
Date: Sat, 12 Sep 2026 08:33:21 +0200
Message-ID: <20260912065654.876177139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 79ced850e549e8c86b772a79ea417a1425b5c04b ]

'struct __kernel_old_timespec' represents the 'native' time ABI of the
kernel. On 32-bit systems it uses 32-bit fields and on 64-bit systems
it uses 64-bit fields.

However the x86 x32 ABI uses the 64-bit time ABI natively.  This is
correctly handled for the 'tv_sec' fields, through the typedefs of
'__kernel_old_time_t' -> '__kernel_long_t' -> 'long long'. The same
treatment was missed for 'tv_nsec'.

In practice this might not make much of a difference as the value of
'tv_nsec' will always fit into 32 bits and the missing bits fall
into the padding of the structure.

When introspecting the structure however, a difference can be observed.

Switch to 64-bit tv_nsec on x32.  No other architectures or ABIs are
affected.

While this could be interpreted as violating the POSIX requirement of
'timespec::tv_nsec' being 'long':

  * __kernel_old_timespec is not actually the POSIX timespec type

  * the requirement is gone in newer versions of POSIX

  * this matches glibc

Fixes: 94c467ddb273 ("y2038: add __kernel_old_timespec and __kernel_old_time_t")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260504-timespec-x32-v2-1-0739c9047fc4@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/time_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/time_types.h b/include/uapi/linux/time_types.h
index bcc0002115d39..03a0d8aaadca5 100644
--- a/include/uapi/linux/time_types.h
+++ b/include/uapi/linux/time_types.h
@@ -30,7 +30,7 @@ struct __kernel_old_timeval {
 
 struct __kernel_old_timespec {
 	__kernel_old_time_t	tv_sec;		/* seconds */
-	long			tv_nsec;	/* nanoseconds */
+	__kernel_long_t		tv_nsec;	/* nanoseconds */
 };
 
 struct __kernel_old_itimerval {
-- 
2.53.0



