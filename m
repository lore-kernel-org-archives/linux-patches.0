Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6635A942;
	Fri,  9 Jan 2026 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960550; cv=none; b=lYXntFFnuGf0+1OPAA0zKlqd40w/sSVcKjuhYrOJZ4uhnSBz8+/txC//UteW50Dvqc7CgU5YMlEj4XKd304+FNJGsCeYy30LslIJwro6AIm02eZJo9zsehxCUq88BGd8E4YpS3z6ZSYW1pE3kjXRSNieyzPIFhjP2hn6uMQjM0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960550; c=relaxed/simple;
	bh=Pw22IraXcasHyBNW5rbiDu0s6Dy6+1MmNyb8NlMJ7xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERsSaE/LtGdAc3QcOyZYHN1wanCYHuXxbaY6n8e+AG4hHvZkO+znEPQMHmU+NGu+sU+uULPCSdy57eBewevnpVaZLjdzIT5zZ72/J3KaaUEKMoxKIlI2Zolj7szlXSsENEtZLjG2SR+emapviYmQRgOAmnt2ZzdBjI+4RbeStDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGL6ifV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGL6ifV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19257C4CEF1;
	Fri,  9 Jan 2026 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960550;
	bh=Pw22IraXcasHyBNW5rbiDu0s6Dy6+1MmNyb8NlMJ7xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGL6ifV2VABmfLz61OuH4JYzOqhmK/I9Shgz4GDZh7/4uUkH7gsiarQ4evM0/s7Y9
	 q2KifR34QN3iI16y1aFTJH4LQE6oEvQ7WtGteNYphW22G1gLBTOKhZ9PwKL0yQ5NkT
	 7Ib7FTjyN6sNmiLt+m8dmCn9JgntgGDpDKj9YekY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.6 443/737] cpuidle: governors: teo: Drop misguided target residency check
Date: Fri,  9 Jan 2026 12:39:42 +0100
Message-ID: <20260109112150.658343123@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -595,11 +595,8 @@ static int teo_select(struct cpuidle_dri
 	 * If the closest expected timer is before the terget residency of the
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


