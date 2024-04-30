Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5727F12C462;
	Tue, 30 Apr 2024 11:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474843; cv=none; b=m+MWhWWgBjqGXtKnlU04+I3nsdz7C507PKVxcc197FL1VjNXHR0VGscUZESF9h3YO8jZRFw5TN6qegWEo1Kh4LuGbN0rtLxF7LRcDRtPgMONjPqUhwc06INGGNRXNso382vw0UE0yLMXZpvweqekfoqi1/9cWMvYicEduOtyQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474843; c=relaxed/simple;
	bh=FTSvSt3uvxPL4SUkELdR6Bb5yfHQ/nJM30xQ1YRoDO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTyo/0XrgZo3XHcT5a2ZPubO6kbKE1vabiukcdtxZ9E6G5428cgTHkE8UfD5f0PcBIwY6wQeOcwaaQHzcKOITXOz7uAJp+760OZLPBQcXMFVt4Z3uqdIil9wGAYCGZcF6C7GjmoeDiUZ0SyFR/YZHUzA+gjxJVPW/VrqYv2mgXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrMRuUXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrMRuUXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E165C2BBFC;
	Tue, 30 Apr 2024 11:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474842;
	bh=FTSvSt3uvxPL4SUkELdR6Bb5yfHQ/nJM30xQ1YRoDO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrMRuUXY3mI13wfitPhAIQq9CCfF0636xH4fK9SxsTbLkgzVkHESJf4EAOixnAx+x
	 z3LH0gLCZyskCZpNbH9yNhJ+qFenaSKTPkmJ44fK3i0yaohRSMenMIk7BXADzEdj+L
	 LSiCqWhtCmw6Xsx6VrFcKkgexAR7XOyq59Cue1LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 053/138] thunderbolt: Fix wake configurations after device unplug
Date: Tue, 30 Apr 2024 12:38:58 +0200
Message-ID: <20240430103050.988653092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

commit c38fa07dc69f0b9e6f43ecab96dc7861a70c827c upstream.

Currently we don't configure correctly the wake events after unplug of device
router. What can happen is that the downstream ports of host router will be
configured to wake on: USB4-wake and wake-on-disconnect, but not on
wake-on-connect. This may cause the later plugged device not to wake the
domain and fail in enumeration. Fix this by clearing downstream port's "USB4
Port is Configured" bit, after unplug of a device router.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2402,22 +2402,29 @@ void tb_switch_unconfigure_link(struct t
 {
 	struct tb_port *up, *down;
 
-	if (sw->is_unplugged)
-		return;
 	if (!tb_route(sw) || tb_switch_is_icm(sw))
 		return;
 
+	/*
+	 * Unconfigure downstream port so that wake-on-connect can be
+	 * configured after router unplug. No need to unconfigure upstream port
+	 * since its router is unplugged.
+	 */
 	up = tb_upstream_port(sw);
-	if (tb_switch_is_usb4(up->sw))
-		usb4_port_unconfigure(up);
-	else
-		tb_lc_unconfigure_port(up);
-
 	down = up->remote;
 	if (tb_switch_is_usb4(down->sw))
 		usb4_port_unconfigure(down);
 	else
 		tb_lc_unconfigure_port(down);
+
+	if (sw->is_unplugged)
+		return;
+
+	up = tb_upstream_port(sw);
+	if (tb_switch_is_usb4(up->sw))
+		usb4_port_unconfigure(up);
+	else
+		tb_lc_unconfigure_port(up);
 }
 
 static int tb_switch_port_hotplug_enable(struct tb_switch *sw)


