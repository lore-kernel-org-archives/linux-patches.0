Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E55347C6;
	Mon, 29 Dec 2025 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025698; cv=none; b=gYJlDLD5ipkDkmY58AX2NGHOZ+OlSWdNON5E3hjiQtyE5tv+LYkE0oXxhm9lM8/NX7hwuhtUn7GnZEDJYXFNzHpJa9Bc1xDq6JYtLgv9kGJjMics+xdkg0Zvuhiqu1ezG3taol07hncJw6Ecs0UFZh/3W//FyWy/Q2Rf6VQvbng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025698; c=relaxed/simple;
	bh=sEdZBzZWE5kpNYZDr4JyqQ55ZC5z+uZnQwaayaFreEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk1rti7drzXAhFoH9zgxtcQs03iqXUcpHSCyNoHDp2sdzXxNczUnzgtLYeqmdNlWaPiToVO0Gl0g0J4O0UeIF4g/7H7AcL4zkBvi6kxaxog18JM/MpBXUikFfr7h1HbnD7ZDdhFBQwLC2yXsM9q02jTKRJoDZrj4l+NUTDvRx+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpeQB9Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpeQB9Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1332DC4CEF7;
	Mon, 29 Dec 2025 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025698;
	bh=sEdZBzZWE5kpNYZDr4JyqQ55ZC5z+uZnQwaayaFreEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpeQB9GhMV+DQjcdz2AEMeGYdee+TrlHY1e8/MhvBkrY3jMDWa5LBxK4RbfXPv0hW
	 EwifRNa+cIFQdCB1OcGv86LKhO1lWxqWHa99YSZCO+5mb7EEobTNSGXYaLJA7B4x+y
	 +hQVbiT3/gjSBzdYS/sNRTe6s8VbNyYW+9Hxa7Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.18 304/430] cpuidle: governors: teo: Drop misguided target residency check
Date: Mon, 29 Dec 2025 17:11:46 +0100
Message-ID: <20251229160735.522864833@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a03b2011808ab02ccb7ab6b573b013b77fbb5921 upstream.

When the target residency of the current candidate idle state is
greater than the expected time till the closest timer (the sleep
length), it does not matter whether or not the tick has already been
stopped or if it is going to be stopped.  The closest timer will
trigger anyway at its due time, so if an idle state with target
residency above the sleep length is selected, energy will be wasted
and there may be excess latency.

Of course, if the closest timer were canceled before it could trigger,
a deeper idle state would be more suitable, but this is not expected
to happen (generally speaking, hrtimers are not expected to be
canceled as a rule).

Accordingly, the teo_state_ok() check done in that case causes energy to
be wasted more often than it allows any energy to be saved (if it allows
any energy to be saved at all), so drop it and let the governor use the
teo_find_shallower_state() return value as the new candidate idle state
index.

Fixes: 21d28cd2fa5f ("cpuidle: teo: Do not call tick_nohz_get_sleep_length() upfront")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/5955081.DvuYhMxLoT@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/teo.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -458,11 +458,8 @@ static int teo_select(struct cpuidle_dri
 	 * If the closest expected timer is before the target residency of the
 	 * candidate state, a shallower one needs to be found.
 	 */
-	if (drv->states[idx].target_residency_ns > duration_ns) {
-		i = teo_find_shallower_state(drv, dev, idx, duration_ns, false);
-		if (teo_state_ok(i, drv))
-			idx = i;
-	}
+	if (drv->states[idx].target_residency_ns > duration_ns)
+		idx = teo_find_shallower_state(drv, dev, idx, duration_ns, false);
 
 	/*
 	 * If the selected state's target residency is below the tick length


