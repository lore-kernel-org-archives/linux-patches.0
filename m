Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930414C3A0;
	Mon,  8 Jan 2024 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM0qgwCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DEAC433C9;
	Mon,  8 Jan 2024 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726951;
	bh=aCaedfca2MrHNiVnOB1OyhpsBfcV7Cx5ZQwSqLjjdyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM0qgwCVbGJ8n7Wr/nywMCFfX9VoQdsCCtozAOIVreXVufEzVm3e2d8nzziY1vSRw
	 s2KtQIiKQK65xiE6lE1TMJIRZU3zzX7DLTjICQKHa3q8KRZuJRp7RufhMqHiON0LMh
	 +zpzUbCiMRiH47Z5hGbSOkpHNAzJLEssrZ1qI93A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 123/124] cxl/memdev: Hold region_rwsem during inject and clear poison ops
Date: Mon,  8 Jan 2024 16:09:09 +0100
Message-ID: <20240108150608.623570747@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

commit 0e33ac9c3ffe5e4f55c68345f44cea7fec2fe750 upstream.

Poison inject and clear are supported via debugfs where a privileged
user can inject and clear poison to a device physical address.

Commit 458ba8189cb4 ("cxl: Add cxl_decoders_committed() helper")
added a lockdep assert that highlighted a gap in poison inject and
clear functions where holding the dpa_rwsem does not assure that a
a DPA is not added to a region.

The impact for inject and clear is that if the DPA address being
injected or cleared has been attached to a region, but not yet
committed, the dev_dbg() message intended to alert the debug user
that they are acting on a mapped address is not emitted. Also, the
cxl_poison trace event that serves as a log of the inject and clear
activity will not include region info.

Close this gap by snapshotting an unchangeable region state during
poison inject and clear operations. That means holding both the
region_rwsem and the dpa_rwsem during the inject and clear ops.

Fixes: d2fbc4865802 ("cxl/memdev: Add support for the Inject Poison mailbox command")
Fixes: 9690b07748d1 ("cxl/memdev: Add support for the Clear Poison mailbox command")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/08721dc1df0a51e4e38fecd02425c3475912dfd5.1701041440.git.alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/memdev.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -331,10 +331,16 @@ int cxl_inject_poison(struct cxl_memdev
 	if (!IS_ENABLED(CONFIG_DEBUG_FS))
 		return 0;
 
-	rc = down_read_interruptible(&cxl_dpa_rwsem);
+	rc = down_read_interruptible(&cxl_region_rwsem);
 	if (rc)
 		return rc;
 
+	rc = down_read_interruptible(&cxl_dpa_rwsem);
+	if (rc) {
+		up_read(&cxl_region_rwsem);
+		return rc;
+	}
+
 	rc = cxl_validate_poison_dpa(cxlmd, dpa);
 	if (rc)
 		goto out;
@@ -362,6 +368,7 @@ int cxl_inject_poison(struct cxl_memdev
 	trace_cxl_poison(cxlmd, cxlr, &record, 0, 0, CXL_POISON_TRACE_INJECT);
 out:
 	up_read(&cxl_dpa_rwsem);
+	up_read(&cxl_region_rwsem);
 
 	return rc;
 }
@@ -379,10 +386,16 @@ int cxl_clear_poison(struct cxl_memdev *
 	if (!IS_ENABLED(CONFIG_DEBUG_FS))
 		return 0;
 
-	rc = down_read_interruptible(&cxl_dpa_rwsem);
+	rc = down_read_interruptible(&cxl_region_rwsem);
 	if (rc)
 		return rc;
 
+	rc = down_read_interruptible(&cxl_dpa_rwsem);
+	if (rc) {
+		up_read(&cxl_region_rwsem);
+		return rc;
+	}
+
 	rc = cxl_validate_poison_dpa(cxlmd, dpa);
 	if (rc)
 		goto out;
@@ -419,6 +432,7 @@ int cxl_clear_poison(struct cxl_memdev *
 	trace_cxl_poison(cxlmd, cxlr, &record, 0, 0, CXL_POISON_TRACE_CLEAR);
 out:
 	up_read(&cxl_dpa_rwsem);
+	up_read(&cxl_region_rwsem);
 
 	return rc;
 }


