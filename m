Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248BD35C68D;
	Tue, 21 Jul 2026 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669596; cv=none; b=q0ZTmOHWMy8AhlOJlgH30b/D8ld+fYgvxyhzY2R+CY2Ei7/Or2qFpuYDKJXThguuN8VL+8l+6FrLLB9SEOE9jQufeexdtfarz9IX/m1Dyv1xQlWzOWLXZkQ8WHzD9aSLRh9Jq75YSsngD5Y3b97cPpC/fG2m/u7BsNxns3VwTDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669596; c=relaxed/simple;
	bh=AvpwQOERw+GjRvhc2bXv3zy+M9I06qh7L/QCMpecvVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFYsljfFpKRshgA6irqHLeGpHNtpqa7IRYPR3vSiaxAgfvQQa0dn7zE8VIdX3HWAR1dh8w5d7VNsVl7E86rPrHCE9eahlW1ujXvpWAp521C8/ducaeN8sXWnwGZWAw14bLrbP6FDZeaIhBQ3W46NszElKKyEeH72kVc5VgKEvu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbIZvX1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbIZvX1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FF91F000E9;
	Tue, 21 Jul 2026 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669595;
	bh=Ya+CkqRMKL/D+NFzGlu794CxD6hm7cdqa6zuTHXq9nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbIZvX1PshAaraFJX54EVZBUpl2SPkU8gJcKMuVVRl1DoB4MaXFm9SwiUDUshZn7s
	 +4u2Rdvs2TuBUHb1IX+LweQbk80STtrm7OrjKA6ul4fYvmuozN7AEl1lo2LaOWPIg4
	 q6++LOi60/oP1mlga8WWDhIuLXiG1Ceid8zKm2lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0561/1067] sparc: led: avoid trimming a newline from empty writes
Date: Tue, 21 Jul 2026 17:19:22 +0200
Message-ID: <20260721152437.154832992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7eb475e8a738ee6fd1260aa59ddccb610fdd4300 ]

led_proc_write() duplicates up to LED_MAX_LENGTH bytes with
memdup_user_nul() and then unconditionally inspects buf[count - 1] to
strip a trailing newline. A zero-length write therefore reads one byte
before the duplicated buffer.

The previous version rejected empty writes, but empty input already falls
through to the existing default case and turns the LED off like any other
unrecognized string. Preserve that behavior and only skip the newline
trim when there is no input byte to inspect.

Fixes: ee1858d3122d ("[SPARC]: Add sun4m LED driver.")
Suggested-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
index ab657b359789ea..36d851c7454ac6 100644
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -78,7 +78,7 @@ static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 		return PTR_ERR(buf);
 
 	/* work around \n when echo'ing into proc */
-	if (buf[count - 1] == '\n')
+	if (count > 0 && buf[count - 1] == '\n')
 		buf[count - 1] = '\0';
 
 	/* before we change anything we want to stop any running timers,
-- 
2.53.0



