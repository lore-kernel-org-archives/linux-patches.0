Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C621F2381;
	Thu, 12 Dec 2024 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023604; cv=none; b=mzcFm5CYOGyx4PceUjhXTi3dAAbDi0kpkrs0x2ifM7LdxbZ5DfLl9iG90jnf1xg6aadZBgT1vGcXARSkOoa0GZsThuWDL8gGQv9lU+9euTXS5KwBjk6J8WfRiWvisoI8SjB+fACYUR9ouJM0iu+13icP/7YWG+HxKliYDeUt3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023604; c=relaxed/simple;
	bh=smxHBzsiNsnRfNtTRsa6bwVQ4H2yghowpk374csa7hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlZRmqE3rvEZDq3nrpYukQYfBG0VBw91ICE2MzHW5PqRavcJwjdz1dcxCUqvmrLq6SAUxz+VItIXaaXCpNrIFNjDQ37iIOVq7Se4qtsP91Dj22mFemvokvb81xepJMqCSXRl/7bkzmnT3T665QgHQp+iRH3tPBDgb3mi2ASZ0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDmyRWfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDmyRWfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E42C4CECE;
	Thu, 12 Dec 2024 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023604;
	bh=smxHBzsiNsnRfNtTRsa6bwVQ4H2yghowpk374csa7hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDmyRWfDokmcNAgQIE/g2ykzfn81EwgM0fQTESfeVmVQfjb4V1HtihendrWqFZ2yn
	 76Ii0nYMO3UplRlq5Fl6vlakSmG+42FP59v3JHz+oww6Z8yx9MhSAy5C9IXLDMMnav
	 H/JT8h888YjKExA0D1OSDsDOVkF8v4utQnJSf/6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 005/459] media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()
Date: Thu, 12 Dec 2024 15:55:43 +0100
Message-ID: <20241212144253.738941651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d2842dec577900031826dc44e9bf0c66416d7173 upstream.

In set_frame_rate(), select a rate in rate_0 or rate_1 by checking
sd->frame_rate >= r->fps in a loop, but the loop condition terminates when
the index reaches zero, which fails to check the last elememt in rate_0 or
rate_1.

Check for >= 0 so that the last one in rate_0 or rate_1 is also checked.

Fixes: 189d92af707e ("V4L/DVB (13422): gspca - ov534: ov772x changes from Richard Kaswy.")
Cc: stable@vger.kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/ov534.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -847,7 +847,7 @@ static void set_frame_rate(struct gspca_
 		r = rate_1;
 		i = ARRAY_SIZE(rate_1);
 	}
-	while (--i > 0) {
+	while (--i >= 0) {
 		if (sd->frame_rate >= r->fps)
 			break;
 		r++;


