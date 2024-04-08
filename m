Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66FF745D6;
	Mon,  8 Apr 2024 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582973; cv=none; b=ly3ojgCDBRFjwTh5qBUAThyNBN8vvj17H5qbUkZoe4gTLApwly5cFiokQb/tU/ncJut032smO97IUQnL2InKQleEc6F/yWhMvg+zsD7P6Py+mUJVLYosXU/Ff7Q5jcgS30lEUDhs82Dt+bkOduSAEIX7fwDeKYWFzfvLGNufK8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582973; c=relaxed/simple;
	bh=deOfXn6mHyTddqIZuewYVsPmbtbCBimmwTtsZEcpbLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYbQubkLBcXmaaX7cfKnrHn+4wuvxoG528WNt9XDmhSr94J281sALrET4mQSjg1TC0zvb3CPkS6oKFTcSI/wz97f1XkYpHd+X3eyL6OuMwZ41AibZ6wD9Cc+kPD8kbTnKFqpitY5CRoTqSZZCPHkRnwIlVjDTt3CljZeCmB3XBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/G0KW46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/G0KW46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCEEC433C7;
	Mon,  8 Apr 2024 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582973;
	bh=deOfXn6mHyTddqIZuewYVsPmbtbCBimmwTtsZEcpbLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/G0KW46wRr0yY0t6Dwds7yk9H2BH94rwybMIJREnBr2drrNkruZ72weFkHsK8o8S
	 ueeOyD7vBz25sCLM4cvl9yHsz5yuWN6x/RXt+h0WtMylE2ay0m8QOqyx2FLbNsQ7+t
	 WGddjHbU/8St/GOxo7IhC8tDwsm2iUYa9QzvxwbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 194/690] docs: Document the FAN_FS_ERROR event
Date: Mon,  8 Apr 2024 14:51:00 +0200
Message-ID: <20240408125406.582050576@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit c0baf9ac0b05d53dfe0436661dbdc5e43c01c5e0 ]

Document the FAN_FS_ERROR event for user administrators and user space
developers.

Link: https://lore.kernel.org/r/20211025192746.66445-32-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 .../admin-guide/filesystem-monitoring.rst     | 74 +++++++++++++++++++
 Documentation/admin-guide/index.rst           |  1 +
 2 files changed, 75 insertions(+)
 create mode 100644 Documentation/admin-guide/filesystem-monitoring.rst

diff --git a/Documentation/admin-guide/filesystem-monitoring.rst b/Documentation/admin-guide/filesystem-monitoring.rst
new file mode 100644
index 0000000000000..5a3c84e60095f
--- /dev/null
+++ b/Documentation/admin-guide/filesystem-monitoring.rst
@@ -0,0 +1,74 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================================
+File system Monitoring with fanotify
+====================================
+
+File system Error Reporting
+===========================
+
+Fanotify supports the FAN_FS_ERROR event type for file system-wide error
+reporting.  It is meant to be used by file system health monitoring
+daemons, which listen for these events and take actions (notify
+sysadmin, start recovery) when a file system problem is detected.
+
+By design, a FAN_FS_ERROR notification exposes sufficient information
+for a monitoring tool to know a problem in the file system has happened.
+It doesn't necessarily provide a user space application with semantics
+to verify an IO operation was successfully executed.  That is out of
+scope for this feature.  Instead, it is only meant as a framework for
+early file system problem detection and reporting recovery tools.
+
+When a file system operation fails, it is common for dozens of kernel
+errors to cascade after the initial failure, hiding the original failure
+log, which is usually the most useful debug data to troubleshoot the
+problem.  For this reason, FAN_FS_ERROR tries to report only the first
+error that occurred for a file system since the last notification, and
+it simply counts additional errors.  This ensures that the most
+important pieces of information are never lost.
+
+FAN_FS_ERROR requires the fanotify group to be setup with the
+FAN_REPORT_FID flag.
+
+At the time of this writing, the only file system that emits FAN_FS_ERROR
+notifications is Ext4.
+
+A FAN_FS_ERROR Notification has the following format::
+
+  [ Notification Metadata (Mandatory) ]
+  [ Generic Error Record  (Mandatory) ]
+  [ FID record            (Mandatory) ]
+
+The order of records is not guaranteed, and new records might be added
+in the future.  Therefore, applications must not rely on the order and
+must be prepared to skip over unknown records. Please refer to
+``samples/fanotify/fs-monitor.c`` for an example parser.
+
+Generic error record
+--------------------
+
+The generic error record provides enough information for a file system
+agnostic tool to learn about a problem in the file system, without
+providing any additional details about the problem.  This record is
+identified by ``struct fanotify_event_info_header.info_type`` being set
+to FAN_EVENT_INFO_TYPE_ERROR.
+
+  struct fanotify_event_info_error {
+	struct fanotify_event_info_header hdr;
+	__s32 error;
+	__u32 error_count;
+  };
+
+The `error` field identifies the type of error using errno values.
+`error_count` tracks the number of errors that occurred and were
+suppressed to preserve the original error information, since the last
+notification.
+
+FID record
+----------
+
+The FID record can be used to uniquely identify the inode that triggered
+the error through the combination of fsid and file handle.  A file system
+specific application can use that information to attempt a recovery
+procedure.  Errors that are not related to an inode are reported with an
+empty file handle of type FILEID_INVALID.
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index dc00afcabb95f..1bedab498104a 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -82,6 +82,7 @@ configure specific aspects of kernel behavior to your liking.
    edid
    efi-stub
    ext4
+   filesystem-monitoring
    nfs/index
    gpio/index
    highuid
-- 
2.43.0



