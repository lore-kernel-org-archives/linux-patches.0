Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10064657CF;
	Tue, 16 Jun 2026 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629252; cv=none; b=B5HkIyhsrNmEd4tk4O+vbsxj3EP3fravHPt1APZ6j15GxOvi3HAConiLRZ2kzuXXKCuJPjf6KZ/7v/HeVSK/n7b2tGC//q1XF7GmjbZe4g6ptkPwI53C4x/W+6g5boq5LIaksX7lTXnPWeX0yE5fOkkutotroAztEdvAgsj3nDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629252; c=relaxed/simple;
	bh=sXvAZYDYe15xeScwtl7ohGskrlHbn5UI4Ud3kEBbV+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UF5IkBj1yqWdJ47VUmtKiKd183gTeHVgD9jBuKv6OvqI53eTt2UxIgFKdTYwMBFRcV2/4x1pR54HAoVMYHqbBSEaDBsRYiDoQ//qe6hocVz21DxZYcX4fVNvZtdb/PVSkP4+ZoJV7NKnA67nKlqXcOfjqy58dzKCg7YJIHwC4MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeUt++kN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeUt++kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E711F000E9;
	Tue, 16 Jun 2026 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629251;
	bh=GnDSSocBEgRlSGzNPWQap3vkicdd0DopCJ5KqRANQPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeUt++kNUGgZdjUyHeV71SvAj4XS3zxBsQT4Qe1rdgYERnJfMb7IUN+sErPTqV51U
	 kuIadEYMeLekewP0zdtMTjycsRBImfcDHL1FGT/7E/ME4Q3UB9sEKor7+Rwb8g4Ha5
	 jihtyftDXRu1QOJqHuEzm4QPtB1prXsGwr9DeI74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/452] time: Fix off-by-one in settimeofday() usec validation
Date: Tue, 16 Jun 2026 20:27:56 +0530
Message-ID: <20260616145130.747238739@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit ce4abda5e12622f33450159e76c8f56d28d7f03d ]

The validation check uses '>' instead of '>=' when comparing tv_usec
against USEC_PER_SEC, allowing the value 1000000 through. After
conversion to nanoseconds (*= 1000), this produces tv_nsec ==
NSEC_PER_SEC, violating the timespec invariant that tv_nsec must be
less than NSEC_PER_SEC.

Use '>=' to reject tv_usec values that are not in the valid range of
0 to 999999.

Fixes: 5e0fb1b57bea ("y2038: time: avoid timespec usage in settimeofday()")
Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/4rikk44zew3s6577dugmx4jyblz7o5c57niuap6ct3td5yfm6w@gh7pcumg7qor
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index da7e8a02a0964f..a6261fadb92b15 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -207,7 +207,7 @@ SYSCALL_DEFINE2(settimeofday, struct __kernel_old_timeval __user *, tv,
 		    get_user(new_ts.tv_nsec, &tv->tv_usec))
 			return -EFAULT;
 
-		if (new_ts.tv_nsec > USEC_PER_SEC || new_ts.tv_nsec < 0)
+		if (new_ts.tv_nsec >= USEC_PER_SEC || new_ts.tv_nsec < 0)
 			return -EINVAL;
 
 		new_ts.tv_nsec *= NSEC_PER_USEC;
-- 
2.53.0



