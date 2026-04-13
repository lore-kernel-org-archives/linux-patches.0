Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D822B30C359;
	Mon, 13 Apr 2026 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098261; cv=none; b=OqMhC2H709sXndqHKZMxsVu6Mx736EM66L3QVLpBTK+sFFU03/lgZzIy0AzljzpxF4Cw6sfXOUCmUfyIyrGcIr/D9zenfJ3Yjy3ugWi/pSTyU648bYZrkuVNeoQxxQI6ONVA0vVR8hm73iSlDNiLGoHqhzIx+12mhpl8rHz/M/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098261; c=relaxed/simple;
	bh=+TdS+pyQ7osIyRti7OimKPW8QPDtgTi7l/pFe+OAQek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSAnjYNuurubvRSCzlHdEtyAS0mwz9dOG6HX9IP6x5Khx/P611FI8OHnKPjl0pQrZQTIKFbgyXwK8i9tB55jLFpoOR9bgoxJKimJ78KnUFyzN7jTKtuqwJwWoERLdUtW0uQbRiC2p4ELirCdin+U0LIUGcdGPi4+gH6KNVRxGdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3mu88g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3mu88g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F26EC2BCB0;
	Mon, 13 Apr 2026 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098261;
	bh=+TdS+pyQ7osIyRti7OimKPW8QPDtgTi7l/pFe+OAQek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3mu88g4TWLm+4Mz1kw0TBuIVFyxGlgzQ2rN6s8Ei2P6f+67Zj69H4r3sjHic4YMN
	 mCIg6aPAdToWcTA6wjubHPBeBqdkEHehBxvCMPAJ316KqTegJeqR0vEtSaHdJOrtVQ
	 yyyjRbgrSbdmT9uD8zjD/x3LoUD7UiJPsBAt4Pqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 456/570] Input: synaptics-rmi4 - fix a locking bug in an error path
Date: Mon, 13 Apr 2026 17:59:47 +0200
Message-ID: <20260413155847.551873310@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 7adaaee5edd35a423ae199c41b86bd1ed60ed483 upstream.

Lock f54->data_mutex when entering the function statement since jumping
to the 'error' label when checking report_size fails causes that mutex
to be unlocked.

This bug has been detected by the Clang thread-safety checker.

Fixes: 3a762dbd5347 ("[media] Input: synaptics-rmi4 - add support for F54 diagnostics")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223215118.2154194-16-bvanassche@acm.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f54.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -540,6 +540,8 @@ static void rmi_f54_work(struct work_str
 	int error;
 	int i;
 
+	mutex_lock(&f54->data_mutex);
+
 	report_size = rmi_f54_get_report_size(f54);
 	if (report_size == 0) {
 		dev_err(&fn->dev, "Bad report size, report type=%d\n",
@@ -548,8 +550,6 @@ static void rmi_f54_work(struct work_str
 		goto error;     /* retry won't help */
 	}
 
-	mutex_lock(&f54->data_mutex);
-
 	/*
 	 * Need to check if command has completed.
 	 * If not try again later.


