Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659F330678;
	Wed, 21 Jan 2026 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020349; cv=none; b=R1C3zGI9GlQgempVYyzZgkqFz+mcB5CZcUYk/HNbeeZZA/fF+/XKFGsbfgjjDMxZUj5cX34ksL6YOfRDCsGdfL+FLHO0dSEk00ghARvW2Cq4YRsWPIgK8p6IlmG1iwmgC6rHCkL1c0m4Sl6dw7UHi8kOKtZMeO+cylM0KzKNJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020349; c=relaxed/simple;
	bh=uDxYZc8m3NPYsdtKHn8hc+xeVlNwGLnG8HLiUcnYYy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPEXFv9XrMqzArwN6FOMvTQwY0+n9znYFYRxyAEULvd332kmhZRMEa60bsE9mVMwFafMv2+oPlg2n9HEDTRUBM7Xkhik1V8MlAIoIUid74nDPg81nv4LXZ4wUu87W+JXnHHYP0CZOOtQk+YF5ayYmqgvi0Ba6VWq0ykglvb28AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faAEqbBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faAEqbBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D09DC4CEF1;
	Wed, 21 Jan 2026 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020349;
	bh=uDxYZc8m3NPYsdtKHn8hc+xeVlNwGLnG8HLiUcnYYy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faAEqbBS5zu9F8DdIQQcD/TLGv5jUMZX77JEbIoWS70mka7chPkbl/aTWfB/S8rkM
	 3TrhQCwwI989uAxODhMPilYj+LSkMe6f2WtC4oaGhOji9Cl89X+KRrn7Nj93l9uime
	 WPvdHdrMf8AAy83+V1orns7l0Sl1AcrwNlIlwHYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 130/198] hrtimer: Fix softirq base check in update_needs_ipi()
Date: Wed, 21 Jan 2026 19:15:58 +0100
Message-ID: <20260121181423.226765985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 05dc4a9fc8b36d4c99d76bbc02aa9ec0132de4c2 upstream.

The 'clockid' field is not the correct way to check for a softirq base.

Fix the check to correctly compare the base type instead of the clockid.

Fixes: 1e7f7fbcd40c ("hrtimer: Avoid more SMP function calls in clock_was_set()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260107-hrtimer-clock-base-check-v1-1-afb5dbce94a1@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -913,7 +913,7 @@ static bool update_needs_ipi(struct hrti
 			return true;
 
 		/* Extra check for softirq clock bases */
-		if (base->clockid < HRTIMER_BASE_MONOTONIC_SOFT)
+		if (base->index < HRTIMER_BASE_MONOTONIC_SOFT)
 			continue;
 		if (cpu_base->softirq_activated)
 			continue;


