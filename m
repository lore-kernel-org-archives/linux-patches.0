Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3DE3D8115;
	Wed,  8 Apr 2026 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673282; cv=none; b=cUsV0FjptPOGq0MasXOkWupB90qVZMGOAR8BgMyOz0vDAndFNZLnhpJj/Wir7ux7H4FRU6fqHPyLhAJ1hFV2sj8Hl9jglGrKaLckXSlyLcU1qWFauNVNJ5tUhynRiOQwnuPqr1zGohiLPE0QhgkNSOUq+d3d8e4ouz/GOWoAfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673282; c=relaxed/simple;
	bh=68QOWlmxzP5T95q6eB1szwykBl3lBa0rTTq1tD+diy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sf92FEkHkrYSERNwpoVrRcslvYT8D5g52KjXr3dwClNnn0gJfwRWBEp7GRiNJ9Rtz6aiSXTKUJY096FmHhjdaeZG/ZCulfoDxc5h9100ZddjlLBwS1gILEPeJYtuI1Ytw/iexb9mZqKASK98ii845i8C6ZvdRUJ8z7XJxpiP7pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vf0Ba3dZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vf0Ba3dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA3BC19421;
	Wed,  8 Apr 2026 18:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673282;
	bh=68QOWlmxzP5T95q6eB1szwykBl3lBa0rTTq1tD+diy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vf0Ba3dZ2/lFntk6oMxlWefRpzNHbt5+m8ps0LWH9nM7YItW1eJGdnROoPup/wYwM
	 4ksLQ8zMWVY6gWu7W6LSe2NLGizO/QN+FDcBY37+4rYk8nUThniwwR9nW4WUPFdGR3
	 pwErHpoM11I/fgzBBt2mO5lme0jxUlhEEEahoiVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 171/277] Input: synaptics-rmi4 - fix a locking bug in an error path
Date: Wed,  8 Apr 2026 20:02:36 +0200
Message-ID: <20260408175940.252084361@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -538,6 +538,8 @@ static void rmi_f54_work(struct work_str
 	int error;
 	int i;
 
+	mutex_lock(&f54->data_mutex);
+
 	report_size = rmi_f54_get_report_size(f54);
 	if (report_size == 0) {
 		dev_err(&fn->dev, "Bad report size, report type=%d\n",
@@ -546,8 +548,6 @@ static void rmi_f54_work(struct work_str
 		goto error;     /* retry won't help */
 	}
 
-	mutex_lock(&f54->data_mutex);
-
 	/*
 	 * Need to check if command has completed.
 	 * If not try again later.


