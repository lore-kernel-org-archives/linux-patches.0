Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CAC3A9627;
	Tue, 16 Jun 2026 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631483; cv=none; b=t87DNGBu1mRkwzBwdEtTr4G+xVoQDMavFCVWBJxJs0LwPj4Kl9OmLkJ9/Ua1oSgDKDtLqJndNWACC2CFU81wNJgcUBGFE9ZOymquZ4MVwMtK3Dl0SiQoZ8185eWnBOlEobW9n3G8ldB1pQhKXVKj3hx0rVyL+F/6rrnTp50uRIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631483; c=relaxed/simple;
	bh=oPC2XwLmu/YnXZ8MufVDIO91ap3JTZoRwqEZqgJI9A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaaTMhHsXIItFbPFEzs9tMNx4BUSAsPipjZuVz8ybPJGktZhF1Wd4ASuFreKSN4u5SXJMRko0PDv0eI0WA3nrY/W4MA1mn4DjyuUy7H2XYBmZQCXllxbakSDl34DIuk9PgpQo7qqW6CugfzigSLqGojjchkwxOcXsItLwytNNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBCgua4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBCgua4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916911F000E9;
	Tue, 16 Jun 2026 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631482;
	bh=rKYMtdPRBSsENhF6JuT3l7h+AYMTTC6T83RrKdzHC44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBCgua4f0UVYehU5A1/JFhRE1VixFvaCj5pMUzcaQk17JT1yFPsZadrGHWi1rGBbv
	 izhpPtoX3GkpaAp35tIwnz+g79wUkJQr5ZJqn9Qmj5RaOE8pxGRFvtlVMyy/i5g7Sy
	 v3dJVSQf0ulJmIHRqNqW5dhLbZzy4iVbHfen9rpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/522] time: Fix off-by-one in settimeofday() usec validation
Date: Tue, 16 Jun 2026 20:26:16 +0530
Message-ID: <20260616145136.714629147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 170f1f8a0046ce..0e0b54fb34905e 100644
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



