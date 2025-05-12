Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA5678F52;
	Mon, 12 May 2025 17:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071100; cv=none; b=IHr9HbLkeJ5Gzu6c+sO+7aEBqXQOpVvrLNOlWnzSzEs2qFPUgagnnakEm7JPTGRNuDhwXIR63doYC3ClFJ20u8wDFSbr6+B7suY+wQiVJ102hMBiDcLXQd9ZpUG5q6k0MLdX7nOfjhilsa0MZSyOLgAdrEqAYZz+REr/NlGd8pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071100; c=relaxed/simple;
	bh=FN1Sy/HJSiWJgF2i2t4+7CssJIm2lXu73/8oWjz8YZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EegZgNI3dKOJpN7QC+78TXg6ZXYfshT8aKV5lRXZO/kB3Xuzcf29PsHNOnlq5uryw9QT2MCJ60dhF7yx7GjaFhqacxYAbGUIz6aikGval4DZP9eQswGB2KIOIg1sXhdFhlj/3hQ1ibVRjxnvmB4BqGdJ5i/a/dffKqgUoOtpbqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIFyYHw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIFyYHw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A190C4CEE7;
	Mon, 12 May 2025 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071100;
	bh=FN1Sy/HJSiWJgF2i2t4+7CssJIm2lXu73/8oWjz8YZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIFyYHw19vGQjzOhCWS0L6/wIDHcponfJJ6oN6sc3jMj6SqIUqcp/fEBa60XyLByZ
	 4+HvgMJwGsE4R81U3Om9lDSaYdo+jdSfWA+sP7WYUBIn3rTfEqDQe18opILSouloCV
	 8/q1R/BldlevIlzn/CB/D2wvTM9vg5+i+C0PpvQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.15 40/54] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon, 12 May 2025 19:29:52 +0200
Message-ID: <20250512172017.255192243@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 312d79669e71283d05c05cc49a1a31e59e3d9e0e upstream.

This patch ensures that the UCSI driver waits for all pending tasks in the
ucsi_displayport_work workqueue to finish executing before proceeding with
the partner removal.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250424084429.3220757-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -296,6 +296,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


