Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA4A329371;
	Mon, 13 Apr 2026 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099535; cv=none; b=HsuV3jVuttIz0cZTiROoL2psTszgkqpR3eiPqx42dFWHCYSJqBWGmqRsech5KghTzmJ7iyNMDB4zUMWxiLXWnSMtxowIwWRmYeOjYg8gzDDxnE48qvwlltoEvdPVeT1m2sn5V8RLxDp/po/xkCtlE1FrsjLpsIdrvajK9lZFe5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099535; c=relaxed/simple;
	bh=UrAO0GGIP2OqdyudOHEFCCYr6DXKvB+0ol3NdEc0U4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+Dj+b0rxtIgyUkJrMQnmU46OUKRnFYM+e7BqS2m7L0xPoaiiTa0mYnusRL9pFFFJwsQ4FF9YmkjQdqHlHorRWSFE3kMHQrGba/digTw7KUAskx03uM7IRVE2K8iFNJrfm4upKyxEK4NOZ/HoxZzUGOXzISccvI2mLIdkyJejS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIIhRlgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIIhRlgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF275C2BCAF;
	Mon, 13 Apr 2026 16:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099535;
	bh=UrAO0GGIP2OqdyudOHEFCCYr6DXKvB+0ol3NdEc0U4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIIhRlghtFxd4hmuMFFFznLK/rTFpdMn8u+HLQfCGIpGWhyADbjgRtR0t097gH2nm
	 e3yuiza/A8Ak2Ev6R3lb2M1cOAqfzPPybTzV/Ex0++jtzL+YPqNWtRAKevVwVqGVDa
	 DKcQlbj7Ur8agfyikIAf5Qo1GKqnXlwKetgdZ07c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 377/491] Input: synaptics-rmi4 - fix a locking bug in an error path
Date: Mon, 13 Apr 2026 18:00:22 +0200
Message-ID: <20260413155833.148334001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -534,6 +534,8 @@ static void rmi_f54_work(struct work_str
 	int error;
 	int i;
 
+	mutex_lock(&f54->data_mutex);
+
 	report_size = rmi_f54_get_report_size(f54);
 	if (report_size == 0) {
 		dev_err(&fn->dev, "Bad report size, report type=%d\n",
@@ -542,8 +544,6 @@ static void rmi_f54_work(struct work_str
 		goto error;     /* retry won't help */
 	}
 
-	mutex_lock(&f54->data_mutex);
-
 	/*
 	 * Need to check if command has completed.
 	 * If not try again later.


