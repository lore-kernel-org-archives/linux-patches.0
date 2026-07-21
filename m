Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484DC44AB6D;
	Tue, 21 Jul 2026 21:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669450; cv=none; b=WJgKeTwtP1xVbLyjQo4h08k3uQpGWXS4+rIHYjGRXG3Lyf+k0aaD/BBDLg5luynXKsZ841HeojFLyPVMCsPG4yZgKERHcFL+ujDJjcca9Bo+NtA3A5Yf9cdi01mocKWzdF/wncZPNupH4ENjH+7PuQJnt9ANEonsviq2BDcMxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669450; c=relaxed/simple;
	bh=LOnj4VNvQpo4VGxKrYN9kFzlVAtaHWJH1RmxanvDdUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So/nNGCmDzsebs8+K/ZuEf1xRTGxHIPOx0FDNcrx9cNxOhV4uVGbykf5WHcx+tS3HjCdV23oIPclYnCcImv7YqXGYBtegPaHSsuFUw7I3WpDuU/3CZo9TosLnSiXhUZijoiQJtt37xyo2QcIRFzbwqElMqOJWwVGcF1mStrivfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWT5c/2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWT5c/2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE931F000E9;
	Tue, 21 Jul 2026 21:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669449;
	bh=sae4ERUtzhfIJSfvgw0TM2fUKDyhqWuKSXNHRTL6Kuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWT5c/2N8J97qV88GkP5r5nHfGfnd8EKxKr+dM2MS4x5dg/ZxWekl1lrjKgFY2EEU
	 Ad+lcMfESLZKlFvEG0FciyXKvPaoxDGKuuI+xyay1YKrG8DENsB1fGAfJVU3Qe8y0y
	 yOQQs2IugmpFR7G1dUy4DdjRUM0I+2HxrPQULK7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0557/1067] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:19:18 +0200
Message-ID: <20260721152437.067588157@linuxfoundation.org>
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

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index 86ad26ef72ed42..9fdbbd720b3d2b 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -54,6 +54,8 @@ int aa_getprocattr(struct aa_label *label, char **string)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



