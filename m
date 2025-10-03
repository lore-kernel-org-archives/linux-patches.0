Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E0C26E6FA;
	Fri,  3 Oct 2025 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507709; cv=none; b=fk29byiGE3B+Ekgg4EVqc5/d0ywIWDc7Ld/TJWvnFJKu7jBXKRBuRzNySPx9vJMqxgGsQniiGWTO/xCgnoSlhiMrmA5soF+jEF0lHZDBw1as34h26eralq4mkJIAAEacH5Dtk81y+3qGFCZrgILZnYMFolVSVbBZzi4KBhQycq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507709; c=relaxed/simple;
	bh=0x1LGbdtP+lCVyrdI2OaAgXgyhDDsD5WOd5keVVQtx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8C6DDOSneHVkKXHGW5WljNo7/cTtXkAbX2gAn4V9hpK80SXN49XA/nixUaCfPht6Ssk8VJg99tWzakzwooTa/ZDrQWns6xidDlGadThJshMEP7gBqY6ASDgfIdq4/UWGm3Kc7JfM8yyz9xG1p/FvLeLHO3TwouF0oOTqGgYLPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM4wFSHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM4wFSHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4FBC4CEF5;
	Fri,  3 Oct 2025 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507709;
	bh=0x1LGbdtP+lCVyrdI2OaAgXgyhDDsD5WOd5keVVQtx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM4wFSHrcsFY9k8oiJTpgnljGOXlvCzBOnJvk2tHXBBDk1/iGnvGW4LBBIZ0spcI7
	 arhRewr+FScziuOK6aHHHcqRqgh1H5QTVhpRNWJFAmlLoDuKFl6XpYl3kjvzQc4PN2
	 0ugdLPFwlGoD42VUvfI6lRF6cg45WjiXmXLBegC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 05/10] media: tuner: xc5000: Fix use-after-free in xc5000_release
Date: Fri,  3 Oct 2025 18:05:52 +0200
Message-ID: <20251003160338.617672511@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 40b7a19f321e65789612ebaca966472055dab48c upstream.

The original code uses cancel_delayed_work() in xc5000_release(), which
does not guarantee that the delayed work item timer_sleep has fully
completed if it was already running. This leads to use-after-free scenarios
where xc5000_release() may free the xc5000_priv while timer_sleep is still
active and attempts to dereference the xc5000_priv.

A typical race condition is illustrated below:

CPU 0 (release thread)                 | CPU 1 (delayed work callback)
xc5000_release()                       | xc5000_do_timer_sleep()
  cancel_delayed_work()                |
  hybrid_tuner_release_state(priv)     |
    kfree(priv)                        |
                                       |   priv = container_of() // UAF

Replace cancel_delayed_work() with cancel_delayed_work_sync() to ensure
that the timer_sleep is properly canceled before the xc5000_priv memory
is deallocated.

A deadlock concern was considered: xc5000_release() is called in a process
context and is not holding any locks that the timer_sleep work item might
also need. Therefore, the use of the _sync() variant is safe here.

This bug was initially identified through static analysis.

Fixes: f7a27ff1fb77 ("[media] xc5000: delay tuner sleep to 5 seconds")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: fix typo in Subject: tunner -> tuner]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/tuners/xc5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1304,7 +1304,7 @@ static void xc5000_release(struct dvb_fr
 	mutex_lock(&xc5000_list_mutex);
 
 	if (priv) {
-		cancel_delayed_work(&priv->timer_sleep);
+		cancel_delayed_work_sync(&priv->timer_sleep);
 		hybrid_tuner_release_state(priv);
 	}
 


